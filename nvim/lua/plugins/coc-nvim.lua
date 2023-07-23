return {
    "neoclide/coc.nvim",
    branch = 'release',
    config = function()
        local keyset = vim.keymap.set
        -- Autocomplete
        function _G.check_back_space()
            local col = vim.fn.col('.') - 1
            return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
        end

        -- Use Tab for trigger completion with characters ahead and navigate
        -- NOTE: There's always a completion item selected by default, you may want to enable
        -- no select by setting `"suggest.noselect": true` in your configuration file
        -- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
        -- other plugins before putting this into your config
        local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
        keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
        keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

        -- Make <CR> to accept selected completion item or notify coc.nvim to format
        -- <C-g>u breaks current undo, please make your own choice
        keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

        -- Use <c-j> to trigger snippets
        keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
        -- Use <c-space> to trigger completion
        keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})

        -- Use `[g` and `]g` to navigate diagnostics
        -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
        -- keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
        -- keyset("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})

        -- GoTo code navigation
        keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
        keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
        keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
        keyset("n", "gr", "<Plug>(coc-references)", {silent = true})


        -- Use K to show documentation in preview window
        function _G.show_docs()
            local cw = vim.fn.expand('<cword>')
            if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
                vim.api.nvim_command('h ' .. cw)
            elseif vim.api.nvim_eval('coc#rpc#ready()') then
                vim.fn.CocActionAsync('doHover')
            else
                vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
            end
        end
        keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})


        -- Highlight the symbol and its references on a CursorHold event(cursor is idle)
        vim.api.nvim_create_augroup("CocGroup", {})
        vim.api.nvim_create_autocmd("CursorHold", {
            group = "CocGroup",
            command = "silent call CocActionAsync('highlight')",
            desc = "Highlight symbol under cursor on CursorHold"
        })


        -- Symbol renaming
        keyset("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})


        -- Formatting selected code
        keyset("x", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
        keyset("n", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})


        -- Setup formatexpr specified filetype(s)
        vim.api.nvim_create_autocmd("FileType", {
            group = "CocGroup",
            pattern = "c,cpp",
            command = "setl formatexpr=CocAction('formatSelected')",
            desc = "Setup formatexpr specified filetype(s)."
        })

        -- Update signature help on jump placeholder
        vim.api.nvim_create_autocmd("User", {
            group = "CocGroup",
            pattern = "CocJumpPlaceholder",
            command = "call CocActionAsync('showSignatureHelp')",
            desc = "Update signature help on jump placeholder"
        })

        -- Apply codeAction to the selected region
        -- Example: <leader>aap` for current paragraph
        local opts = {silent = true, nowait = true}
        -- keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
        -- keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

        -- Remap keys for apply code actions at the cursor position.
        -- keyset("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
        -- Remap keys for apply source code actions for current file.
        -- keyset("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
        -- Apply the most preferred quickfix action on the current line.
        keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

        -- Remap keys for apply refactor code actions.
        keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
        keyset("x", "<leader>r", "<Plug>(coc-codeaction-rfactor-selected)", { silent = true })
        keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

        -- Run the Code Lens actions on the current line
        keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)

        -- Remap <C-f> and <C-b> to scroll float windows/popups
        ---@diagnostic disable-next-line: redefined-local
        local opts = {silent = true, nowait = true, expr = true}

        -- " Add `:Fold` command to fold current buffer
        vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", {nargs = '?'})

        -- Add (Neo)Vim's native statusline support
        -- NOTE: Please see `:h coc-status` for integrations with external plugins that
        -- provide custom statusline: lightline.vim, vim-airline
        vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")

        -- Mappings for CoCList
        -- code actions and coc stuff
        ---@diagnostic disable-next-line: redefined-local
        local opts = {silent = true, nowait = true}
        -- Show all diagnostics
        keyset("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
        -- Manage extensions
        keyset("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
        -- Show commands
        keyset("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
        -- Find symbol of current document
        keyset("n", "<space>o", ":<C-u>CocList outline<cr>", opts)
        -- Search workspace symbols
        keyset("n", "<space>s", ":<C-u>CocList -I symbols<cr>", opts)
        -- Do default action for next item
        keyset("n", "<space>j", ":<C-u>CocNext<cr>", opts)
        -- Do default action for previous item
        keyset("n", "<space>k", ":<C-u>CocPrev<cr>", opts)
        -- Resume latest coc list
        keyset("n", "<space>p", ":<C-u>CocListResume<cr>", opts)

        vim.g.coc_global_extensions = {'coc-json','coc-lists','coc-clangd','coc-pyright','coc-actions','coc-snippets','coc-syntax'}

        -- switch .cpp file and .h file use <leader>a
        keyset("n", "<leader>a", ":CocCommand clangd.switchSourceHeader vsplit<CR>", opts)
        -- To fix the highlight of comment
        vim.cmd[[autocmd FileType json syntax match Comment +\/\/.\+$+]]
        vim.g.diagnostic_enable = 0

        function ToggleDiagnostics()
            vim.cmd[[let g:diagnostic_enable = get(g:, 'diagnostic_enable', 0) == 0 ? 1 : 0]]
            vim.cmd[[call CocAction('diagnosticToggle', diagnostic_enable)]]
        end
    keyset("n", "dt", ToggleDiagnostics, opts)

    end


}
