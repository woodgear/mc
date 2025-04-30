require("mc.config.actions.panels")
require("mc.config.actions.terminal")

local async = require('async')
local cc = require("mc.config.curcfg")
local file_ext = require("mc.util.file_ext")
local action_manager = require("mc.config.actions.action_manager")
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local ta = require "telescope.actions"
local action_state = require "telescope.actions.state"
local action_set = require "telescope.actions.set"
local log = require("mc.util.vlog")
local aui = require("mc.util.async_ui")

local actions = {
    {
        name = "demo-actions",
        fn = function() log.info("local cfg  is ", cc.get_current_cfg()) end
    }, {name = "quit-nvim", fn = function() vim.api.nvim_command(":qa!") end},
    {
        name = "reload-nvim-config",
        fn = function()
            for name, _ in pairs(package.loaded) do
                if name:match('^mc.') then
                    package.loaded[name] = nil
                end
            end
            dofile(vim.env.MYVIMRC)
            vim.notify('Config reloaded!', vim.log.levels.INFO)
        end
    }, {
        name = "open-file-in-splited-right",
        fn = function()
            async(function()
                local p = await(aui.async_ui_select_file_in_project())
                vim.api.nvim_command(':rightbelow vsp ' .. p)
            end)
        end
    }, {
        name = "edit-mc",
        fn = function()
            vim.api.nvim_command(':tabnew mc')
            vim.api.nvim_command(':e ' .. vim.fn.stdpath "config")
        end
    }, {
        name = "new-tab",
        keys = {{mode = "n", key = "<leader>nt"}},
        fn = function()
            async(function()
                local p = await(aui.async_ui_input())
                vim.api.nvim_command(':tabnew ' .. p)
            end)
        end
    }, {
        name = "sel-tab",
        keys = {{mode = "n", key = "<leader>st"}},
        fn = function() vim.api.nvim_command('Tabby jump_to_tab') end
    }, {
        name = "sel-window",
        keys = {{mode = "n", key = "<leader>sw"}},
        fn = function() vim.api.nvim_command('Tabby pick_window') end
    }, {
        name = "rename-tab",
        keys = {{mode = "n", key = "<leader>rt"}},
        fn = function()
            async(function()
                local p = await(aui.async_ui_input())
                vim.api.nvim_command('Tabby rename_tab ' .. p)
            end)
        end
    }, {
        name = "close-tab",
        keys = {{mode = "n", key = "<leader>ct"}},
        fn = function() vim.api.nvim_command('tabclose') end
    }, {
        name = "eval-current-lua-file",
        keys = {{mode = "n", key = "<leader>el"}},
        fn = function() vim.api.nvim_command('luafile %:p') end
    }, {
        name = "run-loop",
        keys = {{mode = "n", key = "<leader>l"}},
        fn = function() vim.api.nvim_command('silent ! ./loop.sh;\n') end
    }, {
        name = "delete-current-file",
        fn = function()
            local filename = vim.api.nvim_buf_get_name(0)
            os.remove(filename)
            vim.api.nvim_command(':bd!')
        end
    }, {
        name = "toggle-side",
        keys = {{mode = "n", key = "<leader>ts"}},
        aliass = {"close-side", "open-side"},
        fn = function() vim.api.nvim_command(':NvimTreeToggle') end
    }, {
        name = "focus-file-on-side",
        fn = function()
            local real_fn = function(opt)
                if opt.path == nil then
                    log.info("args is empty.ignote")
                    return
                else
                    -- log.info("focus " .. tostring(opt.path))
                    require("nvim-tree.actions.finders.find-file").fn(opt.path)
                end
            end
            vim.ui.input({prompt = "path: "}, function(input)
                if input ~= nil then real_fn({path = input}) end
            end)
        end
    }, {
        name = "find-file-in-project",
        keys = {{mode = "n", key = "<leader>kk"}},
        fn = function()
            async(function()
                local p = await(aui.async_ui_select_file_in_project())
                log.info("p is ", p)
                log.info("in find file in project sel path", p)
                local f_type = file_ext.check_path_type(p)
                if f_type == "file" then
                    log.info("p is ", p)
                    vim.schedule(function()
                        vim.api.nvim_command('edit ' .. p)
                    end)
                elseif f_type == "dir" then
                    -- log.info("is a dir " .. p)
                    local tree_api = require("nvim-tree.api")
                    tree_api.tree
                        .find_file({buf = p, focus = true, open = true})
                    local node = require("nvim-tree.lib").get_node_at_cursor()
                    require("nvim-tree.lib").expand_or_collapse(node)
                else
                    log.info("?? " .. p .. f_type)
                end
            end)
        end
    }, {
        name = "format",
        keys = {{mode = "n", key = "<leader>fm"}},
        fn = function() vim.cmd(":FormatWrite") end
    }, {
        name = "find-buffer-in-project",
        keys = {{mode = "n", key = "<leader>ff"}},
        fn = function()
            local builtin = require('telescope.builtin')
            builtin.buffers()
        end
    }, {
        name = "find-string-in-project",
        keys = {{mode = "n", key = "<leader>qq"}},
        fn = function()
            local builtin = require('telescope.builtin')
            builtin.live_grep()
        end
    }, {
        name = "find-function-in-current-file",
        keys = {{mode = "n", key = "<leader>ii"}},
        fn = function()
            local builtin = require('telescope.builtin')
            builtin.lsp_document_symbols({symbols = {"method", "function"}})
        end
    }, {
        name = "jump-back",
        keys = {{mode = "n", key = "<leader>jb"}},
        fn = function()
            log.info("jump back")
            vim.api.nvim_command('normal! <C-o>')
        end
    }, {
        name = "list-all-actions",
        keys = {{mode = "n", key = "<leader>xm"}},
        fn = function()
            aui.async_ui_select_and_eval(action_manager.get_actions())
        end
    }, {
        name = "toggle-term",
        keys = {{mode = "n", key = "<leader>tt"}},
        fn = function() vim.api.nvim_command('ToggleTerm') end
    }
}

action_manager.init_actions(actions)

vim.o.showtabline = 2

require('tabby').setup()
