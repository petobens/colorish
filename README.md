# Heraldish Color Scheme

Heraldish is a color scheme for GUI Vim based on
[herald](https://github.com/h3rald/stash/blob/master/.vim/colors/herald.vim) by
Favio Cevasco. The code and some of the color choices closely follow [Bad
Wolf](https://github.com/sjl/badwolf) by Steve Losh.

256-color terminals are also supported but there are some minor differences with
the GUI version.

The color scheme additionally includes a
[vim-airline](https://github.com/vim-airline/vim-airline) theme to customize
your status line.

The first screenshot below shows a vim file and the second one a python file.

![heraldish_screenshot_1](https://cloud.githubusercontent.com/assets/2583971/4240990/12e1830a-39f0-11e4-9d50-11103676fd08.png)
![heraldish_screenshot_2](https://cloud.githubusercontent.com/assets/2583971/4240991/132282e2-39f0-11e4-9808-fdfbb5d8dce7.png)

## Installation

I recommend using [dein.vim](https://github.com/Shougo/dein.vim) and then simply
add `call dein#add('petobens/heraldish')` to your `.vimrc` file.

If you don't use a plugin manager copy `heraldish.vim` to your
`.vim/colors` folder.

To use the [vim-airline](https://github.com/vim-airline/vim-airline) theme add
`let g:airline_theme = 'heraldish'` to your `vimrc` file.

