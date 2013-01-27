" Check python support
if !has('python')
    echo "Error: ropevim required vim compiled with +python."
    finish
endif

" Check for ropevim plugin is loaded
if exists("loaded_ropevim")
    finish
endif
let loaded_ropevim = 1

" Init variables
let g:RopeVimDirectory = expand('<sfile>:p:h')

function! LoadRope()
python << EOF
import sys
sys.path.insert(0, vim.eval("g:RopeVimDirectory"))
import ropevim
EOF
endfunction

call LoadRope()
