" Filetype settings for markdown files (.mkd, md)j
au FileType vim,html let b:delimitMate_matchpairs = "(:),[:],{:},<:>"

" Toggle bullets
nnoremap <leader>bullet :call BulletToggle()<cr>

function! BulletToggle()
    if &foldcolumn
	setlocal formatoptions-=r
    else
	setlocal formatoptions+=r
    endif
endfunction
