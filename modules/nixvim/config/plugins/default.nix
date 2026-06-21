{
  imports = [
    # ./ai/avante.nix
    # ./ai/copilot-lua.nix
    # ./ai/copilot-lsp.nix
    ./ai/opencode.nix
    # ./ai/sidekick.nix

    ./completion/blink.nix
    ./completion/friendly-snippets.nix
    # ./completion/lspkind.nix

    ./debug/dap.nix

    ./editor/lz-n.nix
    # ./editor/neotree.nix
    ./editor/faster
    ./editor/neogen.nix
    # ./editor/undotree.nix
    ./editor/whichkey.nix
    ./editor/yanky.nix
    ./editor/oil.nix
    ./editor/vim-tmux-navigator.nix

    ./theme
    ./theme/colorsaver.nix
    # ./theme/matugen.nix
    ./luasnip

    ./mini

    ./snacks

    # ./telescope

    ./git/gitsigns.nix

    ./lsp/conform.nix
    ./lsp/fastaction.nix
    ./lsp/lsp.nix
    # ./lsp/lspsaga.nix
    ./lsp/otter.nix
    ./lsp/trouble.nix

    ./lang/cpp.nix
    ./lang/css.nix
    ./lang/docker.nix
    ./lang/html.nix
    ./lang/json.nix
    ./lang/lua.nix
    ./lang/markdown.nix
    ./lang/nix.nix
    ./lang/obsidian.nix
    ./lang/python.nix
    ./lang/shell.nix
    ./lang/typescript.nix
    ./lang/yaml.nix

    ./treesitter/treesitter.nix
    ./treesitter/treesitter-textobjects.nix
    ./treesitter/ts-comments.nix

    ./ui/alpha.nix
    ./ui/bufferline.nix
    ./ui/general.nix
    ./ui/flash.nix
    ./ui/lightbulb.nix
    ./ui/lualine.nix
    ./ui/noice.nix
    ./ui/notify.nix
    ./ui/nui.nix
    ./ui/precognition.nix
    ./ui/toggleterm.nix
    ./ui/markdown-preview.nix
    ./ui/transparent.nix
    ./ui/better-diagnostics.nix
    ./ui/render-markdown.nix
    ./ui/markdoc.nix
    ./ui/markdowny.nix
    # ./ui/ufo.nix

    ./util/colorizer.nix
    ./util/compiler.nix
    ./util/devdocs.nix
    # ./util/firenvim.nix
    ./util/glance.nix
    # ./util/hardtime.nix
    ./util/img-clip.nix
    # ./util/kulala.nix
    ./util/nvim-autopairs.nix
    ./util/nvim-surround.nix
    ./util/overseer.nix
    ./util/plenary.nix
    ./util/persistence.nix
    ./util/package-info.nix
    ./util/refactoring.nix
    ./util/todo-comments.nix
    ./util/mtoc.nix
  ];
}
