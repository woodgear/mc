require("mc.config.actions.windows")
require("mc.config.actions.terminal")

local log = require("mc.util.vlog")
local sext = require("mc.util.string_ext")
local api = vim.api

local init_actions
local gen_actions
local action_list_all_actions
local a_find_file_in_project
local a_find_buffer_in_project
local a_find_string_in_project
local a_find_function_in_current_file
local a_find_function_in_project
local a_delete_current_file
local a_toggle_side

local ALL_ACTIONS = {}
init_actions = function()
    local actions = gen_actions()
    for _, a in ipairs(actions) do
        local cmd_name = sext.snakecase_to_uppercase(a.name)
        ALL_ACTIONS[a.name] = a
        log.info("regx", cmd_name)
        if (a.keys ~= nil) then
            for _, kmap in pairs(a.keys) do
                log.info("  mode", kmap.mode, "key", kmap.key)
                vim.keymap.set(kmap.mode, kmap.key, a.fn, {})
            end
        end
        api.nvim_create_user_command(cmd_name, a.fn, {})
    end

    vim.keymap.set('n', '<leader>ff', a_find_buffer_in_project, {})
    vim.keymap.set('n', '<leader>qq', a_find_string_in_project, {})
    vim.keymap.set('n', '<leader>ii', a_find_function_in_current_file, {})
    vim.keymap.set('n', '<leader>ai', a_find_function_in_project, {})
end

gen_actions = function()
    return {
      action_list_all_actions(),
      a_find_file_in_project(),
      a_delete_current_file(),
      a_toggle_side()
    }
end

a_delete_current_file = function()
    return {
        name = "delete-current-file",
        fn = function()
             local filename = vim.api.nvim_buf_get_name(0)
             os.remove(filename)
             vim.api.nvim_command(':bd!')
        end
    }
end

a_toggle_side = function()

    return {
        name = "toggle-side",
        fn = function()
             vim.api.nvim_command(':NvimTreeToggle')
        end
    }
end

-- l-ide-jump-to-file
a_find_file_in_project = function()
    return {
        name = "list-file-in-project",
        keys = {{
            mode = "n",
            key = "<leader>kk"
        }},
        fn = function()
            local cwd = vim.fn.getcwd()
            local util = require 'lspconfig.util'
            local root = util.find_git_ancestor(cwd)
            log.info("find file cwd " .. cwd .. " root " .. root)
            require'telescope.builtin'.find_files({
                find_command = {'fd', "-L", "-H", ".", root}
            })
        end
    }
end

a_find_buffer_in_project = function()
    local builtin = require('telescope.builtin')
    builtin.buffers()
end

a_find_string_in_project = function()
    local builtin = require('telescope.builtin')
    builtin.live_grep()
end

a_find_function_in_current_file = function()
    local builtin = require('telescope.builtin')
    builtin.lsp_document_symbols({
        symbols = {"method", "function"}
    })
end

a_find_function_in_project = function()
    local builtin = require('telescope.builtin')
    builtin.lsp_workspace_symbols()
end

-- l-ide-eval-actions
action_list_all_actions = function()
    return {
        name = "list-all-actions",
        keys = {{
            mode = "n",
            key = "<leader>xm"
        }},
        fn = function()
            local pickers = require "telescope.pickers"
            local finders = require "telescope.finders"
            local conf = require("telescope.config").values
            local opts = require("telescope.themes").get_dropdown {}
            local ta = require "telescope.actions"
            local action_state = require "telescope.actions.state"
            local action_set = require "telescope.actions.set"
            local actions = {}
            for k, a in pairs(ALL_ACTIONS) do
                local a_entry = {k, a.name}
                log.info("action", a_entry)
                table.insert(actions, a_entry)
            end
            log.info("action", actions)
            local out = pickers.new(opts, {
                prompt_title = "actions",
                finder = finders.new_table {
                    results = actions,
                    entry_maker = function(entry)
                        return {
                            value = entry,
                            display = entry[1],
                            ordinal = entry[1]
                        }
                    end
                },
                sorter = conf.generic_sorter(opts),

                attach_mappings = function(prompt_bufnr, _map)
                    ta.select_default:replace(function()
                        ta.close(prompt_bufnr)
                        local selection = action_state.get_selected_entry()
                        log.info("sel entry", selection )
                        ALL_ACTIONS[selection.value[2]].fn()
                    end)
                    return true
                end

            }):find()
            log.info("out", out)
        end
    }
end

init_actions()
