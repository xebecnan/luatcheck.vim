" Author: xebecnan https://github.com/xebecnan
" Description: luatcheck yet another lua static type checker

call ale#Set('lua_luatcheck_executable', 'luatcheck')
call ale#Set('lua_luatcheck_options', '')

function! ale_linters#lua#luatcheck#Handle(buffer, lines) abort
    " Matches patterns line the following:
    "
    " test.lua:159: expect "number", but given "Str"
    let l:pattern = '^[^ \t\v].\{-}:\(\d\+\): \(.\+\)$'
    let l:output = []

    for l:match in ale#util#GetMatches(a:lines, l:pattern)
        call add(l:output, {
        \   'lnum': l:match[1] + 0,
        \   'type': 'E',
        \   'text': l:match[2],
        \})
    endfor

    return l:output
endfunction

call ale#linter#Define('lua', {
\   'name': 'luatcheck',
\   'executable': {b -> ale#Var(b, 'lua_luatcheck_executable')},
\   'command': '%e --filename %s -',
\   'callback': 'ale_linters#lua#luatcheck#Handle',
\})
