"==============================================================================
" unite source for Perl modules
" Last Change: 15 Dec 2012
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

let s:source = {
            \ "name" : "perl/use",
            \ "description" : "Perl library to use",
            \ "default_action" : {"common" : "use"},
            \ "action_table" : {},
            \ }

function! unite#sources#perl_use#define()
    return s:source
endfunction

function! s:source.gather_candidates(args, context)
    let use_list = split(unite#util#system("cpan -l 2>/dev/null | cut -f1"), "\n")

    if v:shell_error
        echohl Error
        for error in use_list
            echohl error
        endfor
        echohl None
        return []
    endif

    return map(use_list, "{
                \ 'word' : v:val,
                \ 'source' : 'cpan',
                \ }")
endfunction

let s:source.action_table.use = {
            \ 'description' : 'use perl modules'
            \ }

function! s:source.action_table.use.func(candidate)
    let use_statement = 'use ' . a:candidate.word . ';'
    execute 'put!' '='''.use_statement.''''
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
