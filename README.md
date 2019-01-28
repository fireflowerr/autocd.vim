# Autocd.vim

A cwd management tool for vim.
Keep your cwd in sync with your workflow so that functions, plugins, and external commands can
utilize getcwd() as a reliable current project directory.

![](./.github/preview.gif?raw=true "autocd")

## Features

* Highly configurable current directory setter.
* NERDTree integration. Keep NERDTree in sync with the output of this command.

## Installation

Use the plugin manager of your choice to install. Example using [dein](https://github.com/Shougo/dein.vim). If using NERDTree integration and vim-devicons, this plugin must be sourced after vim-devicons to prevent conflict.

```vim
call dein#add('paroxayte/autocd.vim')
```

## Configuration
*Below are some configuration examples. For a full list of configuration options see `:help autocd.vim-configuration`*

### Markers
Autocd works by processing various triggers each associated with a mark. When a trigger goes off,
autocd searches up the directory heiarchy looking for a specified marker. For instance if creating a
java project with maven there will be a pom.xml in the project root. To automatically change to the
root of a maven java project with :Autocd 

```vim
let g:autocd#markers_filetype = {
\  'java': ['pom.xml']
\}
```
*g:autocd#markers_filetype is a dictionary with keys corresponding to filetypes, and values
corresponding to search markers. For more information see `:help g:autocd#markers_filetype`*

In addition a filetype lookup, Autocd also provides a subpath lookup. If Eclipse and VScode
workspaces are both containted in a parent directory /user/Dev then the following configuration will
automatically sync the cwd with the project root. 

```vim
let g:autocd#markers_path = { 
\   'user/Dev': ['.project', '.vscode'],
\}
```
 To create special rules for a specific file, the file's full path can be used with
 `g:autocd#markers_path`.

```vim
let g:autocd#markers_path = { 
\   '/path/to/file': ['some_marker'],
\}
```

### Default
If search for markers fail, a default action can be preformed. To enable this
`g:autocd#markers_default = 1` must be set. By default, the behavior is the same as autochdir,
switching to the current file's containing directory. To modify this behavior
`g:autocd#makers_get_default()` may be overridden. The function is expected to return a string
representing the desired directory, or 1 to represent failure. For more information see `:help g:autocd#makers_get_default()`

### NERDTree Sync
To enable NERDTree synchronization `g:autocd#nts_enable = 1` must be set at startup. Alternatively
the functions `autocd#nts_enable()` and `autocd#nts_disable()` may be called to change the state of
this feature post startup.

### Commands & Autocommands
The sole command of Autocd is `:Autocd`. To run `:Autocd` automatically on BufEnter `g:autocd#autocmd_enable = 1` must be set on startup.

### Example Configuration
```vim
let g:autocd#nts_enable = 1
let g:autocd#autocmd_enable = 1
let g:autocd#markers_default = 1
let g:autocd#markers_filetype = {
\   'java': ['pom.xml']
\}
let g:autocd#markers_path = { 
\   'user_name/Dev': ['.project', '.vscode']
\}
```

## More Information 
For more information see `:help autocd.vim`

### Self Promotion
If this plugin is useful, give the repo a star!
