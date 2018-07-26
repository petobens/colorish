"===============================================================================
"          File: onedarkish.vim
"        Author: Pedro Ferrari
"       Created: 08 Mar 2017
" Last Modified: 26 Jul 2018
"   Description: Onedarkish airline theme
"===============================================================================
let g:airline#themes#onedarkish#palette = {}

" The first element of the list is the foreground color and the second one the
" background color
let g:airline#themes#onedarkish#palette.normal = {
      \ 'airline_a':       ['#24272e', '#98c379',  235, 114, 'bold'],
      \ 'airline_b':       ['#abb2bf', '#3b4048', 145, 238, ''],
      \ 'airline_c':       ['#abb2bf', '#282c34',  15, 236, ''],
      \ 'airline_x':       ['#828997', '#282c34', 247, 236, ''],
      \ 'airline_y':       ['#abb2bf', '#3b4048', 145, 238, ''],
      \ 'airline_z':       ['#303030', '#d0d0d0', 236, 252, ''],
      \ 'airline_warning': ['#24272e', '#d19a66', 235, 173, ''],
      \ 'airline_term':    ['#abb2bf', '#282c34',  15, 236, ''],
      \ }

let g:airline#themes#onedarkish#palette.normal_paste = {
      \ 'airline_a': ['#24272e', '#e06c75', 235, 204, 'bold']
      \ }

let g:airline#themes#onedarkish#palette.insert = {
      \ 'airline_a': ['#24272e', '#61afef', 235, 39, 'bold']
      \ }

let g:airline#themes#onedarkish#palette.visual = {
      \ 'airline_a': ['#24272e', '#d19a66', 235, 173, 'bold']
      \ }

let g:airline#themes#onedarkish#palette.replace = {
      \ 'airline_a': ['#24272e', '#c678dd', 235, 170, 'bold']
      \ }

let g:airline#themes#onedarkish#palette.commandline = {
      \ 'airline_a': ['#24272e', '#528bff', 235, 170, 'bold']
      \ }

let g:airline#themes#onedarkish#palette.terminal = {
      \ 'airline_a':    ['#24272e', '#56b6c2', 235, 170, 'bold'],
      \ 'airline_term': ['#abb2bf', '#282c34',  15, 236, ''],
      \ }

let s:IA   = ['#5c6370', '#282c34', 59, 236, '']
let g:airline#themes#onedarkish#palette.inactive =
            \ airline#themes#generate_color_map(s:IA, s:IA, s:IA)

" Readonly
let g:airline#themes#onedarkish#palette.accents = {
    \ 'red': ['#e06c75', '#24272e', 204, 235]
    \ }

let g:airline#themes#onedarkish#palette.tabline = {
      \ 'airline_tab':           ['#abb2bf', '#3b4048', 145, 238, ''],
      \ 'airline_tabsel':        ['#24272e', '#61afef', 235,  39, 'bold'],
      \ 'airline_tabfill':       ['#282c34', '#282c34',  235, 236, ''],
      \ 'airline_tablabel':       ['#303030', '#d0d0d0', 236, 252, 'bold'],
      \ 'airline_tabmod':        ['#24272e', '#e06c75',  235, 204, 'bold'],
      \ 'airline_tabmod_unsel':  ['#24272e', '#d19a66', 235, 173, 'bold'],
      \ 'airline_tabhid':        ['#5c6370', '#282c34', 59, 236, '']
      \ }
