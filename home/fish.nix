{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (builtins) readFile dirOf baseNameOf;

  hashUpdate = target: storePath: let
    dir = dirOf target;
    base = baseNameOf target;
  in ''
    hash_file="$HOME/.config/${dir}/.${base}.hash"
    full_target="$HOME/.config/${target}"
    store="${storePath}"

    if [ ! -f "$full_target" ] || [ ! -f "$hash_file" ]; then
      install -Dm644 "$store" "$full_target"
      store_hash=$(md5sum "$store" | cut -d' ' -f1)
      echo "$store_hash" > "$hash_file"
    else
      expected=$(cat "$hash_file")
      current=$(md5sum "$full_target" | cut -d' ' -f1)
      store_hash=$(md5sum "$store" | cut -d' ' -f1)
      if [ "$expected" = "$current" ] && [ "$store_hash" != "$current" ]; then
        install -Dm644 "$store" "$full_target"
        echo "$store_hash" > "$hash_file"
      fi
    fi
  '';
in
{
  programs.fish = {
    enable = true;

    shellAliases = {
      # Overrides
      ls = "eza -1 --icons=auto";
      ll = "eza -lha --icons=auto --sort=name --group-directories-first";
      la = "eza -la";
      lt = "eza --icons=auto --tree";
      cat = "bat --theme=base16";
      grep = "grep --color=auto";
      find = "fd";
      top = "btop";
      vim = "nvim";
      vi = "nvim";

      # Extras
      type = "type -a";
      rss = "eilmeldung";
      clear = "printf '\\033[2J\\033[3J\\033[1;1H'";
      q = "qs -c ii";
      down360 = "down 360";
      down480 = "down 480";
      down720 = "down 720";
      down1080 = "down 1080";
      rm = "trash -d";
      cd = "z";
      cp = "cp -r";
      c = "clear";
      l = "eza -lh --icons=auto";
      ld = "eza -lhD --icons=auto";
      vc = "code";
      fastfetch = "fastfetch --logo-type kitty";
      ".." = "cd ..";
      "..." = "cd ../..";
      ".3" = "cd ../../..";
      ".4" = "cd ../../../..";
      ".5" = "cd ../../../../..";
      mkdir = "mkdir -p";
      grub-update = "sudo grub-mkconfig -o /boot/grub/grub.cfg";
    };

    shellAbbrs = {
      gc = "sudo nixos-rebuild boot --flake .#shin";
      gu = "sudo nixos-rebuild boot --flake .#erebos";
      cz = "czkawka";
    };

    interactiveShellInit = ''
      set -g fish_key_bindings fish_vi_key_bindings
      set -Ux fifc_editor nvim
      set -gx MANPAGER "nvim +Man!"

      # Custom functions
      function cur_wall
          noctalia msg wallpaper-get
      end
      function tmux-set
          if set -q NO_TMUX
              return
          end
          if set -q TMUX
              return
          end
          if test "$XDG_SESSION_TYPE" = tty
              return
          end
          if test -f ~/.local/state/tmux_last_session
              set last_choice (string collect < ~/.local/state/tmux_last_session)
          end
          set sessions (tmux ls -F '#S' 2>/dev/null)
          if not set -q TMUX
              switch (count $sessions)
                  case 0
                      tmux new -As main
                  case '*'
                      tmux attach -t "$last_choice"; or tmux new -s "$last_choice"
              end
          end
      end
      function help
          if test (count $argv) -eq 0
              echo "Usage: helpv <command> [arguments...]"
              return 1
          end
          $argv --help ^/dev/stdout | nvim -R -c "set filetype=man" -
      end
      function venv
          if test -z "$argv[1]"
              echo "Usage: venv /path/to/venv"
              return 1
          end
          set venv_path (realpath $argv[1])
          if not test -f "$venv_path/bin/activate.fish"
              echo "Invalid venv: $venv_path"
              return 1
          end
          if functions -q deactivate
              deactivate
          end
          source "$venv_path/bin/activate.fish"
          echo $venv_path >~/.config/fish/venv_state
      end
      function venvoff
          set -eU VENV_PATH
          deactivate
      end
      function down
          set quality $argv[1]
          set args $argv[2..-1]
          yt-dlp -S "res:$quality" -- $args
      end
      function mp4
          yt-dlp $argv[1] -o "$argv[2].mp4"
      end

      # Bindings
      bind -M insert jj 'set fish_bind_mode default; commandline -f repaint-mode'
      bind -M insert \cf clear-and-redraw
      bind \cf clear-and-redraw

      # PATH
      set -gx PATH $HOME/.local/bin $HOME/go/bin $HOME/.cargo/bin $PATH
      set -Ux KUBE_EDITOR nvim
      set -gx TODO_DIR /Media/Docs/notes/TODO
      set -gx TODO_FILE "$TODO_DIR/todo.txt"
      set -gx DONE_FILE "$TODO_DIR/done.txt"
      set UV_LINK_MODE copy
      set -g fish_greeting

      # Source secrets (not tracked by git)
      if test -f ~/.config/fish/secrets.fish
          source ~/.config/fish/secrets.fish
      end

      # Init integrations
      starship init fish | source
      direnv hook fish | source
      zoxide init fish | source
      atuin init fish --disable-up-arrow | source
      bind k _atuin_search
      bind \cr _atuin_search
      bind -M insert \cr _atuin_search

      # Auto-start tmux
      tmux-set

      # fzf colors from matugen
      function _reload_fzf_colors --on-variable _fzf_colors_reload
          if test -f ~/.config/fzf/fzf-colors.fish
              source ~/.config/fzf/fzf-colors.fish
          end
      end
      if test -f ~/.config/fzf/fzf-colors.fish
          source ~/.config/fzf/fzf-colors.fish
      end

      # Colors
      set fish_color_command yellow --bold
      set fish_color_quote magenta
      set fish_color_redirection yellow
      set fish_color_error blue
      set fish_color_valid_path white --bold
    '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # Hash-tracked activation for user-added completions + fisher bootstrap
  home.activation.ensureFishCompletions = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    let
      magickSh = pkgs.writeText "fish-completion-magick-sh" (
        readFile ../config/fish/completions/magick.sh.fish
      );
      recentFilesSh = pkgs.writeText "fish-completion-recent-files-sh" (
        readFile ../config/fish/completions/recent_files.sh.fish
      );
    in
    ''
      ${hashUpdate "fish/completions/magick.sh.fish" magickSh}
      ${hashUpdate "fish/completions/recent_files.sh.fish" recentFilesSh}

      # Write fish_plugins (plugin manifest for fisher)
      mkdir -p "$HOME/.config/fish"
      cat > "$HOME/.config/fish/fish_plugins" << 'EOF'
gazorby/fifc
asim-tahir/opencode.fish
EOF

      # Bootstrap fisher + install all plugins
      if [ ! -f "$HOME/.config/fish/functions/fisher.fish" ]; then
        ${pkgs.fish}/bin/fish -c "
          source (${pkgs.curl}/bin/curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | psub)
          fisher install jorgebucaran/fisher
        "
      fi

      ${pkgs.fish}/bin/fish -c "fisher update" 2>/dev/null || true
    ''
  );
}
