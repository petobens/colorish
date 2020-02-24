"===============================================================================
"          File: onedarkish.vim
"        Author: Ramzi Akremi (vim-one)
"    Maintainer: Pedro Ferrari
"       Created: 7 Mar 2017
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
function <sid>HL(group, fg, bg, attr, ...)
    let l:attr = a:attr
    if g:one_allow_italics == 0 && l:attr ==? 'italic'
        let l:attr= 'none'
    endif

    let l:bg = ''
    let l:fg = ''
    let l:decoration = ''
    let l:gui_under = ''

    if a:bg !=# ''
        let l:bg = ' guibg=#' . a:bg . ' ctermbg=' . <SID>rgb(a:bg)
    endif

    if a:fg !=# ''
        let l:fg = ' guifg=#' . a:fg . ' ctermfg=' . <SID>rgb(a:fg)
    endif

    if a:attr !=# ''
        let l:decoration = ' gui=' . l:attr . ' cterm=' . l:attr
    endif

    if a:0 && a:1 !=# ''
        let l:gui_under = ' guisp=#' . a:1
    endif

    let l:exec = l:fg . l:bg . l:decoration . l:gui_under

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

" Don't set normal bg color: See: https://github.com/neovim/neovim/issues/9019
" call <sid>HL('Normal',           s:syntax_fg,    s:black,       '')
call <sid>HL('Normal',           s:syntax_fg,    '',            '')
call <sid>HL('bold',             '',             '',            'bold')
call <sid>HL('ColorColumn',      '',             s:cursor_grey, '')
call <sid>HL('Conceal',          s:mono_4,       s:black,       '')
call <sid>HL('Cursor',           '',             s:blue,        '')
call <sid>HL('CursorIM',         '',             '',            '')
call <sid>HL('CursorColumn',     '',             s:cursor_grey, '')
call <sid>HL('CursorLine',       '',             s:cursor_grey, 'none')
if has('nvim')
    highlight! link QuickFixLine Normal
    call <sid>HL('TermCursor',   s:blue,         '',            '')
    call <sid>HL('NormalFloat',  s:syntax_fg,    s:black,       '')
endif
call <sid>HL('Directory',        s:light_blue,   '',            '')
call <sid>HL('ErrorMsg',         s:red,          s:black,       'none')
call <sid>HL('VertSplit',        s:cursor_grey,  '',            'none')
call <sid>HL('Folded',           s:comment_grey, s:black,       'none')
call <sid>HL('FoldColumn',       s:comment_grey, s:black,       '')
call <sid>HL('IncSearch',        s:dark_yellow,  '',            '')
call <sid>HL('LineNr',           s:mono_4,       '',            '')
call <sid>HL('CursorLineNr',     s:syntax_fg,    s:black,       'none')
call <sid>HL('MatchParen',       s:blue,         s:cursor_grey, 'bold')
call <sid>HL('Italic',           '',             '',            'italic')
call <sid>HL('ModeMsg',          s:dark_yellow,  '',            'none')
call <sid>HL('MoreMsg',          s:dark_yellow,  '',            'none')
call <sid>HL('NonText',          s:comment_grey, '',            'none')
call <sid>HL('PMenu',            s:syntax_fg,    s:pmenu,       '')
call <sid>HL('PMenuSel',         s:black,        s:light_blue,  '')
call <sid>HL('PMenuSbar',        s:syntax_fg,    s:pmenu,       '')
call <sid>HL('PMenuThumb',       '',             s:white,       '')
call <sid>HL('Question',         s:light_blue,   '',            '')
call <sid>HL('Search',           s:black,        s:yellow,      '')
call <sid>HL('SpecialKey',       s:special_grey, '',            'none')
if has('nvim')
    call <sid>HL('Whitespace',   s:special_grey, '',            'none')
endif
call <sid>HL('StatusLine',       s:syntax_fg,    s:cursor_grey, 'none')
call <sid>HL('StatusLineNC',     s:cursor_grey,  '',             '')
call <sid>HL('TabLine',          s:white,        s:black,       '')
call <sid>HL('TabLineFill',      s:comment_grey, s:visual_grey, 'none')
call <sid>HL('TabLineSel',       s:black,        s:light_blue,  '')
call <sid>HL('Title',            s:syntax_fg,    '',            'bold')
call <sid>HL('Visual',           '',             s:visual_grey, '')
call <sid>HL('VisualNOS',        '',             s:visual_grey, '')
call <sid>HL('WarningMsg',       s:dark_yellow,  '',            '')
call <sid>HL('TooLong',          s:red,          '',            '')
call <sid>HL('WildMenu',         s:black,        s:light_blue,  '')
call <sid>HL('SignColumn',       '',             s:black,       '')
call <sid>HL('Special',          s:light_blue,   '',            '')

" }}}
" Syntax highlighting {{{

call <sid>HL('Comment',        s:comment_grey, '',      'italic')
call <sid>HL('Constant',       s:green,        '',      '')
call <sid>HL('String',         s:green,        '',      '')
call <sid>HL('Character',      s:green,        '',      '')
call <sid>HL('Number',         s:dark_yellow,  '',      '')
call <sid>HL('Boolean',        s:dark_yellow,  '',      '')
call <sid>HL('Float',          s:dark_yellow,  '',      '')
call <sid>HL('Identifier',     s:red,          '',      'none')
call <sid>HL('Function',       s:light_blue,   '',      '')
call <sid>HL('Statement',      s:purple,       '',      'none')
call <sid>HL('Conditional',    s:purple,       '',      '')
call <sid>HL('Repeat',         s:purple,       '',      '')
call <sid>HL('Label',          s:purple,       '',      '')
call <sid>HL('Operator',       s:blue,         '',      'none')
call <sid>HL('Keyword',        s:red,          '',      '')
call <sid>HL('Exception',      s:purple,       '',      '')
call <sid>HL('PreProc',        s:yellow,       '',      '')
call <sid>HL('Include',        s:light_blue,   '',      '')
call <sid>HL('Define',         s:purple,       '',      'none')
call <sid>HL('Macro',          s:purple,       '',      '')
call <sid>HL('PreCondit',      s:yellow,       '',      '')
call <sid>HL('Type',           s:yellow,       '',      'none')
call <sid>HL('StorageClass',   s:yellow,       '',      '')
call <sid>HL('Structure',      s:yellow,       '',      '')
call <sid>HL('Typedef',        s:yellow,       '',      '')
call <sid>HL('Special',        s:light_blue,   '',      '')
call <sid>HL('SpecialChar',    '',             '',      '')
call <sid>HL('Tag',            '',             '',      '')
call <sid>HL('Delimiter',      s:blue,         '',      '')
call <sid>HL('SpecialComment', '',             '',      '')
call <sid>HL('Debug',          '',             '',      '')
call <sid>HL('Underlined',     '',             '',      '')
call <sid>HL('Ignore',         '',             '',      '')
call <sid>HL('Error',          s:red,          s:black, 'bold')
call <sid>HL('Todo',           s:red,          s:black, '')

" }}}
" Spelling {{{

call <sid>HL('SpellBad',   '', '', 'undercurl', s:red)
call <sid>HL('SpellLocal', '', '', 'undercurl', s:dark_yellow)
call <sid>HL('SpellCap',   '', '', 'undercurl', s:dark_yellow)
call <sid>HL('SpellRare',  '', '', 'undercurl', s:dark_yellow)

" }}}
" Vim Help {{{

call <sid>HL('helpCommand',      s:yellow, '', '')
call <sid>HL('helpExample',      s:yellow, '', '')
call <sid>HL('helpHeader',       s:white,  '', 'bold')
call <sid>HL('helpSectionDelim', s:comment_grey,  '', '')

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

call <sid>HL('asciidocListingBlock',   s:mono_2,  '', '')

" }}}
" C/C++ {{{

call <sid>HL('cInclude',          s:purple,       '', '')
call <sid>HL('cType',             s:purple,       '', '')
call <sid>HL('cPreCondit',        s:purple,       '', '')
call <sid>HL('cPreConditMatch',   s:purple,       '', '')
call <sid>HL('cCppString',        s:green,        '', '')
call <sid>HL('cType',             s:purple,       '', '')
call <sid>HL('cStorageClass',     s:purple,       '', '')
call <sid>HL('cStructure',        s:purple,       '', '')
call <sid>HL('cOperator',         s:purple,       '', '')
call <sid>HL('cStatement',        s:purple,       '', '')
call <sid>HL('cCommentL',         s:comment_grey, '', '')
call <sid>HL('cComment',          s:comment_grey, '', '')
call <sid>HL('cTODO',             s:purple,       '', '')
call <sid>HL('cConstant',         s:dark_yellow,  '', '')
call <sid>HL('cSpecial',          s:cyan,         '', '')
call <sid>HL('cSpecialCharacter', s:cyan,         '', '')
call <sid>HL('cString',           s:green,        '', '')
call <sid>HL('cppType',           s:purple,       '', '')
call <sid>HL('cppStorageClass',   s:purple,       '', '')
call <sid>HL('cppStructure',      s:purple,       '', '')
call <sid>HL('cppModifier',       s:purple,       '', '')
call <sid>HL('cppOperator',       s:purple,       '', '')
call <sid>HL('cppAccess',         s:purple,       '', '')
call <sid>HL('cppStatement',      s:purple,       '', '')
call <sid>HL('cppConstant',       s:red,          '', '')
call <sid>HL('cCppString',        s:green,        '', '')

" }}}
" CSS {{{

call <sid>HL('cssAttrComma',         s:purple,      '', '')
call <sid>HL('cssAttributeSelector', s:green,       '', '')
call <sid>HL('cssBraces',            s:mono_2,      '', '')
call <sid>HL('cssClassName',         s:dark_yellow, '', '')
call <sid>HL('cssClassNameDot',      s:dark_yellow, '', '')
call <sid>HL('cssDefinition',        s:purple,      '', '')
call <sid>HL('cssFontAttr',          s:dark_yellow, '', '')
call <sid>HL('cssFontDescriptor',    s:purple,      '', '')
call <sid>HL('cssFunctionName',      s:light_blue,  '', '')
call <sid>HL('cssIdentifier',        s:light_blue,  '', '')
call <sid>HL('cssImportant',         s:purple,      '', '')
call <sid>HL('cssInclude',           s:white,       '', '')
call <sid>HL('cssIncludeKeyword',    s:purple,      '', '')
call <sid>HL('cssMediaType',         s:dark_yellow, '', '')
call <sid>HL('cssProp',              s:cyan,        '', '')
call <sid>HL('cssPseudoClassId',     s:dark_yellow, '', '')
call <sid>HL('cssSelectorOp',        s:purple,      '', '')
call <sid>HL('cssSelectorOp2',       s:purple,      '', '')
call <sid>HL('cssStringQ',           s:green,       '', '')
call <sid>HL('cssStringQQ',          s:green,       '', '')
call <sid>HL('cssTagName',           s:red,         '', '')
call <sid>HL('cssAttr',              s:dark_yellow, '', '')

" }}}
" Diff {{{
call <sid>HL('DiffAdd',     s:green, s:visual_grey, '')
call <sid>HL('DiffChange',  s:dark_yellow, s:visual_grey, '')
call <sid>HL('DiffDelete',  s:red, s:visual_grey, '')
call <sid>HL('DiffText',    s:light_blue, s:visual_grey, '')
call <sid>HL('DiffAdded',   s:green, s:visual_grey, '')
call <sid>HL('DiffFile',    s:red, s:visual_grey, '')
call <sid>HL('DiffNewFile', s:green, s:visual_grey, '')
call <sid>HL('DiffLine',    s:light_blue, s:visual_grey, '')
call <sid>HL('DiffRemoved', s:red, s:visual_grey, '')

" }}}
" Git {{{

call <sid>HL('gitcommitComment',       s:comment_grey, '', '')
call <sid>HL('gitcommitUnmerged',      s:green,        '', '')
call <sid>HL('gitcommitOnBranch',      '',             '', '')
call <sid>HL('gitcommitBranch',        s:purple,       '', '')
call <sid>HL('gitcommitDiscardedType', s:red,          '', '')
call <sid>HL('gitcommitSelectedType',  s:green,        '', '')
call <sid>HL('gitcommitHeader',        '',             '', '')
call <sid>HL('gitcommitUntrackedFile', s:cyan,         '', '')
call <sid>HL('gitcommitDiscardedFile', s:red,          '', '')
call <sid>HL('gitcommitSelectedFile',  s:green,        '', '')
call <sid>HL('gitcommitUnmergedFile',  s:yellow,       '', '')
call <sid>HL('gitcommitFile',          '',             '', '')
hi link gitcommitNoBranch       gitcommitBranch
hi link gitcommitUntracked      gitcommitComment
hi link gitcommitDiscarded      gitcommitComment
hi link gitcommitSelected       gitcommitComment
hi link gitcommitDiscardedArrow gitcommitDiscardedFile
hi link gitcommitSelectedArrow  gitcommitSelectedFile
hi link gitcommitUnmergedArrow  gitcommitUnmergedFile

" }}}
" Go {{{

call <sid>HL('goBuiltins',     s:cyan,   '', '')
call <sid>HL('goConst',        s:purple, '', '')
call <sid>HL('goDeclaration',  s:purple, '', '')
call <sid>HL('goDeclType',     s:cyan,   '', '')
call <sid>HL('goField',        s:red,    '', '')
call <sid>HL('goFunctionCall', s:blue,   '', '')
call <sid>HL('goMethod',       s:cyan,   '', '')
call <sid>HL('goType',         s:yellow, '', '')
call <sid>HL('goTypeDecl',     s:purple, '', '')
call <sid>HL('goTypeName',     s:yellow, '', '')
call <sid>HL('goUnsignedInts', s:cyan,   '', '')
call <sid>HL('goVar',          s:purple, '', '')
call <sid>HL('goVarAssign',    s:red,    '', '')
call <sid>HL('goVarDefs',      s:red,    '', '')

" }}}
" HTML {{{

call <sid>HL('htmlArg',            s:dark_yellow, '',            '')
call <sid>HL('htmlTagName',        s:red,         '',            '')
call <sid>HL('htmlTagN',           s:red,         '',            '')
call <sid>HL('htmlSpecialTagName', s:red,         '',            '')
call <sid>HL('htmlTag',            s:mono_2,      '',            '')
call <sid>HL('htmlEndTag',         s:mono_2,      '',            '')
call <sid>HL('MatchTag',           s:red,         s:cursor_grey, 'bold')

" }}}
" JavaScript {{{

call <sid>HL('coffeeString',           s:green,   '', '')

call <sid>HL('javaScriptBraces',       s:mono_2,       '', '')
call <sid>HL('javaScriptFunction',     s:purple,       '', '')
call <sid>HL('javaScriptIdentifier',   s:purple,       '', '')
call <sid>HL('javaScriptNull',         s:dark_yellow,  '', '')
call <sid>HL('javaScriptNumber',       s:dark_yellow,  '', '')
call <sid>HL('javaScriptRequire',      s:cyan,         '', '')
call <sid>HL('javaScriptReserved',     s:purple,       '', '')
" https://github.com/pangloss/vim-javascript
call <sid>HL('jsArrowFunction',        s:purple,       '', '')
call <sid>HL('jsBraces',               s:mono_2,       '', '')
call <sid>HL('jsClassBraces',          s:mono_2,       '', '')
call <sid>HL('jsClassKeywords',        s:purple,       '', '')
call <sid>HL('jsDocParam',             s:light_blue,   '', '')
call <sid>HL('jsDocTags',              s:purple,       '', '')
call <sid>HL('jsFuncBraces',           s:mono_2,       '', '')
call <sid>HL('jsFuncCall',             s:light_blue,   '', '')
call <sid>HL('jsFuncParens',           s:mono_2,       '', '')
call <sid>HL('jsFunction',             s:purple,       '', '')
call <sid>HL('jsGenerator',            s:yellow,       '', '')
call <sid>HL('jsGlobalObjects',        s:yellow,       '', '')
call <sid>HL('jsModuleWords',          s:purple,       '', '')
call <sid>HL('jsModules',              s:purple,       '', '')
call <sid>HL('jsNoise',                s:mono_2,       '', '')
call <sid>HL('jsNull',                 s:dark_yellow,  '', '')
call <sid>HL('jsOperator',             s:purple,       '', '')
call <sid>HL('jsParens',               s:mono_2,       '', '')
call <sid>HL('jsStorageClass',         s:purple,       '', '')
call <sid>HL('jsTemplateBraces',       s:dark_red,     '', '')
call <sid>HL('jsTemplateVar',          s:green,        '', '')
call <sid>HL('jsThis',                 s:red,          '', '')
call <sid>HL('jsUndefined',            s:dark_yellow,  '', '')
call <sid>HL('jsObjectValue',          s:light_blue,   '', '')
call <sid>HL('jsObjectKey',            s:cyan,         '', '')
" https://github.com/othree/yajs.vim
call <sid>HL('javascriptArrowFunc',    s:purple,       '', '')
call <sid>HL('javascriptClassExtends', s:purple,       '', '')
call <sid>HL('javascriptClassKeyword', s:purple,       '', '')
call <sid>HL('javascriptDocNotation',  s:purple,       '', '')
call <sid>HL('javascriptDocParamName', s:light_blue,   '', '')
call <sid>HL('javascriptDocTags',      s:purple,       '', '')
call <sid>HL('javascriptEndColons',    s:comment_grey, '', '')
call <sid>HL('javascriptExport',       s:purple,       '', '')
call <sid>HL('javascriptFuncArg',      s:white,        '', '')
call <sid>HL('javascriptFuncKeyword',  s:purple,       '', '')
call <sid>HL('javascriptIdentifier',   s:red,          '', '')
call <sid>HL('javascriptImport',       s:purple,       '', '')
call <sid>HL('javascriptObjectLabel',  s:white,        '', '')
call <sid>HL('javascriptOpSymbol',     s:cyan,         '', '')
call <sid>HL('javascriptOpSymbols',    s:cyan,         '', '')
call <sid>HL('javascriptPropertyName', s:green,        '', '')
call <sid>HL('javascriptTemplateSB',   s:dark_red,     '', '')
call <sid>HL('javascriptVariable',     s:purple,       '', '')

" }}}
" JSON {{{

call <sid>HL('jsonCommentError',       s:white,       '', ''        )
call <sid>HL('jsonKeyword',            s:red,         '', ''        )
call <sid>HL('jsonQuote',              s:light_blue,  '', ''        )
call <sid>HL('jsonTrailingCommaError', s:red,         '', 'reverse' )
call <sid>HL('jsonMissingCommaError',  s:red,         '', 'reverse' )
call <sid>HL('jsonNoQuotesError',      s:red,         '', 'reverse' )
call <sid>HL('jsonNumError',           s:red,         '', 'reverse' )
call <sid>HL('jsonString',             s:green,       '', ''        )
call <sid>HL('jsonBoolean',            s:purple,      '', ''        )
call <sid>HL('jsonNumber',             s:dark_yellow, '', ''        )
call <sid>HL('jsonStringSQError',      s:red,         '', 'reverse' )
call <sid>HL('jsonSemicolonError',     s:red,         '', 'reverse' )

" }}}
" Man {{{

hi link manTitle String
call <sid>HL('manFooter', s:comment_grey, '', '')

" }}}
" Markdown {{{

call <sid>HL('markdownUrl',              s:purple,      '', '')
call <sid>HL('markdownBold',             s:dark_yellow, '', 'bold')
call <sid>HL('markdownItalic',           s:dark_yellow, '', 'bold')
call <sid>HL('markdownCode',             s:green,       '', '')
call <sid>HL('markdownCodeBlock',        s:red,         '', '')
call <sid>HL('markdownCodeDelimiter',    s:green,       '', '')
call <sid>HL('markdownHeadingDelimiter', s:dark_red,    '', '')
call <sid>HL('markdownH1',               s:red,         '', '')
call <sid>HL('markdownH2',               s:red,         '', '')
call <sid>HL('markdownH3',               s:red,         '', '')
call <sid>HL('markdownH3',               s:red,         '', '')
call <sid>HL('markdownH4',               s:red,         '', '')
call <sid>HL('markdownH5',               s:red,         '', '')
call <sid>HL('markdownH6',               s:red,         '', '')
call <sid>HL('markdownListMarker',       s:red,         '', '')
" For mkd syntax (that mainly follows html)
call <sid>HL('htmlH1',                   s:dark_red,    '', 'bold')
call <sid>HL('htmlH2',                   s:dark_red,    '', 'bold')
call <sid>HL('htmlH3',                   s:dark_red,    '', 'bold')
call <sid>HL('htmlH3',                   s:dark_red,    '', 'bold')
call <sid>HL('htmlH4',                   s:dark_red,    '', 'bold')
call <sid>HL('htmlH5',                   s:dark_red,    '', 'bold')
call <sid>HL('htmlBold',                 s:dark_yellow, '', 'bold')
call <sid>HL('htmlItalic',               s:purple,      '', 'italic')
call <sid>HL('mkdHeading',               s:dark_red,    '', 'bold')
call <sid>HL('mkdURL',                   s:purple,      '', '')
call <sid>HL('mkdLink',                  s:blue,        '', 'none')

" }}}
" PHP {{{

call <sid>HL('phpClass',        s:yellow,       '', '')
call <sid>HL('phpFunction',     s:light_blue,   '', '')
call <sid>HL('phpFunctions',    s:light_blue,   '', '')
call <sid>HL('phpInclude',      s:purple,       '', '')
call <sid>HL('phpKeyword',      s:purple,       '', '')
call <sid>HL('phpParent',       s:comment_grey, '', '')
call <sid>HL('phpType',         s:purple,       '', '')
call <sid>HL('phpSuperGlobals', s:red,          '', '')

" }}}
" Python {{{

call <sid>HL('pythonImport',          s:purple,      '', '')
call <sid>HL('pythonBuiltin',         s:cyan,        '', '')
call <sid>HL('pythonStatement',       s:purple,      '', '')
call <sid>HL('pythonParam',           s:dark_yellow, '', '')
call <sid>HL('pythonEscape',          s:red,         '', '')
call <sid>HL('pythonSelf',            s:mono_2,      '', 'italic')
call <sid>HL('pythonClass',           s:blue,        '', 'bold')
call <sid>HL('pythonOperator',        s:purple,      '', '')
call <sid>HL('pythonEscape',          s:red,         '', '')
call <sid>HL('pythonFunction',        s:light_blue,  '', '')
call <sid>HL('pythonKeyword',         s:light_blue,  '', '')
call <sid>HL('pythonModule',          s:purple,      '', '')
call <sid>HL('pythonStringDelimiter', s:green,       '', '')
call <sid>HL('pythonSymbol',          s:cyan,        '', '')

" }}}
" Ruby {{{

call <sid>HL('rubyBlock',                     s:purple,     '', '')
call <sid>HL('rubyBlockParameter',            s:red,        '', '')
call <sid>HL('rubyBlockParameterList',        s:red,        '', '')
call <sid>HL('rubyCapitalizedMethod',         s:purple,     '', '')
call <sid>HL('rubyClass',                     s:purple,     '', '')
call <sid>HL('rubyConstant',                  s:yellow,     '', '')
call <sid>HL('rubyControl',                   s:purple,     '', '')
call <sid>HL('rubyDefine',                    s:purple,     '', '')
call <sid>HL('rubyEscape',                    s:red,        '', '')
call <sid>HL('rubyFunction',                  s:light_blue, '', '')
call <sid>HL('rubyGlobalVariable',            s:red,        '', '')
call <sid>HL('rubyInclude',                   s:light_blue, '', '')
call <sid>HL('rubyIncluderubyGlobalVariable', s:red,        '', '')
call <sid>HL('rubyInstanceVariable',          s:red,        '', '')
call <sid>HL('rubyInterpolation',             s:cyan,       '', '')
call <sid>HL('rubyInterpolationDelimiter',    s:red,        '', '')
call <sid>HL('rubyKeyword',                   s:light_blue, '', '')
call <sid>HL('rubyModule',                    s:purple,     '', '')
call <sid>HL('rubyPseudoVariable',            s:red,        '', '')
call <sid>HL('rubyRegexp',                    s:cyan,       '', '')
call <sid>HL('rubyRegexpDelimiter',           s:cyan,       '', '')
call <sid>HL('rubyStringDelimiter',           s:green,      '', '')
call <sid>HL('rubySymbol',                    s:cyan,       '', '')

" }}}
" Rust {{{

call <sid>HL('rustExternCrate',          s:red,          '', 'bold')
call <sid>HL('rustIdentifier',           s:light_blue,   '', '')
call <sid>HL('rustDeriveTrait',          s:green,        '', '')
call <sid>HL('SpecialComment',           s:comment_grey, '', '')
call <sid>HL('rustCommentLine',          s:comment_grey, '', '')
call <sid>HL('rustCommentLineDoc',       s:comment_grey, '', '')
call <sid>HL('rustCommentLineDocError',  s:comment_grey, '', '')
call <sid>HL('rustCommentBlock',         s:comment_grey, '', '')
call <sid>HL('rustCommentBlockDoc',      s:comment_grey, '', '')
call <sid>HL('rustCommentBlockDocError', s:comment_grey, '', '')

" }}}
" Text {{{

call <sid>HL('txtURL', s:blue, '', '')

" }}}
" Vim {{{

call <sid>HL('vimCommand',      s:purple,       '', '')
call <sid>HL('vimCommentTitle', s:purple,       '', '')
call <sid>HL('vimFunction',     s:light_blue,   '', '')
call <sid>HL('vimFuncName',     s:purple,       '', '')
call <sid>HL('vimHighlight',    s:cyan,         '', '')
call <sid>HL('vimLineComment',  s:comment_grey, '', 'italic')
call <sid>HL('vimParenSep',     s:mono_2,       '', '')
call <sid>HL('vimSep',          s:mono_2,       '', '')
call <sid>HL('vimUserFunc',     s:light_blue,   '', '')
call <sid>HL('vimVar',          s:red,          '', '')

" }}}
" HLML {{{

call <sid>HL('xmlAttrib',  s:yellow, '', '')
call <sid>HL('xmlEndTag',  s:red,    '', '')
call <sid>HL('xmlTag',     s:red,    '', '')
call <sid>HL('xmlTagName', s:red,    '', '')

" }}}
" ZSH {{{

call <sid>HL('zshCommands',    s:syntax_fg,    '', '')
call <sid>HL('zshDeref',       s:red,          '', '')
call <sid>HL('zshShortDeref',  s:red,          '', '')
call <sid>HL('zshFunction',    s:cyan,         '', '')
call <sid>HL('zshKeyword',     s:purple,       '', '')
call <sid>HL('zshSubst',       s:red,          '', '')
call <sid>HL('zshSubstDelim',  s:comment_grey, '', '')
call <sid>HL('zshTypes',       s:purple,       '', '')
call <sid>HL('zshVariableDef', s:dark_yellow,  '', '')

" }}}

" }}}
" Plugins {{{

" Denite
call <sid>HL('deniteSource_grepFile', s:light_blue, '', '')

" Defx
call <sid>HL('Defx_filename_3_marker', s:light_blue, '', '')
call <sid>HL('Defx_git_6_Modified', s:red, '', '')
call <sid>HL('Defx_git_6_Staged', s:green, '', '')
call <sid>HL('Defx_mark_0_readonly', s:dark_red, '', '')

" Fugitive
call <sid>HL('diffAdded',                s:green, '', '')
call <sid>HL('diffRemoved',              s:red,   '', '')
call <sid>HL('fugitiveUnstagedHeading',  s:red,   '', '')
call <sid>HL('fugitiveUnstagedModifier', s:red,   '', '')
call <sid>HL('fugitiveStagedHeading',    s:green, '', '')
call <sid>HL('fugitiveStagedModifier',   s:green, '', '')

" Git gutter
call <sid>HL('GitGutterAdd',         s:green,        '', '')
call <sid>HL('GitGutterChange',      s:yellow,       '', '')
call <sid>HL('GitGutterDelete',      s:red,          '', '')

" GitMessenger
call <sid>HL('gitmessengerHeader',      s:purple, '', '')
call <sid>HL('gitmessengerHash',        s:yellow, '', '')
call <sid>HL('gitmessengerPopupNormal', '', s:cursor_grey, '')

" HighlightedYank
call <sid>HL('HighlightedyankRegion', s:green,        '', '')

" Interesting words (from Steve Losh's vimrc)
call <sid>HL('InterestingWord1', s:black, s:yellow,      '')
call <sid>HL('InterestingWord2', s:black, s:green,       '')
call <sid>HL('InterestingWord3', s:black, s:purple,      '')
call <sid>HL('InterestingWord4', s:black, s:dark_yellow, '')
call <sid>HL('InterestingWord5', s:black, s:light_blue,  '')
call <sid>HL('InterestingWord6', s:black, s:white,       '')

" Neomake
call <sid>HL('NeomakeVirtualtextError', s:red, s:cursor_grey, '')
call <sid>HL('NeomakeVirtualtextWarning', s:dark_yellow, s:cursor_grey, '')
call <sid>HL('NeomakeVirtualtextInfo', s:red, s:cursor_grey, '')
call <sid>HL('NeomakeVirtualtextMessage', s:red, s:cursor_grey, '')

" Sneak
call <sid>HL('Sneak', s:black, s:purple, '')

" Tagbar
call <sid>HL('TagbarKind', s:yellow, '', '')
call <sid>HL('TagbarScope', s:yellow, '', '')
call <sid>HL('TagbarNestedKind', s:light_blue, '', '')
call <sid>HL('TagbarSignature', s:comment_grey, '', '')
call <sid>HL('TagbarType', s:light_blue, '', '')
call <sid>HL('TagbarVisibilityPrivate', s:dark_red, '', '')
call <sid>HL('TagbarVisibilityProtected', s:dark_red, '', '')
call <sid>HL('TagbarVisibilityPublic', s:green, '', '')
call <sid>HL('TagbarFoldIcon', s:light_blue, '', '')

" }}}

" Delete functions {{{
delfunction <SID>HL
delfunction <SID>rgb
delfunction <SID>color
delfunction <SID>rgb_color
delfunction <SID>rgb_level
delfunction <SID>rgb_number
delfunction <SID>grey_color
delfunction <SID>grey_level
delfunction <SID>grey_number

"}}}
