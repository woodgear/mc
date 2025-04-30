local async = require('async')
local promise = require('promise')
local ta = require "telescope.actions"
local action_state = require "telescope.actions.state"
local action_set = require "telescope.actions.set"
local log = require("mc.util.vlog")
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local st = require("mc.util.string_ext")

local m = {
}

m.async_ui_input = function(prompt)
    return promise:new(function(resolve, reject)
        vim.ui.input({ prompt = prompt }, function(input) resolve(input) end)
    end)
end

m.async_ui_select_file_in_project = function()
    return promise:new(function(resolve, reject)
        require 'telescope.builtin'.find_files({
            find_command = {
                'fd', "-t", "f", "--exclude", ".git", "-L", ".",
            },
            attach_mappings = function(prompt_bufnr, _)
                ta.select_default:replace(function()
                    ta.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    local path = selection[1]
                    resolve(path)
                end)
                return true
            end
        })
    end)
end

m.async_ui_select_and_eval = function(ALL)
    local conf = require("telescope.config").values
    local opts = require("telescope.themes").get_dropdown {}
    local actions = {}
    local action_map = {}

    local prefix_key_hint = function(name, hint)
        if hint == nil or hint == "" then
            return name
        end
        return "(" .. hint .. ")" .. name
    end

    for k, a in pairs(ALL) do
        action_map[a.name] = a
        local key_hint = ""
        if a.keys ~= nil then
            for _, k in ipairs(a.keys) do
                key_hint = key_hint .. k.mode .. st.replace(k.key, "<leader>", ",") .. " "
            end
        end
        local a_entry = { key = a.name, name = a.name, display = prefix_key_hint(a.name, key_hint) }
        if a.aliass ~= nil then
            for _, n in ipairs(a.aliass) do
                local link_entry = {
                    key = a.name,
                    name = n,
                    display = prefix_key_hint(n .. " -> " .. a.name, key_hint)
                }
                table.insert(actions, link_entry)
            end
        end
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
                    display = entry["display"],
                    ordinal = entry["name"] -- only use to sort
                }
            end
        },
        sorter = conf.generic_sorter(opts),

        attach_mappings = function(prompt_bufnr, _map)
            ta.select_default:replace(function()
                ta.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                log.info("sel entry", selection)
                local action = action_map[selection.value["key"]]
                if action.args then
                    action.fn(action.get_args())
                else
                    action.fn()
                end
            end)
            return true
        end
    }):find()
end

return m
