-- Load plugin modules in order.

require 'kickstart.plugins.guess-indent'
require 'kickstart.plugins.gitsigns'
require 'kickstart.plugins.which-key'
require 'kickstart.plugins.tokyonight'
require 'kickstart.plugins.todo-comments'
require 'kickstart.plugins.mini'
require 'kickstart.plugins.telescope'
require 'kickstart.plugins.lspconfig'
require 'kickstart.plugins.conform'
require 'kickstart.plugins.blink-cmp'
require 'kickstart.plugins.treesitter'

-- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
-- init.lua. If you want these files, they are in the repository, so you can just download them and
-- place them in the correct locations.

-- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
--
--  Here are some example plugins that I've included in the Kickstart repository.
--  Uncomment any of the lines below to enable them (you will need to restart nvim).
--
require 'kickstart.plugins.debug'
-- require 'kickstart.plugins.indent_line'
-- require 'kickstart.plugins.lint'
-- require 'kickstart.plugins.autopairs'
require 'kickstart.plugins.neo-tree'
require 'kickstart.plugins.gitsigns' -- adds gitsigns recommended keymaps


vim.pack.add({
  { src = 'https://github.com/scalameta/nvim-metals' },
  { src = 'https://github.com/j-hui/fidget.nvim' },
  { src = 'https://github.com/mfussenegger/nvim-dap' },

  -- other plugins...
})

require('fidget').setup({})

local metals = require('metals')
local metals_config = metals.bare_config()

metals_config.settings = {
  showImplicitArguments = true,

  excludedPackages = {
    'akka.actor.typed.javadsl',
    'com.github.swagger.akka.javadsl',
  },
}

metals_config.init_options.statusBarProvider = 'off'

metals_config.on_attach = function(client, bufnr)
  -- Required for Metals debugging support
  metals.setup_dap()

  -- Native Neovim 0.12 completion
  if client:supports_method('textDocument/completion') then
    vim.lsp.completion.enable(true, client.id, bufnr, {
      autotrigger = true,
    })
  end

  local function map(lhs, rhs, desc)
    vim.keymap.set('n', lhs, rhs, {
      buffer = bufnr,
      silent = true,
      desc = desc,
    })
  end

  map('gD', vim.lsp.buf.definition, 'Definition')
  map('K', vim.lsp.buf.hover, 'Hover')
  map('gi', vim.lsp.buf.implementation, 'Implementation')
  map('gr', vim.lsp.buf.references, 'References')
  map('gds', vim.lsp.buf.document_symbol, 'Document symbols')
  map('gws', vim.lsp.buf.workspace_symbol, 'Workspace symbols')

  map('<leader>ca', vim.lsp.buf.code_action, 'Code action')
  map('<leader>rn', vim.lsp.buf.rename, 'Rename')
  map('<leader>cl', vim.lsp.codelens.run, 'Code lens')

  map('<leader>f', function()
    vim.lsp.buf.format({ async = true })
  end, 'Format')
end

local metals_group =
  vim.api.nvim_create_augroup('nvim-metals', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  group = metals_group,
  pattern = { 'scala', 'sbt', 'java' },
  callback = function()
    metals.initialize_or_attach(metals_config)
  end,
})
-- NOTE: You can add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
--
--  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
-- require 'custom.plugins'

-- vim: ts=2 sts=2 sw=2 et
