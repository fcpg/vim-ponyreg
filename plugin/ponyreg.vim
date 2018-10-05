" Ultra-magic regexps

if exists('g:ponyreg_loaded')
  finish
endif

cnoremap  <C-x>/  <C-\>e ponyreg#CmdlineExpandPonyreg()<cr>
cnoremap  <C-x>u  <C-\>e get(g:, 'old_cmdline', '')<cr>

let g:ponyreg_loaded = 1
