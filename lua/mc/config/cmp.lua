local log = require("mc.util.vlog")
local cmp_status_ok, cmp = pcall(require, "cmp")
local lspkind = require("lspkind")

require("copilot").setup({
    suggestion = {enabled = false},
    panel = {enabled = false}
})
require("copilot_cmp").setup()

if not cmp_status_ok then return end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then return end

local check_backspace = function()
    local col = vim.fn.col "." - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
        return false
    end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
               vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match(
                   "^%s*$") == nil
end


cmp.setup {
    snippet = {
        expand = function(args)
            -- log.info("cmp luasnip expand", args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
        end
    },
    mapping = {
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), {"i", "c"}),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), {"i", "c"}),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), {"i", "c"}),
        ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ["<C-e>"] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close()
        },
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ["<CR>"] = cmp.mapping.confirm {select = true},

        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() and has_words_before() then
                log.info("cmp visible and has words before")
                cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
                return
            end
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expandable() then
                luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif check_backspace() then
                fallback()
            else
                fallback()
            end
        end, {"i", "s"}),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {"i", "s"})
    },
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol",
            max_width = 50,
            symbol_map = {Copilot = ""}
        })
    },
    sources = {
        {name = "copilot", group_index = 2}, {name = "luasnip"},
        {name = "nvim_lua"}, {
            name = "nvim_lsp",
            entry_filter = function(entry, _)
                return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
            end
        }, {name = "buffer"}, {name = "path"},
        {name = 'nvim_lsp_signature_help'}, {name = 'vim_lsp'},
        {name = 'nvim_lsp_document_symbol'}
    },
    confirm_opts = {behavior = cmp.ConfirmBehavior.Replace, select = false},
    window = {documentation = cmp.config.window.bordered()},
    experimental = {ghost_text = true, native_menu = false}
}

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
