# Colorish color schemes

Two color schemes for Vim (and Neovim) are included:
* Heraldish is based on
  [herald](https://github.com/h3rald/stash/blob/master/.vim/colors/herald.vim)
  by Favio Cevasco. The code and some of the color choices closely follow [Bad
  Wolf](https://github.com/sjl/badwolf) by Steve Losh.

* Onedarkish is my fork of [vim-one](https://github.com/rakr/vim-one), the
  excellent Atom syntax theme port for Vim and Neovim.  Many of the changes
  come from [onedark.vim](https://github.com/joshdick/onedark.vim)

Colors are optimized for GUI Vim and terminals that offer *true color* but
256-color terminals are also supported.

The color schemes additionally include
[vim-airline](https://github.com/vim-airline/vim-airline) themes to customize
your status line.

The first screenshot below shows a vim file and the second one a python file
using `heraldish` on Windows (with GUI Vim). The third and fourth screenshots
use `onedarkish` on Mac.

![heraldish_screenshot_1](https://cloud.githubusercontent.com/assets/2583971/4240990/12e1830a-39f0-11e4-9d50-11103676fd08.png)
![heraldish_screenshot_2](https://cloud.githubusercontent.com/assets/2583971/4240991/132282e2-39f0-11e4-9808-fdfbb5d8dce7.png)

## Installation

I recommend using [dein.vim](https://github.com/Shougo/dein.vim) and then simply
add `call dein#add('petobens/colorish')` to your `.vimrc` file.

If you don't use a plugin manager copy `heraldish.vim` (and/or `onedarkish.vim`)
to your `.vim/colors` folder.

To use the [vim-airline](https://github.com/vim-airline/vim-airline) themes add
`let g:airline_theme = g:colors_name` to your `vimrc` (or `init.vim`) file.
