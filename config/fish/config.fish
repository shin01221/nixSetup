set EDITOR nvim
set UV_LINK_MODE copy
set -gx TODO_DIR /Media/Docs/notes/TODO
set -gx TODO_FILE "$TODO_DIR/todo.txt"
set -gx DONE_FILE "$TODO_DIR/done.txt"

set -Ux KUBE_EDITOR nvim

set -g fish_key_bindings fish_vi_key_bindings
set -Ux fifc_editor nvim
set -gx MANPAGER "nvim +Man!"

function cur_wall
    noctalia msg wallpaper-get
end

bind -M insert jj 'set fish_bind_mode default; commandline -f repaint-mode'
bind -M insert \cf clear-and-redraw
bind \cf clear-and-redraw

# sourcing my functions
for f in ~/.config/fish/functions/user/*.fish
    source $f
end

set -gx PATH $HOME/.local/bin $HOME/go/bin $HOME/.cargo/bin $PATH
set -Ux JAVA_HOME /usr/lib/jvm/java-21-openjdk

# Source secrets (not tracked by git)
if test -f ~/.config/fish/secrets.fish
    source ~/.config/fish/secrets.fish
end

starship init fish | source
if status is-interactive # Commands to run in interactive sessions can go here
    set fish_greeting
end

direnv hook fish | source

zoxide init fish | source
atuin init fish --disable-up-arrow | source
bind k _atuin_search
bind \cr _atuin_search
bind -M insert \cr _atuin_search
source ~/.config/fish/atuin.fish

# Auto start Hyprland on tty1
# if test -z "$DISPLAY"; and test "$XDG_VTNR" -eq 1
#     mkdir -p ~/.cache
#     exec start-hyprland >~/.cache/hyprland.log 2>&1
# end

# colors
set fish_color_command yellow --bold
set fish_color_quote magenta
set fish_color_redirection yellow
set fish_color_error blue
set fish_color_valid_path white --bold

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

# aliases
alias type 'type -a'
alias rss eilmeldung
alias pamcan pacman
alias ls 'eza --icons'
# alias ip 'ip -c'
alias clear "printf '\033[2J\033[3J\033[1;1H'"
alias q 'qs -c ii'
alias down360='down 360'
alias down480='down 480'
alias down720='down 720'
alias down1080='down 1080'
alias mirrors='sudo reflector --verbose --country Germany,France,Italy --latest 40 --sort rate --download-timeout 6 --protocol https --save /etc/pacman.d/mirrorlist'
# alias mirrors='sudo reflector --verbose --protocol https --sort rate --latest 70 --download-timeout 6 --save /etc/pacman.d/mirrorlist'
alias grep='grep --color=auto'
alias p='sudo pacman'
alias rm='trash -d'
alias cd='z'
alias cp='cp -r'
alias cat="bat --theme=base16"
alias grub-update="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias c='clear' # clear terminal
alias l='eza -lh --icons=auto' # long list
alias ls='eza -1 --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree
alias un='yay -Rns' # uninstall package
alias up='yay -Syu' # update system/package/aur
alias pl='yay -Qs' # list installed package
alias pa='yay -Ss' # list available package
alias pc='yay -Sc' # remove unused cache
alias po='yay -Qtdq | yay -Rns -' # remove unused packages, also try > $aurhelper -Qqd | $aurhelper -Rsu --print -
alias vc='code' # gui code editor
alias fastfetch='fastfetch --logo-type kitty'
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias mkdir='mkdir -p'
# function fish_command_not_found
#     # Play sound in background
#     paplay /home/shin/.local/share/fahhh/fahhh.mp3 >/dev/null 2>&1 &
#
#     # Print error message
#     echo "fish: command not found: [1]" >&2
#
#     return 127
# end
