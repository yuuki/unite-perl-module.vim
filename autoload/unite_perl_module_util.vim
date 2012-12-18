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

function! unite_perl_module_util#get_global_candidates()
  let cpan_list = split(unite#util#system("cpan -l 2>/dev/null | cut -f1"), "\n")

  if v:shell_error
    echohl Error
    for error in cpan_list
      echohl error
    endfor
    echohl None
    return []
  endif

  return map(cpan_list, "{
        \ 'word' : v:val,
        \ 'source' : 'cpan',
        \ }")
endfunction

let s:project_root_files = ['.git', '.gitmodules', 'Makefile.PL', 'Build.PL']
let s:lib_dirs = ['lib/', 'extlib/', 'local/lib/perl5/']

function! s:find_root_directory(current_dir)
  if a:current_dir ==# '/'
    return ''
  endif
  for root_file in s:project_root_files
    if glob(a:current_dir . root_file) !=# ''
      return a:current_dir
    end
  endfor
   return s:find_root_directory(simplify(a:current_dir.'/../'))  " go up directory
endfunction

function! s:fullpath_to_module_name(root_directory, fullpath)
  let lib_dir_regexp = '\('.join(s:lib_dirs, '\|').'\)'
  let name = matchstr(a:fullpath, a:root_directory.lib_dir_regexp.'\zs.*\ze\.pm')
  return substitute(name, '/', '::', 'g')
endfunction

function! unite_perl_module_util#get_local_candidates()
  let root_path = s:find_root_directory(getcwd())
  if root_path ==# ''
    return []
  endif

  let inc_fullpaths = []
  for inc in map(copy(s:lib_dirs), 'simplify(root_path . "/" . v:val)')
    let paths = split(glob(inc . "/**/*.pm"), '\n')
    call extend(inc_fullpaths, paths)
  endfor

  return map(inc_fullpaths, "{
        \ 'word' : s:fullpath_to_module_name(root_path, simplify(v:val)),
        \ 'source' : 'lib',
        \ }")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
