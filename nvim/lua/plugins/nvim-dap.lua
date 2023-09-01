-- Usage reference:https://cloud.tencent.com/developer/article/2203813
return {
    {
        "mfussenegger/nvim-dap",
        -- only load in linux
        cond = function()
            return vim.fn.has("unix") == 1 and vim.fn.has("macunix") == 0
        end,

        config = function()
            local dap_breakpoint_color = {
                breakpoint = {
                    ctermbg = 0,
                    fg = '#f00707',
                    bg = '#31353f',
                },
                logpoing = {
                    ctermbg = 0,
                    fg = '#61afef',
                    bg = '#31353f',
                },
                stopped = {
                    ctermbg = 0,
                    fg = '#2ad138',
                    bg = '#31353f'
                },
            }

            vim.api.nvim_set_hl(0, 'DapBreakpoint', dap_breakpoint_color.breakpoint)
            vim.api.nvim_set_hl(0, 'DapLogPoint', dap_breakpoint_color.logpoing)
            vim.api.nvim_set_hl(0, 'DapStopped', dap_breakpoint_color.stopped)

            local dap_breakpoint = {
                error = {
                    text = "",
                    texthl = "DapBreakpoint",
                    linehl = "DapBreakpoint",
                    numhl = "DapBreakpoint",
                },
                condition = {
                    text = '󰆗',
                    texthl = 'DapBreakpoint',
                    linehl = 'DapBreakpoint',
                    numhl = 'DapBreakpoint',
                },
                rejected = {
                    text = "",
                    texthl = "DapBreakpint",
                    linehl = "DapBreakpoint",
                    numhl = "DapBreakpoint",
                },
                logpoint = {
                    text = '',
                    texthl = 'DapLogPoint',
                    linehl = 'DapLogPoint',
                    numhl = 'DapLogPoint',
                },
                stopped = {
                    text = '',
                    texthl = 'DapStopped',
                    linehl = 'DapStopped',
                    numhl = 'DapStopped',
                },
            }

            vim.fn.sign_define('DapBreakpoint', dap_breakpoint.error)
            vim.fn.sign_define('DapBreakpointCondition', dap_breakpoint.condition)
            vim.fn.sign_define('DapBreakpointRejected', dap_breakpoint.rejected)
            vim.fn.sign_define('DapLogPoint', dap_breakpoint.logpoint)
            vim.fn.sign_define('DapStopped', dap_breakpoint.stopped)

            local keymap = vim.keymap.set
            local opts = 
            keymap("n", "<Space>p", ":lua require'dap'.toggle_breakpoint()<cr>", { noremap = true, silent = true, desc = "dap toggle break[p]oint" })
            keymap("n", "<Space>r", ":lua require'dap'.continue()<cr>",          { noremap = true, silent = true, desc = "dap [r]un"})
            keymap("n", "<Space>o", ":lua require'dap'.step_over()<cr>",         { noremap = true, silent = true, desc = "dap setp [o]ver"})
            keymap("n", "<Space>i", ":lua require'dap'.step_into()<cr>",         { noremap = true, silent = true, desc = "dap setp [i]nto"})

            local dap = require("dap")

            dap.adapters.cppdbg = {
                id = "cppdbg",
                type = 'executable',
                command = "/Users/star/.local/share/nvim/mason/bin/OpenDebugAD7",
            }

            dap.configurations.cpp = {
                {
                    name = "Launch file",
                    type = "cppdbg",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,

                    cwd = "${workspaceFolder}",
                    stopAtEntry = true,
                },
            }
            dap.configurations.c = dap.configurations.cpp
        end
    },
    {
        "rcarriga/nvim-dap-ui",
        -- only load in linux
        cond = function()
            return vim.fn.has("unix") == 1 and vim.fn.has("macunix") == 0
        end,
        dependencies = {
            "mfussenegger/nvim-dap",
            "theHamsta/nvim-dap-virtual-text",
        },
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup({})
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            vim.keymap.set("n", "<Space>q", ":lua require('dapui').close()<cr>", { noremap = true, silent = true, desc = "dapui quit"})
            vim.keymap.set("n", "<Space>d", ":lua require('dapui').open()<cr>",  { noremap = true, silent = true, desc = "dapui open"})

            require("nvim-dap-virtual-text").setup({
                enabled = true,
                enable_commands = true,
                highlight_changed_variables = true,
                highlight_new_as_changed = false,
                show_stop_reason = true,
                commented = false,
                only_first_definition = true,
                all_references = false,
                filter_references_pattern = '<module',
                virt_text_pos = 'eol',
                all_frames = false,
                virt_lines = false,
                virt_text_win_col = nil
            })
        end
    }
}
