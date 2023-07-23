return{
    "preservim/tagbar",
keys = {
    { "<leader>t", "<cmd>TagbarToggle<cr>", desc = "Tagbar" },
},
config = function ()
vim.g.tagbar_width = 40
vim.g.tagbar_autofocus = 1
vim.g.tagbar_sort = 1
vim.g.tagbar_autoshowtag = 0
vim.g.tagbar_position = 'topleft vertical'
vim.cmd[[let g:tagbar_scopestrs = {
           \    'class': "\uf0e8",
           \    'const': "\uf8ff",
           \    'constant': "\uf8ff",
           \    'enum': "\uf702",
           \    'field': "\uf30b",
           \    'func': "\uf794",
           \    'function': "\uf794",
           \    'getter': "\ufab6",
           \    'implementation': "\uf776",
           \    'interface': "\uf7fe",
           \    'map': "\ufb44",
           \    'member': "\uf02b",
           \    'method': "\uf6a6",
           \    'setter': "\uf7a9",
           \    'variable': "\uf71b",
           \ }]]

vim.cmd[[let g:tagbar_type_cpp = {
                       \ 'ctagstype' : 'c++',
                       \ 'kinds'     : [
                       \ 'd:macros:1:0',
                       \ 'p:prototypes:1:0',
                       \ 'g:enums',
                       \ 'e:enumerators:0:0',
                       \ 't:typedefs:0:0',
                       \ 'n:namespaces',
                       \ 'c:classes',
                       \ 's:structs',
                       \ 'u:unions',
                       \ 'f:functions',
                       \ 'm:members:0:0',
                       \ 'v:variables:0:0'
                       \ ],
                       \ 'sro'        : '::',
                       \ 'kind2scope' : {
                       \ 'g' : 'enum',
                       \ 'n' : 'namespace',
                       \ 'c' : 'class',
                       \ 's' : 'struct',
                       \ 'u' : 'union'
                       \ },
                       \ 'scope2kind' : {
                       \ 'enum'      : 'g',
                       \ 'namespace' : 'n',
                       \ 'class'     : 'c',
                       \ 'struct'    : 's',
                       \ 'union'     : 'u'
                       \ }
                       \ }]]
end

}
