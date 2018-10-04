" Ultra-magic regexps
" Friendship is magic (c)

let s:ue = '\%(\%(^\|[^\\]\)\\\%(\\\\\)*\)\@<!'.
         \ "\\%(\x1c\\)\\@<!"

function! ponyreg#Search() abort
  echo ''
  let fre = input('=/')
  if fre == ''
    return
  endif
  let re = ponyreg#Magic(fre)
  call feedkeys('/\v'.re."\<cr>", 'ti')
endfun

function! ponyreg#Magic(fre) abort
  let re = a:fre
  " x1c escaping
  let re = substitute(re, 
        \ s:ue.'\\\([a-zA-Z0-9]\)',
        \ "\x1c\\1",
        \ 'g')
    echom "after x1c escaping: ".re
  " quote expansion
  let re = substitute(re,
        \ '"\([^"]\+\%(\\\@<="[^"]*\)*\)"',
        \ '\="(\V".substitute(submatch(1), "[a-zA-Z0-9]", "\x1c&", "g")."\v)"',
        \ 'g')
    echom "after quote expansion: ".re
  " zs/ze escaping
  let re = substitute(re, 
        \ s:ue.'\(z\)\([se]\)',
        \ "\\\\\x1c\\1\x1c\\2",
        \ 'g')
    echom "after zs/ze escaping: ".re
  " alpha escaping
  let re = substitute(re, 
        \ s:ue.'%\@<![a-zA-Z]',
        \ '\\&',
        \ 'g')
    echom "after alpha escaping: ".re
  " digit+ expansion
  let re = substitute(re, 
        \ s:ue.'\(\d\+\)+',
        \ "{\x1c\\1,}",
        \ 'g')
    echom "after digit+ expansion: ".re
  " $digit expansion
  let re = substitute(re, 
        \ s:ue.'\$\(\d\+\)',
        \ "\\\\\x1c\\1",
        \ 'g')
    echom "after $digit expansion: ".re
  " minus expansion
  let re = substitute(re, 
        \ s:ue.'-',
        \ '{-}',
        \ 'g')
    echom "after minus expansion: ".re
  " curly expansion
  let re = substitute(re, 
        \ s:ue.'\d\+\%('.s:ue.',\%('.s:ue.'\d\+\)\=\)\='.
        \ '\|'.s:ue.',\d\+',
        \ '{&}',
        \ 'g')
    echom "after curly expansion: ".re
  " x1c deletion
  let re = substitute(re, 
        \ "\x1c",
        \ '',
        \ 'g')
    echom "after x1c deletion: ".re
  return re
endfun

