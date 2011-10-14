"=============================================================================
" FILE: perl_module_complete.vim
" AUTHOR:  soh335 <sugarbabe335@gmail.com>
" Last Modified: 14 Oct 2011.
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:source = {
      \ "name": "perl_module_complete",
      \ "kind": "ftplugin",
      \ "filetypes": { "perl" : 1 },
      \ }

function! s:source.initialize()
endfunction

function! s:source.finalize()
endfunction

function! s:source.get_keyword_pos(cur_text)
  return matchend(a:cur_text, '\<\(use\|require\)\>\s\+')
endfunction

" neocomplcache/sources/filename_complete.vim
function! s:source.get_complete_words(cur_keyword_pos, cur_keyword_str)

  let l:cur_keyword_str = substitute(a:cur_keyword_str, '::', '/', 'g')
  let l:glob = (l:cur_keyword_str !~ '\*$')?  l:cur_keyword_str . '*' : l:cur_keyword_str
  let l:paths = substitute(globpath(&path, l:glob), '\\', '/', 'g')
  let l:files = split(l:paths, '\n')

  let l:res = []

  for word in l:files

    if !isdirectory(word) && word !~ ".pm$"
      continue
    endif

    " Path search.
    for subpath in map(split(&path, ','), 'substitute(v:val, "\\\\", "/", "g")')
      if subpath != '' && neocomplcache#head_match(word, subpath . '/')
        let word = word[len(subpath)+1 : ]
        break
      endif
    endfor

    let word = substitute(word, '.pm$', '', 'g')
    let word = substitute(word, '/', '::', 'g')
    let l:dict = { 'word' : word, 'menu': '[perl_module]' }

    call add(l:res, dict)
  endfor

  return l:res
endfunction

function! neocomplcache#sources#perl_module_complete#define()
  return s:source
endfunction
