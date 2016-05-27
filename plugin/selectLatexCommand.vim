" selectLatexCommand.vim - add text objects for latex commands
" Author:       Toni Peter <github.com/tehforsch>
" Version:      0.1

if exists("g:loaded_selectLatexCommand") || &cp || v:version < 700
  finish
endif
let g:loaded_selectLatexCommand = 1

function! s:GoToEndOfCommandName()
    " We search to the next non-alphabetical character with /\W
    " This doesnt take into account that latex commands can also be single non-alphabetical characters but who cares, honestly.
    execute "normal! /\\W\<CR>h"
endfunction

function! s:GoToEndOfParameters()
    if s:CurrentCharacter() ==# "{"
        normal! %
        " We end up at the closing {} bracket. We could still have multiple arguments to our command, therefore move one to the right and run this function again
        normal! l
        call s:GoToEndOfParameters()
    else
        return 0
    endif
endfunction

function! s:CursorAtEndOfLine()
    return col(".") == col("$")-1
endfunction

function! s:CurrentCharacter()
    return matchstr(getline('.'), '\%' . col('.') . 'c.')
endfunction

function! SelectEntireCommand()
    " Select the command thats closest to the left of the cursor
    call SelectCommandName()
    " We want to select the backslash too, this jumps to the beginning of the selection, selects the char to the left and jumps back and then moves one char to the right
    normal! oho
    " To check for parameters we will jump one char to the right to make those functions simpler
    normal! l
    " if the command has parameters, we need to select those as well.
    call s:GoToEndOfParameters()
    " We are now down but end up one character to the right of where we want to end.
    normal! h\<CR>
endfunction 

function! SelectCommandName()
    if s:CurrentCharacter() ==# "\\"
    else
        normal! F\
    endif
    " Begin selection one character to the right
    normal! lv
    " Select the entire name of the command
    call s:GoToEndOfCommandName()
endfunction

