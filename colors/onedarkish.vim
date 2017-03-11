"===============================================================================
"          File: onedarkish.vim
"        Author: Ramzi Akremi
"    Maintainer: Pedro Ferrari
"       Created: 7 Mar 2017
" Last Modified: 11 Mar 2017
"   Description: Onedark Atom theme port for Vim/Neovim
"===============================================================================

" Supporting code --------------------------------------------------------------
" Preamble {{{

if !has('gui_running') && &t_Co != 88 && &t_Co != 256
    finish
endif

hi clear
if exists('syntax_on')
    syntax reset
endif

set background=dark

if exists('g:colors_name')
    unlet g:colors_name
endif
let g:colors_name = 'onedarkish'

if !exists('g:one_allow_italics')
    let g:one_allow_italics = 0
endif

" }}}
" Highlighting functions {{{

function <SID>grey_number(x)
    if &t_Co == 88
        if a:x < 23
            return 0
        elseif a:x < 69
            return 1
        elseif a:x < 103
            return 2
        elseif a:x < 127
            return 3
        elseif a:x < 150
            return 4
        elseif a:x < 173
            return 5
        elseif a:x < 196
            return 6
        elseif a:x < 219
            return 7
        elseif a:x < 243
            return 8
        else
            return 9
        endif
    else
        if a:x < 14
            return 0
        else
            let l:n = (a:x - 8) / 10
            let l:m = (a:x - 8) % 10
            if l:m < 5
                return l:n
            else
                return l:n + 1
            endif
        endif
    endif
endfunction

" Returns the actual grey level represented by the grey index
fun <SID>grey_level(n)
    if &t_Co == 88
        if a:n == 0
            return 0
        elseif a:n == 1
            return 46
        elseif a:n == 2
            return 92
        elseif a:n == 3
            return 115
        elseif a:n == 4
            return 139
        elseif a:n == 5
            return 162
        elseif a:n == 6
            return 185
        elseif a:n == 7
            return 208
        elseif a:n == 8
            return 231
        else
            return 255
        endif
    else
        if a:n == 0
            return 0
        else
            return 8 + (a:n * 10)
        endif
    endif
endfunction

" Returns the palette index for the given grey index
function <SID>grey_color(n)
    if &t_Co == 88
        if a:n == 0
            return 16
        elseif a:n == 9
            return 79
        else
            return 79 + a:n
        endif
    else
        if a:n == 0
            return 16
        elseif a:n == 25
            return 231
        else
            return 231 + a:n
        endif
    endif
endfunction

" Returns an approximate color index for the given color level
function <SID>rgb_number(x)
    if &t_Co == 88
        if a:x < 69
            return 0
        elseif a:x < 172
            return 1
        elseif a:x < 230
            return 2
        else
            return 3
        endif
    else
        if a:x < 75
            return 0
        else
            let l:n = (a:x - 55) / 40
            let l:m = (a:x - 55) % 40
            if l:m < 20
                return l:n
            else
                return l:n + 1
            endif
        endif
    endif
endfunction

" Returns the actual color level for the given color index
function <SID>rgb_level(n)
    if &t_Co == 88
        if a:n == 0
            return 0
        elseif a:n == 1
            return 139
        elseif a:n == 2
            return 205
        else
            return 255
        endif
    else
        if a:n == 0
            return 0
        else
            return 55 + (a:n * 40)
        endif
    endif
endfunction

" Returns the palette index for the given R/G/B color indices
function <SID>rgb_color(x, y, z)
    if &t_Co == 88
        return 16 + (a:x * 16) + (a:y * 4) + a:z
    else
        return 16 + (a:x * 36) + (a:y * 6) + a:z
    endif
endfunction

" Returns the palette index to approximate the given R/G/B color levels
function <SID>color(r, g, b)
    " Get the closest grey
    let l:gx = <SID>grey_number(a:r)
    let l:gy = <SID>grey_number(a:g)
    let l:gz = <SID>grey_number(a:b)

    " Get the closest color
    let l:x = <SID>rgb_number(a:r)
    let l:y = <SID>rgb_number(a:g)
    let l:z = <SID>rgb_number(a:b)

    if l:gx == l:gy && l:gy == l:gz
        " There are two possibilities
        let l:dgr = <SID>grey_level(l:gx) - a:r
        let l:dgg = <SID>grey_level(l:gy) - a:g
        let l:dgb = <SID>grey_level(l:gz) - a:b
        let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
        let l:dr = <SID>rgb_level(l:gx) - a:r
        let l:dg = <SID>rgb_level(l:gy) - a:g
        let l:db = <SID>rgb_level(l:gz) - a:b
        let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
        if l:dgrey < l:drgb
        " Use the grey
            return <SID>grey_color(l:gx)
        else
        " Use the color
            return <SID>rgb_color(l:x, l:y, l:z)
        endif
    else
        " Only one possibility
        return <SID>rgb_color(l:x, l:y, l:z)
    endif
endfunction

" Returns the palette index to approximate the 'rrggbb' hex string
function <SID>rgb(rgb)
    let l:r = ('0x' . strpart(a:rgb, 0, 2)) + 0
    let l:g = ('0x' . strpart(a:rgb, 2, 2)) + 0
    let l:b = ('0x' . strpart(a:rgb, 4, 2)) + 0

    return <SID>color(l:r, l:g, l:b)
endfunction

" Sets the highlighting for the given group
function <sid>X(group, fg, bg, attr)
    let l:attr = a:attr
    if g:one_allow_italics == 0 && l:attr ==? 'italic'
        let l:attr= 'none'
    endif

    let l:bg = ''
    let l:fg = ''
    let l:decoration = ''

    if a:bg !=# ''
        let l:bg = ' guibg=#' . a:bg . ' ctermbg=' . <SID>rgb(a:bg)
    endif

    if a:fg !=# ''
        let l:fg = ' guifg=#' . a:fg . ' ctermfg=' . <SID>rgb(a:fg)
    endif

    if a:attr !=# ''
        let l:decoration = ' gui=' . l:attr . ' cterm=' . l:attr
    endif

    let l:exec = l:fg . l:bg . l:decoration

    if l:exec !=# ''
        exec 'hi ' . a:group . l:exec
    endif
endfunction

"}}}
" Palette {{{

" Comments refer to 256 terminal colors
let s:white = 'abb2bf' " 145 (fake white)
let s:mono_2 = '828997'
let s:comment_grey = '5c6370' " 59
let s:mono_4 = '4b5263'

let s:cyan  = '56b6c2' " 38
let s:light_blue  = '61afef' " 39
let s:blue = '528bff' " light_blueish
let s:purple  = 'c678dd' " 170
let s:green  = '98c379' " 114

let s:red   = 'e06c75' " 204
let s:dark_red = 'be5046' " 196

let s:dark_yellow   = 'd19a66' " 173
let s:yellow = 'e5c07b' " 180

" The original background and cursor colors are
" let s:black     = '282c34' " 235 (fake black)
" let s:cursor_grey = '2c323c' " 236
" We make the background a bit more dark
let s:black     = '24272e' " 235 (fake black)
let s:cursor_grey = '282c34' " 236

let s:gutter_fg_grey = '636d83' " 238
let s:special_grey = '3b4048' " 238
let s:visual_grey  = '3e4452' " 237
let s:pmenu        = '333841' " 237

let s:syntax_fg = s:white
let s:syntax_fold_bg = s:comment_grey

"}}}

" Actual colorscheme -----------------------------------------------------------
" General/UI {{{

call <sid>X('Normal',       s:syntax_fg,    s:black,       '')
call <sid>X('bold',         '',             '',            'bold')
call <sid>X('ColorColumn',  '',             s:cursor_grey, '')
call <sid>X('Conceal',      '',             '',            '')
call <sid>X('Cursor',       '',             s:blue,        '')
call <sid>X('CursorIM',     '',             '',            '')
call <sid>X('CursorColumn', '',             s:cursor_grey, '')
call <sid>X('CursorLine',   '',             s:cursor_grey, 'none')
call <sid>X('QuickFixLine', '',             s:black,       '')
call <sid>X('Directory',    s:light_blue,   '',            '')
call <sid>X('ErrorMsg',     s:red,          s:black,       'none')
call <sid>X('VertSplit',    s:comment_grey, '',            'none')
call <sid>X('Folded',       s:comment_grey, s:black,       'none')
call <sid>X('FoldColumn',   s:comment_grey, s:black,       '')
call <sid>X('IncSearch',    s:dark_yellow,  '',            '')
call <sid>X('LineNr',       s:mono_4,       '',            '')
call <sid>X('CursorLineNr', s:syntax_fg,    s:black,       'none')
call <sid>X('MatchParen',   s:blue,         s:cursor_grey, 'bold')
call <sid>X('Italic',       '',             '',            'italic')
call <sid>X('ModeMsg',      s:dark_yellow,  '',            'none')
call <sid>X('MoreMsg',      s:dark_yellow,  '',            'none')
call <sid>X('NonText',      s:comment_grey, '',            'none')
call <sid>X('PMenu',        '',             s:pmenu,       '')
call <sid>X('PMenuSel',     s:black,        s:light_blue,  '')
call <sid>X('PMenuSbar',    '',             s:black,       '')
call <sid>X('PMenuThumb',   '',             s:white,       '')
call <sid>X('Question',     s:light_blue,   '',            '')
call <sid>X('Search',       s:black,        s:yellow,      '')
call <sid>X('SpecialKey',   s:special_grey, '',            'none')
call <sid>X('StatusLine',   s:syntax_fg,    s:cursor_grey, 'none')
call <sid>X('StatusLineNC', s:comment_grey, '',            '')
call <sid>X('TabLine',      s:white,        s:black,       '')
call <sid>X('TabLineFill',  s:comment_grey, s:visual_grey, 'none')
call <sid>X('TabLineSel',   s:black,        s:light_blue,  '')
call <sid>X('Title',        s:syntax_fg,    '',            'bold')
call <sid>X('Visual',       '',             s:visual_grey, '')
call <sid>X('VisualNOS',    '',             s:visual_grey, '')
call <sid>X('WarningMsg',   s:dark_yellow,  '',            '')
call <sid>X('TooLong',      s:red,          '',            '')
call <sid>X('WildMenu',     s:black,        s:light_blue,  '')
call <sid>X('SignColumn',   '',             s:black,       '')
call <sid>X('Special',      s:light_blue,   '',            '')

" }}}
" Syntax highlighting {{{

call <sid>X('Comment',        s:comment_grey, '',      'italic')
call <sid>X('Constant',       s:green,        '',      '')
call <sid>X('String',         s:green,        '',      '')
call <sid>X('Character',      s:green,        '',      '')
call <sid>X('Number',         s:dark_yellow,  '',      '')
call <sid>X('Boolean',        s:dark_yellow,  '',      '')
call <sid>X('Float',          s:dark_yellow,  '',      '')
call <sid>X('Identifier',     s:red,          '',      'none')
call <sid>X('Function',       s:light_blue,   '',      '')
call <sid>X('Statement',      s:purple,       '',      'none')
call <sid>X('Conditional',    s:purple,       '',      '')
call <sid>X('Repeat',         s:purple,       '',      '')
call <sid>X('Label',          s:purple,       '',      '')
call <sid>X('Operator',       s:blue,         '',      'none')
call <sid>X('Keyword',        s:red,          '',      '')
call <sid>X('Exception',      s:purple,       '',      '')
call <sid>X('PreProc',        s:yellow,       '',      '')
call <sid>X('Include',        s:light_blue,   '',      '')
call <sid>X('Define',         s:purple,       '',      'none')
call <sid>X('Macro',          s:purple,       '',      '')
call <sid>X('PreCondit',      s:yellow,       '',      '')
call <sid>X('Type',           s:yellow,       '',      'none')
call <sid>X('StorageClass',   s:yellow,       '',      '')
call <sid>X('Structure',      s:yellow,       '',      '')
call <sid>X('Typedef',        s:yellow,       '',      '')
call <sid>X('Special',        s:light_blue,   '',      '')
call <sid>X('SpecialChar',    '',             '',      '')
call <sid>X('Tag',            '',             '',      '')
call <sid>X('Delimiter',      s:blue,         '',      '')
call <sid>X('SpecialComment', '',             '',      '')
call <sid>X('Debug',          '',             '',      '')
call <sid>X('Underlined',     '',             '',      '')
call <sid>X('Ignore',         '',             '',      '')
call <sid>X('Error',          s:red,          s:black, 'bold')
call <sid>X('Todo',           s:red,          s:black, '')

" }}}
" Spelling {{{

call <sid>X('SpellBad',   '', s:black, 'undercurl')
call <sid>X('SpellLocal', '', s:black, 'undercurl')
call <sid>X('SpellCap',   '', s:black, 'undercurl')
call <sid>X('SpellRare',  '', s:black, 'undercurl')

" }}}
" Vim Help {{{

call <sid>X('helpCommand',      s:yellow, '', '')
call <sid>X('helpExample',      s:yellow, '', '')
call <sid>X('helpHeader',       s:white,  '', 'bold')
call <sid>X('helpSectionDelim', s:comment_grey,  '', '')

" }}}
" Neovim terminal highlighting {{{

if has('nvim')
    let g:terminal_color_0          = '#' . s:black
    let g:terminal_color_1          = '#' . s:red
    let g:terminal_color_2          = '#' . s:green
    let g:terminal_color_3          = '#' . s:yellow
    let g:terminal_color_4          = '#' . s:light_blue
    let g:terminal_color_5          = '#' . s:purple
    let g:terminal_color_6          = '#' . s:cyan
    let g:terminal_color_7          = '#' . s:white
    let g:terminal_color_8          = '#' . s:visual_grey
    let g:terminal_color_9          = '#' . s:dark_red
    let g:terminal_color_10         = '#' . s:green
    let g:terminal_color_11         = '#' . s:dark_yellow
    let g:terminal_color_12         = '#' . s:light_blue
    let g:terminal_color_13         = '#' . s:purple
    let g:terminal_color_14         = '#' . s:cyan
    let g:terminal_color_15         = '#' . s:comment_grey
    let g:terminal_color_background = g:terminal_color_0
    let g:terminal_color_foreground = g:terminal_color_7
endif

" }}}

" Filetype-specific {{{

" Asciidoc {{{

call <sid>X('asciidocListingBlock',   s:mono_2,  '', '')

" }}}
" C/C++ {{{
call <sid>X('cConstant',           s:dark_yellow,  '', '')
call <sid>X('cType',               s:purple,  '', '')

call <sid>X('cCppString',          s:green,  '', '')

" }}}
" CSS {{{

call <sid>X('cssAttrComma',         s:purple,      '', '')
call <sid>X('cssAttributeSelector', s:green,       '', '')
call <sid>X('cssBraces',            s:mono_2,      '', '')
call <sid>X('cssClassName',         s:dark_yellow, '', '')
call <sid>X('cssClassNameDot',      s:dark_yellow, '', '')
call <sid>X('cssDefinition',        s:purple,      '', '')
call <sid>X('cssFontAttr',          s:dark_yellow, '', '')
call <sid>X('cssFontDescriptor',    s:purple,      '', '')
call <sid>X('cssFunctionName',      s:light_blue,  '', '')
call <sid>X('cssIdentifier',        s:light_blue,  '', '')
call <sid>X('cssImportant',         s:purple,      '', '')
call <sid>X('cssInclude',           s:white,       '', '')
call <sid>X('cssIncludeKeyword',    s:purple,      '', '')
call <sid>X('cssMediaType',         s:dark_yellow, '', '')
call <sid>X('cssProp',              s:cyan,        '', '')
call <sid>X('cssPseudoClassId',     s:dark_yellow, '', '')
call <sid>X('cssSelectorOp',        s:purple,      '', '')
call <sid>X('cssSelectorOp2',       s:purple,      '', '')
call <sid>X('cssStringQ',           s:green,       '', '')
call <sid>X('cssStringQQ',          s:green,       '', '')
call <sid>X('cssTagName',           s:red,         '', '')
call <sid>X('cssAttr',              s:dark_yellow, '', '')

" }}}
" Diff {{{
call <sid>X('DiffAdd',     s:green, s:visual_grey, '')
call <sid>X('DiffChange',  s:dark_yellow, s:visual_grey, '')
call <sid>X('DiffDelete',  s:red, s:visual_grey, '')
call <sid>X('DiffText',    s:light_blue, s:visual_grey, '')
call <sid>X('DiffAdded',   s:green, s:visual_grey, '')
call <sid>X('DiffFile',    s:red, s:visual_grey, '')
call <sid>X('DiffNewFile', s:green, s:visual_grey, '')
call <sid>X('DiffLine',    s:light_blue, s:visual_grey, '')
call <sid>X('DiffRemoved', s:red, s:visual_grey, '')

" }}}
" Git {{{

call <sid>X('gitcommitComment',       s:comment_grey, '', '')
call <sid>X('gitcommitUnmerged',      s:green,        '', '')
call <sid>X('gitcommitOnBranch',      '',             '', '')
call <sid>X('gitcommitBranch',        s:purple,       '', '')
call <sid>X('gitcommitDiscardedType', s:red,          '', '')
call <sid>X('gitcommitSelectedType',  s:green,        '', '')
call <sid>X('gitcommitHeader',        '',             '', '')
call <sid>X('gitcommitUntrackedFile', s:cyan,         '', '')
call <sid>X('gitcommitDiscardedFile', s:red,          '', '')
call <sid>X('gitcommitSelectedFile',  s:green,        '', '')
call <sid>X('gitcommitUnmergedFile',  s:yellow,       '', '')
call <sid>X('gitcommitFile',          '',             '', '')
hi link gitcommitNoBranch       gitcommitBranch
hi link gitcommitUntracked      gitcommitComment
hi link gitcommitDiscarded      gitcommitComment
hi link gitcommitSelected       gitcommitComment
hi link gitcommitDiscardedArrow gitcommitDiscardedFile
hi link gitcommitSelectedArrow  gitcommitSelectedFile
hi link gitcommitUnmergedArrow  gitcommitUnmergedFile

" }}}
" Go {{{
call <sid>X('goDeclaration',  s:purple, '', '')
call <sid>X('goField',        s:red,    '', '')
call <sid>X('goMethod',       s:cyan,   '', '')
call <sid>X('goType',         s:purple, '', '')
call <sid>X('goUnsignedInts', s:cyan,   '', '')

" }}}
" HTML {{{

call <sid>X('htmlArg',            s:dark_yellow, '',            '')
call <sid>X('htmlTagName',        s:red,         '',            '')
call <sid>X('htmlTagN',           s:red,         '',            '')
call <sid>X('htmlSpecialTagName', s:red,         '',            '')
call <sid>X('htmlTag',            s:mono_2,      '',            '')
call <sid>X('htmlEndTag',         s:mono_2,      '',            '')
call <sid>X('MatchTag',           s:red,         s:cursor_grey, 'bold')

" }}}
" JavaScript {{{

call <sid>X('coffeeString',           s:green,   '', '')

call <sid>X('javaScriptBraces',       s:mono_2,       '', '')
call <sid>X('javaScriptFunction',     s:purple,       '', '')
call <sid>X('javaScriptIdentifier',   s:purple,       '', '')
call <sid>X('javaScriptNull',         s:dark_yellow,  '', '')
call <sid>X('javaScriptNumber',       s:dark_yellow,  '', '')
call <sid>X('javaScriptRequire',      s:cyan,         '', '')
call <sid>X('javaScriptReserved',     s:purple,       '', '')
" https://github.com/pangloss/vim-javascript
call <sid>X('jsArrowFunction',        s:purple,       '', '')
call <sid>X('jsBraces',               s:mono_2,       '', '')
call <sid>X('jsClassBraces',          s:mono_2,       '', '')
call <sid>X('jsClassKeywords',        s:purple,       '', '')
call <sid>X('jsDocParam',             s:light_blue,   '', '')
call <sid>X('jsDocTags',              s:purple,       '', '')
call <sid>X('jsFuncBraces',           s:mono_2,       '', '')
call <sid>X('jsFuncCall',             s:light_blue,   '', '')
call <sid>X('jsFuncParens',           s:mono_2,       '', '')
call <sid>X('jsFunction',             s:purple,       '', '')
call <sid>X('jsGlobalObjects',        s:yellow,       '', '')
call <sid>X('jsModuleWords',          s:purple,       '', '')
call <sid>X('jsModules',              s:purple,       '', '')
call <sid>X('jsNoise',                s:mono_2,       '', '')
call <sid>X('jsNull',                 s:dark_yellow,  '', '')
call <sid>X('jsOperator',             s:purple,       '', '')
call <sid>X('jsParens',               s:mono_2,       '', '')
call <sid>X('jsStorageClass',         s:purple,       '', '')
call <sid>X('jsTemplateBraces',       s:dark_red,     '', '')
call <sid>X('jsTemplateVar',          s:green,        '', '')
call <sid>X('jsThis',                 s:red,          '', '')
call <sid>X('jsUndefined',            s:dark_yellow,  '', '')
call <sid>X('jsObjectValue',          s:light_blue,   '', '')
call <sid>X('jsObjectKey',            s:cyan,         '', '')
" https://github.com/othree/yajs.vim
call <sid>X('javascriptArrowFunc',    s:purple,       '', '')
call <sid>X('javascriptClassExtends', s:purple,       '', '')
call <sid>X('javascriptClassKeyword', s:purple,       '', '')
call <sid>X('javascriptDocNotation',  s:purple,       '', '')
call <sid>X('javascriptDocParamName', s:light_blue,   '', '')
call <sid>X('javascriptDocTags',      s:purple,       '', '')
call <sid>X('javascriptEndColons',    s:comment_grey, '', '')
call <sid>X('javascriptExport',       s:purple,       '', '')
call <sid>X('javascriptFuncArg',      s:white,        '', '')
call <sid>X('javascriptFuncKeyword',  s:purple,       '', '')
call <sid>X('javascriptIdentifier',   s:red,          '', '')
call <sid>X('javascriptImport',       s:purple,       '', '')
call <sid>X('javascriptObjectLabel',  s:white,        '', '')
call <sid>X('javascriptOpSymbol',     s:cyan,         '', '')
call <sid>X('javascriptOpSymbols',    s:cyan,         '', '')
call <sid>X('javascriptPropertyName', s:green,        '', '')
call <sid>X('javascriptTemplateSB',   s:dark_red,     '', '')
call <sid>X('javascriptVariable',     s:purple,       '', '')

" }}}
" JSON {{{

call <sid>X('jsonCommentError',       s:white,      '', ''        )
call <sid>X('jsonKeyword',            s:red,        '', ''        )
call <sid>X('jsonQuote',              s:light_blue, '', ''        )
call <sid>X('jsonTrailingCommaError', s:red,        '', 'reverse' )
call <sid>X('jsonMissingCommaError',  s:red,        '', 'reverse' )
call <sid>X('jsonNoQuotesError',      s:red,        '', 'reverse' )
call <sid>X('jsonNumError',           s:red,        '', 'reverse' )
call <sid>X('jsonString',             s:green,      '', ''        )
call <sid>X('jsonStringSQError',      s:red,        '', 'reverse' )
call <sid>X('jsonSemicolonError',     s:red,        '', 'reverse' )

" }}}
" Man {{{

hi link manTitle String
call <sid>X('manFooter', s:comment_grey, '', '')

" }}}
" Markdown {{{

call <sid>X('markdownUrl',              s:purple,      '', '')
call <sid>X('markdownBold',             s:dark_yellow, '', 'bold')
call <sid>X('markdownItalic',           s:dark_yellow, '', 'bold')
call <sid>X('markdownCode',             s:green,       '', '')
call <sid>X('markdownCodeBlock',        s:red,         '', '')
call <sid>X('markdownCodeDelimiter',    s:green,       '', '')
call <sid>X('markdownHeadingDelimiter', s:dark_red,    '', '')
call <sid>X('markdownH1',               s:red,         '', '')
call <sid>X('markdownH2',               s:red,         '', '')
call <sid>X('markdownH3',               s:red,         '', '')
call <sid>X('markdownH3',               s:red,         '', '')
call <sid>X('markdownH4',               s:red,         '', '')
call <sid>X('markdownH5',               s:red,         '', '')
call <sid>X('markdownH6',               s:red,         '', '')
call <sid>X('markdownListMarker',       s:red,         '', '')

" }}}
" PHP {{{

call <sid>X('phpClass',        s:yellow,       '', '')
call <sid>X('phpFunction',     s:light_blue,   '', '')
call <sid>X('phpFunctions',    s:light_blue,   '', '')
call <sid>X('phpInclude',      s:purple,       '', '')
call <sid>X('phpKeyword',      s:purple,       '', '')
call <sid>X('phpParent',       s:comment_grey, '', '')
call <sid>X('phpType',         s:purple,       '', '')
call <sid>X('phpSuperGlobals', s:red,          '', '')

" }}}
" Python {{{

call <sid>X('pythonImport',          s:purple,      '', '')
call <sid>X('pythonBuiltin',         s:cyan,        '', '')
call <sid>X('pythonStatement',       s:purple,      '', '')
call <sid>X('pythonParam',           s:dark_yellow, '', '')
call <sid>X('pythonEscape',          s:red,         '', '')
call <sid>X('pythonSelf',            s:mono_2,      '', 'italic')
call <sid>X('pythonClass',           s:blue,        '', 'bold')
call <sid>X('pythonOperator',        s:purple,      '', '')
call <sid>X('pythonEscape',          s:red,         '', '')
call <sid>X('pythonFunction',        s:light_blue,  '', '')
call <sid>X('pythonKeyword',         s:light_blue,  '', '')
call <sid>X('pythonModule',          s:purple,      '', '')
call <sid>X('pythonStringDelimiter', s:green,       '', '')
call <sid>X('pythonSymbol',          s:cyan,        '', '')

" }}}
" Ruby {{{

call <sid>X('rubyBlock',                     s:purple,     '', '')
call <sid>X('rubyBlockParameter',            s:red,        '', '')
call <sid>X('rubyBlockParameterList',        s:red,        '', '')
call <sid>X('rubyCapitalizedMethod',         s:purple,     '', '')
call <sid>X('rubyClass',                     s:purple,     '', '')
call <sid>X('rubyConstant',                  s:yellow,     '', '')
call <sid>X('rubyControl',                   s:purple,     '', '')
call <sid>X('rubyDefine',                    s:purple,     '', '')
call <sid>X('rubyEscape',                    s:red,        '', '')
call <sid>X('rubyFunction',                  s:light_blue, '', '')
call <sid>X('rubyGlobalVariable',            s:red,        '', '')
call <sid>X('rubyInclude',                   s:light_blue, '', '')
call <sid>X('rubyIncluderubyGlobalVariable', s:red,        '', '')
call <sid>X('rubyInstanceVariable',          s:red,        '', '')
call <sid>X('rubyInterpolation',             s:cyan,       '', '')
call <sid>X('rubyInterpolationDelimiter',    s:red,        '', '')
call <sid>X('rubyKeyword',                   s:light_blue, '', '')
call <sid>X('rubyModule',                    s:purple,     '', '')
call <sid>X('rubyPseudoVariable',            s:red,        '', '')
call <sid>X('rubyRegexp',                    s:cyan,       '', '')
call <sid>X('rubyRegexpDelimiter',           s:cyan,       '', '')
call <sid>X('rubyStringDelimiter',           s:green,      '', '')
call <sid>X('rubySymbol',                    s:cyan,       '', '')

" }}}
" Rust {{{

call <sid>X('rustExternCrate',          s:red,          '', 'bold')
call <sid>X('rustIdentifier',           s:light_blue,   '', '')
call <sid>X('rustDeriveTrait',          s:green,        '', '')
call <sid>X('SpecialComment',           s:comment_grey, '', '')
call <sid>X('rustCommentLine',          s:comment_grey, '', '')
call <sid>X('rustCommentLineDoc',       s:comment_grey, '', '')
call <sid>X('rustCommentLineDocError',  s:comment_grey, '', '')
call <sid>X('rustCommentBlock',         s:comment_grey, '', '')
call <sid>X('rustCommentBlockDoc',      s:comment_grey, '', '')
call <sid>X('rustCommentBlockDocError', s:comment_grey, '', '')

" }}}
" Text {{{

call <sid>X('txtURL', s:blue, '', '')

" }}}
" Vim {{{

call <sid>X('vimCommand',      s:purple,       '', '')
call <sid>X('vimCommentTitle', s:purple,       '', '')
call <sid>X('vimFunction',     s:light_blue,   '', '')
call <sid>X('vimFuncName',     s:purple,       '', '')
call <sid>X('vimHighlight',    s:cyan,         '', '')
call <sid>X('vimLineComment',  s:comment_grey, '', 'italic')
call <sid>X('vimParenSep',     s:mono_2,       '', '')
call <sid>X('vimSep',          s:mono_2,       '', '')
call <sid>X('vimUserFunc',     s:light_blue,   '', '')
call <sid>X('vimVar',          s:red,          '', '')

" }}}
" XML {{{

call <sid>X('xmlAttrib',  s:yellow, '', '')
call <sid>X('xmlEndTag',  s:red,    '', '')
call <sid>X('xmlTag',     s:red,    '', '')
call <sid>X('xmlTagName', s:red,    '', '')

" }}}
" ZSH {{{

call <sid>X('zshCommands',    s:syntax_fg,    '', '')
call <sid>X('zshDeref',       s:red,          '', '')
call <sid>X('zshShortDeref',  s:red,          '', '')
call <sid>X('zshFunction',    s:cyan,         '', '')
call <sid>X('zshKeyword',     s:purple,       '', '')
call <sid>X('zshSubst',       s:red,          '', '')
call <sid>X('zshSubstDelim',  s:comment_grey, '', '')
call <sid>X('zshTypes',       s:purple,       '', '')
call <sid>X('zshVariableDef', s:dark_yellow,  '', '')

" }}}

" }}}
" Plugins {{{

" Fugitive
call <sid>X('diffAdded',              s:green,        '', '')
call <sid>X('diffRemoved',            s:red,          '', '')

" Git gutter
call <sid>X('GitGutterAdd',         s:green,        '', '')
call <sid>X('GitGutterChange',      s:yellow,       '', '')
call <sid>X('GitGutterDelete',      s:red,          '', '')

" Interesting words (from Steve Losh's vimrc)
call <sid>X('InterestingWord1', s:black, s:yellow,      '')
call <sid>X('InterestingWord2', s:black, s:green,       '')
call <sid>X('InterestingWord3', s:black, s:purple,      '')
call <sid>X('InterestingWord4', s:black, s:dark_yellow, '')
call <sid>X('InterestingWord5', s:black, s:light_blue,  '')
call <sid>X('InterestingWord6', s:black, s:white,       '')

" VimFiler
call <sid>X('vimfilerMarkedFile', s:purple, '', '')

" }}}

" Delete functions {{{
delfunction <SID>X
delfunction <SID>rgb
delfunction <SID>color
delfunction <SID>rgb_color
delfunction <SID>rgb_level
delfunction <SID>rgb_number
delfunction <SID>grey_color
delfunction <SID>grey_level
delfunction <SID>grey_number

"}}}
