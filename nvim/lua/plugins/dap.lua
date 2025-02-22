return {
  {
    "mfussenegger/nvim-dap",
    enabled = not require("configs.utils").is_diff_mode(),
    keys = {
      { "<Space>db", function() require 'dap'.toggle_breakpoint() end, desc = "DAP Toggle Breakpoint" },
      { "<Space>dr", function() require("dap").continue() end,         desc = "DAP Run/Continue" },
      { "<Space>dc", function() require("dap").run_to_cursor() end,    desc = "DAP Run to Cursor" },
      { "<Space>di", function() require("dap").step_into() end,        desc = "DAP Step Into" },
      { "<Space>dg", function() require("dap").goto_() end,            desc = "DAP Go to Line (No Execute)" },
      { "<Space>do", function() require("dap").step_over() end,        desc = "DAP Step Over" },
    },
    dependencies = {
      "rcarriga/nvim-dap-ui",
      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },
    config = function()
      local dap = require("dap")

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

      dap.adapters.lldb = {
        type = 'executable',
        command = vim.fn.stdpath("data") .. "/mason/bin/codelldb", -- adjust as needed, must be absolute path
        name = 'lldb'
      }

      dap.configurations.cpp = {
        {
          name = 'Launch',
          type = 'lldb',
          request = 'launch',
          args = function()
            local args_string = vim.fn.input("Input arguments: ")
            return vim.split(args_string, " ")
          end,
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }

      dap.configurations.c = dap.configurations.cpp
    end
  },

  {
    "rcarriga/nvim-dap-ui",
    enabled = not require("configs.utils").is_diff_mode(),
    dependencies = { "nvim-neotest/nvim-nio" },
    keys = { { "<Space>du", function() require("dapui").toggle({}) end, desc = "DAP UI Toggle" }, },
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
    end
  },
}
