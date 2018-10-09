" Ultra-magic regexps

"------------
" Const {{{1
"------------
" pattern for unescaped stuff
let s:ue = '\%(\%(^\|[^\\]\)\\\%(\\\\\)*\)\@<!'.
         \ "\\%(\x1c\\)\\@<!"
" internal escaping char
let s:esc = "\x1c"


"------------
" Debug {{{1
"------------
if 0
append
  " comment out all dbg calls
  :g,\c^\s*call <Sid>Dbg(,s/call/"call/
  " uncomment
  :g,\c^\s*"call <Sid>Dbg(,s/"call/call/
.
endif


"----------------
" Functions {{{1
"----------------

" ponyreg#Search() {{{2
" search for pony-regexp (prompt if none given)
function! ponyreg#Search(...) abort
  let ponyre = a:0 ? a:1 : input('=/')
  if ponyre == ''
    return
  endif
  let re = ponyreg#Magic(ponyre)
  call feedkeys('/'.re."\<cr>", 'ti')
endfun

" ponyreg#CmdlineExpandPonyreg() {{{2
" cmap to <C-\>e
function! ponyreg#CmdlineExpandPonyreg() abort
  let cmdl = getcmdline()
  let g:old_cmdline = cmdl
  if cmdl == ''
    return ''
  endif
  if getcmdtype() is ':'
    let cmdp = getcmdpos()
    let pdelim = get(g:, 'pony_delim', '/')
    if cmdl[cmdp - 1] == pdelim
      let re_spos = strridx(cmdl, pdelim, cmdp - 2)
    else
      let re_spos = match(cmdl,
            \ '\v\K@<!%(s%[ubstitute]|g%[lobal]|v%[global])\zs[]!#-/:-@[^-`{}~]'
            \)
    endif
    if re_spos == -1
      return cmdl
    endif
    let re_delim = cmdl[re_spos]
    let bef_re = strpart(cmdl, 0, re_spos+1)
    let re_epos = match(cmdl, re_delim, re_spos+1)
    let aft_re = re_epos != -1
          \ ? strpart(cmdl, re_epos)
          \ : ''
    let ponyre = re_epos != -1
          \ ? strpart(cmdl, re_spos+1, (re_epos - re_spos - 1))
          \ : strpart(cmdl, re_spos+1)
    let re = ponyreg#Magic(ponyre)
    let newcmd = bef_re . re . aft_re
  else
    let newcmd = ponyreg#Magic(cmdl)
  endif
  call setcmdpos(len(newcmd))
  return newcmd
endfun

" ponyreg#Magic() {{{2
" turn pony-re into vim verymagic re
function! ponyreg#Magic(ponyre) abort
  let re = a:ponyre
  " x1c escaping
  let re = substitute(re, 
        \ s:ue.'\\\([a-zA-Z0-9]\)',
        \ s:esc.'\1',
        \ 'g')
    call <Sid>Debug("after x1c escaping: ".re)
  " quote expansion
  let re = substitute(re,
        \ '"\([^"]\+\%(\\\@<="[^"]*\)*\)"',
        \ '\="(\V".substitute(submatch(1), "[a-zA-Z0-9]", "'.s:esc.'&", "g")."\v)"',
        \ 'g')
    call <Sid>Debug("after quote expansion: ".re)
  " posix class escaping
  let re = substitute(re,
        \ s:ue.':\(alnum\|alpha\|blank\|cntrl\|digit\|graph\|lower\|print\|punct\|space\|upper\|xdigit\|return\|tab\|escape\|backspace\):',
        \ '\=":".substitute(submatch(1), "[a-zA-Z0-9]", "'.s:esc.'&", "g").":"',
        \ 'g')
    call <Sid>Debug("after posix class escaping: ".re)
  " zs/ze escaping
  let re = substitute(re, 
        \ s:ue.'\(z\)\([se]\)',
        \ '\\'.s:esc.'\1'.s:esc.'\2',
        \ 'g')
    call <Sid>Debug("after zs/ze escaping: ".re)
  " %digit expansion
  let re = substitute(re, 
        \ s:ue.'%\([<>]\=\)\(\d\+\)\([lcv]\)',
        \ '%\1'.s:esc.'\2'.s:esc.'\3',
        \ 'g')
    call <Sid>Debug("after %digit expansion: ".re)
  " @digit<[!=] escaping
  let re = substitute(re, 
        \ s:ue.'@\(\d\+<[=!]\)',
        \ '@'.s:esc.'\1',
        \ 'g')
    call <Sid>Debug("after @digit<[!=] escaping: ".re)
  " alpha escaping (to magic)
  let re = substitute(re, 
        \ s:ue.'%\@<![a-zA-Z_]',
        \ '\\&',
        \ 'g')
    call <Sid>Debug("after alpha escaping: ".re)
  " digit+ expansion
  let re = substitute(re, 
        \ s:ue.'\(\d\+\)+',
        \ '{'.s:esc.'\1,}',
        \ 'g')
    call <Sid>Debug("after digit+ expansion: ".re)
  " $digit expansion
  let re = substitute(re, 
        \ s:ue.'\$\(\d\+\)',
        \ '\\'.s:esc.'\1',
        \ 'g')
    call <Sid>Debug("after $digit expansion: ".re)
  " multi3 expansion
  let re = substitute(re, 
        \ s:ue.'\V\(*\|+\|-\)\{3}',
        \ '(\\_.\1)',
        \ 'g')
    call <Sid>Debug("after multi3 expansion: ".re)
  " multi2 expansion
  let re = substitute(re, 
        \ s:ue.'\V\(*\|+\|-\)\{2}',
        \ '(.\1)',
        \ 'g')
    call <Sid>Debug("after multi2 expansion: ".re)
  " minus expansion
  let re = substitute(re, 
        \ s:ue.'-',
        \ '{-}',
        \ 'g')
    call <Sid>Debug("after minus expansion: ".re)
  " curly expansion
  let re = substitute(re, 
        \ s:ue.'\d\@<!\d\+\%('.s:ue.',\%('.s:ue.'\d\+\)\=\)\='.
        \ '\|'.s:ue.',\d\+',
        \ '{&}',
        \ 'g')
    call <Sid>Debug("after curly expansion: ".re)
  " x1c deletion
  let re = substitute(re, 
        \ s:esc,
        \ '',
        \ 'g')
    call <Sid>Debug("after x1c deletion: ".re)
  return '\v'.re
endfun

function! s:Debug(msg) abort
  if get(g:, 'ponydbg', 0)
    echom a:msg
  endif
endfun
