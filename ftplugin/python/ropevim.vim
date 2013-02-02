" Check python support
if !has('python')
    echo "Error: ropevim required vim compiled with +python."
    finish
endif

if !exists("*ropevim#setdefault")
    function! ropevim#setdefault(name, value)
        if !exists(a:name)
            let {a:name} = a:value
            return 0
        endif
        return 1
    endfunction
endif

call ropevim#setdefault("g:ropevim_enable_autoimport", 1)
call ropevim#setdefault("g:ropevim_autoimport_underlineds", 0)
call ropevim#setdefault("g:ropevim_codeassist_maxfixes", 1)
call ropevim#setdefault("g:ropevim_enable_shortcuts", 1)
call ropevim#setdefault("g:ropevim_autoimport_modules", "[]")
call ropevim#setdefault("g:ropevim_confirm_saving", 0)
call ropevim#setdefault("g:ropevim_local_prefix", "<Leader>r")
call ropevim#setdefault("g:ropevim_global_prefix", "<Leader>p")
call ropevim#setdefault("g:ropevim_short_prefix", "<Leader>")
call ropevim#setdefault("g:ropevim_vim_completion", 1)
call ropevim#setdefault("g:ropevim_guess_project", 1)
call ropevim#setdefault("g:ropevim_always_show_complete_menu", 1)

exe "noremap <silent> <buffer> " . g:ropevim_short_prefix . "d :RopeGotoDefinition<CR>"
exe "noremap <silent> <buffer> " . g:ropevim_short_prefix . "n :RopeFindOccurrences<CR>"
exe "noremap <silent> <buffer> " . g:ropevim_short_prefix . "m :emenu Ropevim.<TAB>"
nnoremap <silent> <buffer> K :RopeShowDoc<CR>
let s:rascm = g:ropevim_always_show_complete_menu ? "<C-P>" : ""
exe "inoremap <silent> <buffer> . .<C-R>=RopeCodeAssistInsertMode()<CR>" . s:rascm
exe "inoremap <silent> <buffer> ( (<C-R>=RopeCodeAssistInsertMode()<CR>" . s:rascm
exe "inoremap <silent> <buffer> <M-?> :<C-R>=RopeLuckyAssistInsertMode()<CR>" . s:rascm
exe "inoremap <silent> <buffer> <Esc>? :<C-R>=RopeLuckyAssistInsertMode()<CR>" . s:rascm

" Check for ropevim plugin is loaded
if exists("g:ropevim_loaded")
    finish
endif
let g:ropevim_loaded = 1

" Init variables
let g:RopeVimDirectory = expand('<sfile>:p:h')

function! ropevim#load()
python << EOF
import sys
import re
sys.path.insert(0, vim.eval("g:RopeVimDirectory"))
import ropevim
EOF
endfunction

fun! RopeCodeAssistInsertMode()
    call RopeCodeAssist()
    return ""
endfunction

fun! RopeLuckyAssistInsertMode()
    call RopeLuckyAssist()
    return ""
endfunction

function! ropevim#ShowDoc(doc)
    pclose | cclose
    py docs = str(vim.eval('a:doc')).splitlines()
    py vim.command('let l:numlines = "%i"' % len(docs))
    let l:numlines = l:numlines > 8 ? 8 : l:numlines
    exec "botright " . l:numlines . "new"
    setlocal buftype=nofile bufhidden=delete noswapfile nowrap previewwindow
    py if len(docs): vim.current.buffer.append(docs, 0)
    wincmd p
endfunction

call ropevim#load()
