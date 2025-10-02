return {
  "nvimtools/none-ls.nvim",
  enabled = false,
  event = "VeryLazy",
  ft = { "cpp", "c" },
  config = function()
    local null_ls = require("null-ls")
    local helpers = require("null-ls.helpers")
    local clang_tidy_conf = vim.fn.stdpath('config') .. "/lua/configs/lsp/clang-tidy"

    local clang_tidy = {
      name = "clang-tidy",
      method = null_ls.methods.DIAGNOSTICS,
      filetypes = { "cpp", "c" },
      generator = null_ls.generator({
        command = "clang-tidy",
        args = {
          "--config-file=" .. clang_tidy_conf,
          "$FILENAME",
        },
        to_temp_file = true,
        ignore_stderr = true,
        ignore_stdout = false,
        timeout = 2000,
        format = "line",
        check_exit_code = function(code)
          return code >= 1
        end,
        -- use helpers to parse the output from string matchers,
        -- or parse it manually with a function
        on_output = helpers.diagnostics.from_pattern([[(%d+):(%d+): (%w+): (.*)]],
          { "row", "col", "severity", "message" }, {
            severities = {
              note = helpers.diagnostics.severities["warning"],
              style = helpers.diagnostics.severities["hint"],
              performance = helpers.diagnostics.severities["warning"],
              portability = helpers.diagnostics.severities["information"],
            },
          }),
      }),
    }

    null_ls.register(clang_tidy)
  end
}
