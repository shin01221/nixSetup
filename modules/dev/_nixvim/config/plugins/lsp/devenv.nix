{
  extraConfigLua = ''
    local function devenv_lsp(name)
      local root = vim.fs.root(0, { 'devenv.nix', '.git' })
        or vim.fs.dirname(vim.fs.find({ 'devenv.nix' }, { upward = true })[1])
        or vim.fn.getcwd()
      local bin = root .. '/.devenv/profile/bin/' .. name
      if vim.fn.executable(bin) ~= 1 then
        vim.notify(name .. ' not found in devenv profile', vim.log.levels.WARN)
        return
      end

      local function start()
        vim.lsp.start({ name = name, cmd = { bin }, root_dir = root })
      end

      start()
      vim.defer_fn(function()
        if #vim.lsp.get_clients({ name = name, bufnr = 0 }) == 0 then
          vim.lsp.start({ name = name, cmd = { bin, '--stdio' }, root_dir = root })
        end
      end, 1500)
    end

    vim.api.nvim_create_user_command('DevenvLsp', function(a)
      devenv_lsp(a.args)
    end, { nargs = 1 })
  '';
}
