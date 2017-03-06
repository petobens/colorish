"===============================================================================
"          File: heraldish.vim
"        Author: Pedro Ferrari
"       Created: 13 Aug 2013
" Last Modified: 06 Mar 2017
"   Description: Heraldish colorscheme
"===============================================================================
" The way to structure the colorscheme is based (copied) on Steve Losh's Bad
" Wolf.

" Supporting code --------------------------------------------------------------
" Preamble {{{

if !has('gui_running') && &t_Co != 88 && &t_Co != 256
    finish
endif

set background=dark

if exists('syntax_on')
    syntax reset
endif

let g:colors_name = 'heraldish'

" }}}
" Palette {{{

let s:hdc = {}

" From Bad Wolf
let s:hdc.plain        = ['f8f6f2', 15]
let s:hdc.snow         = ['ffffff', 15]
let s:hdc.coal         = ['000000', 16]
let s:hdc.brightgravel = ['d9cec3', 252]
let s:hdc.lightgravel  = ['998f84', 245]
let s:hdc.gravel       = ['857f78', 243]
let s:hdc.mediumgravel = ['666462', 241]
let s:hdc.deepgravel   = ['45413b', 238]
let s:hdc.deepergravel = ['35322d', 236]
let s:hdc.darkgravel   = ['242321', 235]
let s:hdc.blackgravel  = ['1c1b1a', 233]
let s:hdc.tardis       = ['0a9dff', 39]

" From herald
let s:hdc.lightyellow  = ['ffee68', 227]
let s:hdc.orange       = ['ffb539', 214]
let s:hdc.darkorange   = ['ffa500', 214]
let s:hdc.mediumred    = ['fc4234', 203]
let s:hdc.darkpink     = ['fc6984', 204]
let s:hdc.pinkpurple   = ['e783e9', 177]
let s:hdc.palepurple   = ['bf81fa', 141]
let s:hdc.lightestblue = ['70bdf1', 117]
let s:hdc.lightblue    = ['90cbf1', 75]
let s:hdc.green        = ['6df584', 84]

" From Powerline
let s:hdc.darkgray     = ['303030', 236]

" }}}
" Highlighting functions {{{

function! s:HL(group, fg, ...)
    " Arguments: group, guifg, guibg, gui, guisp

    let histring = 'hi ' . a:group . ' '

    if strlen(a:fg)
        if a:fg ==# 'fg'
            let histring .= 'guifg=fg ctermfg=fg '
        else
            let c = get(s:hdc, a:fg)
            let histring .= 'guifg=#' . c[0] . ' ctermfg=' . c[1] . ' '
        endif
    endif

    if a:0 >= 1 && strlen(a:1)
        if a:1 ==# 'bg'
            let histring .= 'guibg=bg ctermbg=bg '
        else
            let c = get(s:hdc, a:1)
            let histring .= 'guibg=#' . c[0] . ' ctermbg=' . c[1] . ' '
        endif
    endif

    if a:0 >= 2 && strlen(a:2)
        let histring .= 'gui=' . a:2 . ' cterm=' . a:2 . ' '
    endif

    if a:0 >= 3 && strlen(a:3)
        let c = get(s:hdc, a:3)
        let histring .= 'guisp=#' . c[0] . ' '
    endif

    execute histring
endfunction

function! s:GetColor(color_name, ...)
    let base_color = get(s:hdc, a:color_name)
    let color = base_color[1]
    if has('gui_running') && a:0 < 1
        let color = '#' . base_color[0]
    endif
    return color
endfunction

" }}}

" Actual colorscheme -----------------------------------------------------------
" Vanilla Vim {{{

" General/UI {{{

" Default text and background
call s:HL('Normal', 'plain', 'blackgravel')

" Text
call s:HL('NonText',    'mediumgravel', '', 'none')
call s:HL('SpecialKey', 'mediumgravel', '', 'none')
call s:HL('Directory',  'lightyellow', '',   'none')
call s:HL('Title',      'green',       '',   'bold')
call s:HL('Conceal',    'green',       '',   'none')

" Window split
call s:HL('VertSplit', 'lightgravel', 'bg', 'none')

" Cursor (line) and column
call s:HL('Cursor', 'coal', 'tardis', 'bold')
call s:HL('CursorLine',   '', 'darkgravel', 'none')
call s:HL('CursorColumn', '', 'darkgravel')
call s:HL('ColorColumn',  '', 'darkgravel')

" Folding and sign column
call s:HL('Folded',     'mediumgravel', 'bg', 'none')
call s:HL('FoldColumn', 'mediumgravel', 'blackgravel')
call s:HL('SignColumn', 'mediumgravel', 'blackgravel')

" Line numbers
call s:HL('LineNr', 'mediumgravel', 'blackgravel')
call s:HL('CursorLineNr', 'tardis', 'blackgravel')

" Status line
call s:HL('StatusLine',   'plain', 'darkgray', 'none')
call s:HL('StatusLineNC', 'snow',  'darkgravel',   'none')
call s:HL('WildMenu',     'coal',  'tardis',       'bold')

" Messages
call s:HL('ErrorMsg',   'mediumred', 'bg',  'bold')
call s:HL('WarningMsg', 'darkorange', '',   'none')
call s:HL('Question',   'darkorange', '',   'none')
call s:HL('MoreMsg',    'darkorange',   '', 'none')
call s:HL('ModeMsg',    'darkorange', '',   'none')

" Search and matching pairs
call s:HL('Search',     'coal',   'lightyellow', 'bold')
call s:HL('IncSearch',  'coal',   'lightyellow', 'bold')
call s:HL('MatchParen', 'tardis', 'darkgravel',  'bold')

" Visual mode
call s:HL('Visual',    '',  'deepgravel')
call s:HL('VisualNOS', '',  'deepgravel')

" Tabs
call s:HL('TabLine',     'plain',  'blackgravel', 'none')
call s:HL('TabLineFill', 'plain',  'blackgravel', 'none')
call s:HL('TabLineSel',  'tardis', 'coal', 'bold')

" Completion menu
call s:HL('Pmenu', 'plain', 'deepergravel')
call s:HL('PmenuSel', 'coal', 'tardis', 'bold')
call s:HL('PmenuSbar', '', 'deepergravel')
call s:HL('PmenuThumb', 'brightgravel')

" Diffs
call s:HL('DiffAdd',    '',     'deepergravel')
call s:HL('DiffDelete', 'coal', 'coal')
call s:HL('DiffChange', '',     'darkgravel')
call s:HL('DiffText',   'snow', 'deepergravel', 'bold')

" }}}
" Syntax highlighting {{{
" See syntax.txt (Naming Conventions) for help

call s:HL('Comment', 'gravel')

call s:HL('String', 'orange')

call s:HL('Constant',  'green', '', 'none')
call s:HL('Character', 'green', '', 'none')
call s:HL('Boolean',   'green', '', 'none')
call s:HL('Number',    'green', '', 'none')
call s:HL('Float',     'green', '', 'none')

call s:HL('Identifier', 'palepurple',    '', 'none') " Variables
call s:HL('Function',   'lightestblue', '', 'none')

call s:HL('Statement',   'pinkpurple', '', 'none')
call s:HL('Conditional', 'pinkpurple', '', 'none')
call s:HL('Repeat',      'pinkpurple', '', 'none')
call s:HL('Label',       'pinkpurple', '', 'none')

call s:HL('Operator',    'darkpink', '', 'none')
call s:HL('Keyword',     'darkpink', '', 'none')
call s:HL('Delimiter',   'darkpink', '', 'none')

call s:HL('Exception', 'green', '', 'none')

" Preprocessor directives (starting with #)
call s:HL('PreProc',   'palepurple', '', 'none')
call s:HL('Macro',     'palepurple', '', 'none')
call s:HL('Define',    'palepurple', '', 'none')
call s:HL('PreCondit', 'palepurple', '', 'none')

call s:HL('Type',         'lightyellow', '', 'none')
call s:HL('StorageClass', 'lightyellow', '', 'none')
call s:HL('Structure',    'lightyellow', '', 'none')
call s:HL('Typedef',      'lightyellow', '', 'none')

call s:HL('Special',     'lightyellow')
call s:HL('SpecialChar', 'lightyellow', '', 'none')

call s:HL('Todo',           'mediumred', 'bg', 'bold')
call s:HL('SpecialComment', 'mediumred', 'bg', 'bold')

call s:HL('Error',  'mediumred',   'bg', 'bold')
call s:HL('Debug',  'lightyellow',   '',      'none')
call s:HL('Ignore', 'gravel', '',      '')
call s:HL('Underlined', 'mediumred', '', 'underline')
call s:HL('Tag', '', '', 'bold')

" }}}
" Spelling {{{

if has('spell')
    if has('gui_running')
        call s:HL('SpellCap', '', '', 'undercurl,bold','lightyellow')
        call s:HL('SpellBad',   '', '', 'undercurl', 'mediumred')
        call s:HL('SpellLocal', '', '', 'undercurl', 'lightyellow')
        call s:HL('SpellRare',  '', '', 'undercurl', 'green')
    else
        " Use gravel color for spelling mistakes in console since undercurl
        " highlighting is (generally) not available
        hi SpellCap    ctermfg=240   ctermbg=233  cterm=underline,bold
        hi SpellBad    ctermfg=240   ctermbg=233  cterm=underline
        hi SpellLocal  ctermfg=240   ctermbg=233  cterm=underline
        hi SpellRare   ctermfg=240   ctermbg=233  cterm=underline
    endif
endif

" }}}
" Neovim terminal colors {{{

" Note: this follows iTerms' afterglow colorscheme
if has('nvim')
    let g:terminal_color_0 =  '#1b1b1b' " black
    let g:terminal_color_1 =  '#bc5653' " red
    let g:terminal_color_2 =  '#909d63' " green
    let g:terminal_color_3 =  '#ebc17a' " yellow
    let g:terminal_color_4 =  '#7eaac7' " blue
    let g:terminal_color_5 =  '#b06698' " magenta
    let g:terminal_color_6 =  '#8ddcd8' " cyan
    let g:terminal_color_7 =  '#d9d9d9' " greyish white
    let g:terminal_color_8 =  '#636363' " bright grey
    let g:terminal_color_9 =  '#bc5653' " bright red
    let g:terminal_color_10 = '#909d63' " bright green
    let g:terminal_color_11 = '#ebc17a' " bright yellow
    let g:terminal_color_12 = '#7eaac7' " bright blue
    let g:terminal_color_13 = '#b06698' " bright magenta
    let g:terminal_color_14 = '#8ddcd8' " bright cyan
    let g:terminal_color_14 = '#f7f7f7' " white
    let g:terminal_color_background = g:terminal_color_0
    let g:terminal_color_foreground = g:terminal_color_7
endif

" }}}

" }}}
" Filetype-specific {{{

" Bibtex {{{

hi def link bibTodo Todo

" }}}
" Diff {{{

hi def link diffRemoved GitGutterDelete
hi def link diffAdded GitGutterAdd
hi def link diffChanged GitGutterChange
hi def link diffLine DiffAdd

" }}}
" Markdown {{{

call s:HL('markdownHeadingDelimiter', 'darkpink', '', 'bold')
call s:HL('markdownH1', 'darkpink', '', 'bold')
call s:HL('markdownH2', 'darkpink', '', 'bold')
call s:HL('markdownH3', 'darkpink', '', 'bold')

call s:HL('markdownLinkText', 'pinkpurple', '', 'underline')
call s:HL('markdownLinkTextDelimiter', 'lightgravel', '', '')
call s:HL('markdownUrl', 'lightblue', '', '')
call s:HL('markdownLinkDelimiter', 'lightgravel', '', '')

call s:HL('markdownCodeDelimiter', 'lightyellow', '', 'bold')
call s:HL('markdownCode', 'lightyellow', '', 'none')
call s:HL('markdownCodeBlock', 'lightyellow', '', 'none')

" }}}
" Snippets {{{

hi def link snipTODO Todo

" }}}
" Text {{{

hi def link txtURl Function

" }}}

" }}}
" Plugins {{{

" Gitgutter {{{

call s:HL('GitGutterAdd',                'green', 'blackgravel')
call s:HL('GitGutterChange',       'lightyellow', 'blackgravel')
call s:HL('GitGutterChangeDelete', 'lightyellow', 'blackgravel')
call s:HL('GitGutterDelete',         'mediumred', 'blackgravel')

" }}}
" Interesting Words {{{

" These are only used if you copied the <leader>NUM mappings from Steve Losh's
" Vimrc.

call s:HL('InterestingWord1', 'coal', 'lightyellow')
call s:HL('InterestingWord2', 'coal', 'green')
call s:HL('InterestingWord3', 'coal', 'pinkpurple')
call s:HL('InterestingWord4', 'coal', 'orange')
call s:HL('InterestingWord5', 'coal', 'lightblue')
call s:HL('InterestingWord6', 'coal', 'snow')

" }}}
" Sneak {{{

call s:HL('Sneak','coal', 'lightyellow', 'bold')
call s:HL('SneakLabel','darkorange', 'coal')

" }}}
" Vimfiler {{{

call s:HL('vimfilerStatus',           'palepurple', '', 'none')
call s:HL('vimfilerCurrentDirectory', 'plain',      '', 'none')
call s:HL('vimfilerMask',             'pinkpurple', '', 'none')

call s:HL('vimfilerNonMark',    'lightyellow')
call s:HL('vimfilerMarkedFile', 'tardis',      '', 'none')
call s:HL('vimfilerDirectory',  'lightyellow', '', 'none')

call s:HL('vimfilerOpenedFile',  'lightblue',   '',   'none')
call s:HL('vimfilerClosedFile', 'lightyellow', '',   'none')
call s:HL('vimfilerROFile',     'mediumred',   'bg', 'bold')

" }}}
" Vimtex {{{

" Table of contents
call s:HL('TocNum', 'plain', 'bg', 'none')
call s:HL('TocSec0', 'lightblue', 'bg', 'bold')
call s:HL('TocSec1', 'lightyellow', 'bg', 'none')
call s:HL('TocSec2', 'plain', 'bg', 'none')
call s:HL('TocSec3', 'plain', 'bg', 'none')

" }}}
" }}}
