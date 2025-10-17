# VIM Keymapping Cheatsheet
## Minimal .vimrc for DevOps & Multi-language Development

---

## File Operations

| Keybinding | Action |
|------------|--------|
| `Space + w` | Save file |
| `Space + q` | Quit |
| `Space + x` | Save and quit |
| `Space + e` | Open file explorer (Netrw) |
| `:w!!` | Save with sudo (for system files) |

---

## Search & Navigation

| Keybinding | Action |
|------------|--------|
| `Space + Space` | Clear search highlighting |
| `Ctrl + h` | Move to left window |
| `Ctrl + j` | Move to bottom window |
| `Ctrl + k` | Move to top window |
| `Ctrl + l` | Move to right window |
| `Space + bn` | Next buffer |
| `Space + bp` | Previous buffer |
| `Space + bd` | Delete buffer |

---

## Editing

| Keybinding | Action |
|------------|--------|
| `Space + j` | Move line/selection down |
| `Space + k` | Move line/selection up |
| `Space + /` | Toggle comment (filetype-aware) |
| `Space + p` | Toggle paste mode |
| `F2` | Toggle paste mode |
| `<` (visual mode) | Indent left (repeatable) |
| `>` (visual mode) | Indent right (repeatable) |

---

## Code Operations

| Keybinding | Action |
|------------|--------|
| `Space + fj` | Format JSON |
| `Space + r` | Execute current file |
| `Space + r` (visual) | Execute selected bash commands |

---

## Command-Line Mode

| Keybinding | Action |
|------------|--------|
| `Ctrl + p` | Previous command in history |
| `Ctrl + n` | Next command in history |

---

## Built-in Vim Commands (No Leader)

### Modes
| Keybinding | Action |
|------------|--------|
| `i` | Insert mode |
| `a` | Insert mode (after cursor) |
| `v` | Visual mode |
| `V` | Visual line mode |
| `Ctrl + v` | Visual block mode |
| `Esc` | Return to normal mode |

### Basic Editing
| Keybinding | Action |
|------------|--------|
| `dd` | Delete line |
| `yy` | Yank (copy) line |
| `p` | Paste after cursor |
| `P` | Paste before cursor |
| `u` | Undo |
| `Ctrl + r` | Redo |
| `x` | Delete character |
| `r` | Replace character |

### Search & Replace
| Keybinding | Action |
|------------|--------|
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` | Next search result |
| `N` | Previous search result |
| `:s/old/new/g` | Replace in current line |
| `:%s/old/new/g` | Replace in entire file |
| `:%s/old/new/gc` | Replace with confirmation |

### Window Splits
| Keybinding | Action |
|------------|--------|
| `:split` or `:sp` | Horizontal split |
| `:vsplit` or `:vsp` | Vertical split |
| `Ctrl + w + q` | Close current window |
| `Ctrl + w + w` | Switch between windows |

---

## Supported File Types

The .vimrc automatically detects and configures syntax for:

- **JavaScript/JSON** (2-space indent)
- **Python** (4-space indent, PEP8 column guide)
- **Go** (4-space tabs, no expandtab)
- **C** (4-space indent)
- **YAML/YML** (2-space indent)
- **Terraform** (.tf, .hcl files)
- **Docker** (Dockerfile*)
- **Ansible** (*.j2, *inventory)
- **Nginx** (nginx*.conf)
- **Environment files** (.env*)
- **Jenkinsfile** (Groovy syntax)
- **Configuration files** (*.conf)

---

## Quick Tips

1. **Leader Key**: Space (much easier than comma!)
2. **Trailing Whitespace**: Automatically removed on save
3. **Persistent Undo**: Undo history saved across sessions
4. **Line Numbers**: Absolute + relative for easy navigation
5. **Mouse Support**: Enabled if available
6. **System Clipboard**: Integrated if available

---

**Generated for ubuntu-server-configuration**
*Optimized for DevOps and Full Stack Development*
