## Key Features

1. **Leader Key**: Set to `<space>` for easy access to custom commands.
2. **Line Numbers**: Enabled by default for better code navigation.
3. **Mouse Support**: Enabled for convenient resizing and navigation.
4. **Clipboard Sync**: Integrated with the system clipboard for seamless copy-paste operations.
5. **Search Enhancements**: Case-insensitive searching with smart case sensitivity.
6. **Split Management**: Configured for intuitive split creation and navigation.
7. **Statusline**: Utilizes mini.statusline for a clean and informative status display.
8. **LSP Integration**: Comprehensive Language Server Protocol setup for intelligent code assistance.
9. **Autocompletion**: Powered by nvim-cmp for smooth and context-aware suggestions.
10. **Syntax Highlighting**: Enhanced with Treesitter for accurate and performant syntax highlighting.
11. **Color Scheme**: Uses Tokyo Night theme for a pleasant coding environment.
12. **File Explorer**: Integrated Neo-tree for efficient file management.

## Custom Keymaps

### Window & Panel Navigation
- `<C-S-Left/Right/Up/Down>`: Navigate between window panels
- `<C-+/-`: Resize window height (increase/decrease)
- `<C-S-+/->`: Resize window width (increase/decrease)
- `<C-v/x/t>`: Open vertical/horizontal split or new tab

### Fast File Movement
- `<C-Left/Right>`: Move 5 words left/right
- `<C-Up/Down>`: Move 10 lines up/down

### File & Search Operations
- `<leader>sf`: Search files (Telescope)
- `<leader>sg`: Live grep (search text in files)
- `<C-j/k>`: Move one grep result down/up (inside Telescope)
- `<C-Down/Up>`: Move the selection 10 results; scroll near the window edge
- `<C-d/u>`: Alternate half-page jump keys (inside Telescope)
- `<ScrollWheelDown/Up>`: Move three results down/up (inside Telescope)
- `<LeftMouse>`: Open the clicked Telescope result
- `<C-f>`: Append a file glob filter to live grep; type the extension after the dot
- HTML and files larger than 1 MB skip previews to keep Telescope responsive
- `<leader>sw`: Search current word
- `<leader>sh`: Search help tags
- `<leader>sk`: Search keymaps
- `<leader>sd`: Search diagnostics
- `<leader>sr`: Resume last search
- `<leader>s.`: Search recent files
- `<leader>sn`: Search Neovim config files
- `<leader>s/`: Live grep in open files
- `<leader>/`: Fuzzy search in current buffer
- `<leader><leader>`: Find existing buffers

### File Tree (Neo-tree)
- `\`: Toggle/reveal file tree
- `H`: Toggle hidden files (in Neo-tree)
- `<C-o>`: Open terminal in current directory (in Neo-tree)

### LSP & Code Actions
- `gd`: Go to definition
- `gr`: Go to references
- `gI`: Go to implementation
- `gD`: Go to declaration
- `<leader>D`: Type definition
- `<leader>ds`: Document symbols
- `<leader>ws`: Workspace symbols
- `<leader>rn`: Rename variable
- `<leader>ca`: Code action
- `<leader>th`: Toggle inlay hints

### Python REPL (Iron)
- `<leader>rs`: Start REPL
- `<leader>rr`: Restart REPL
- `<leader>rh`: Hide REPL
- `<leader>rf`: Send file to REPL
- `<leader>rl`: Send line to REPL
- `<leader>rp`: Send paragraph to REPL
- `<leader>ru`: Send until cursor to REPL
- `<leader>r<space>`: Interrupt REPL
- `<leader>rq`: Exit REPL
- `<leader>rcl`: Clear REPL

### Utilities
- `<leader>f`: Format buffer
- `<leader>q`: Open diagnostic quickfix list
- `<leader>vrc`: Quick access to your vimrc
- `<leader>ya`: Yank entire file to clipboard
- `<CR><CR>`: Add empty line below in normal mode
- `<leader>td`: Toggle diagnostics
- `<Esc>`: Clear search highlights
- `<Esc><Esc>`: Exit terminal mode

## Plugin Management

Plugins are managed using `lazy.nvim`, providing a modular and efficient plugin ecosystem. Key plugins include:

- LSP configuration and autocompletion
- Telescope for fuzzy finding
- Treesitter for advanced syntax highlighting
- Various quality-of-life improvements (Comment.nvim, mini.nvim, etc.)

## Customization

The configuration is designed to be modular. You can add or modify plugins in the `lua/custom/plugins/` directory for easy maintenance and updates.

## Maintenance

Remember to occasionally update your plugins and Neovim itself to benefit from the latest features and bug fixes. Use `:Lazy update` to update plugins.

Happy coding, future Tanmay! May your keystrokes be efficient and your code elegant.
