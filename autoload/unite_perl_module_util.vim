"==============================================================================
" unite_perl_module_util.git
" Last Change: 17 Dec 2012
" Maintainer: Yuuki Tsubouchi <yuki.tsubo at gmail.com>
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
"     in  all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"==============================================================================

scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! unite_perl_module_util#find_root_directory(current_dir, project_root_files)
  if a:current_dir ==# '/'
    return ''
  endif
  for root_file in a:project_root_files
    if glob(a:current_dir . root_file) !=# ''
      return a:current_dir
    end
  endfor
  return unite_perl_module_util#find_root_directory(simplify(a:current_dir.'/../'), a:project_root_files)  " go up directory
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
