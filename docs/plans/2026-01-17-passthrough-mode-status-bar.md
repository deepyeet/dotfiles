# Passthrough Mode Status Bar Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Transform the tmux status bar to a solid red "PASSTHROUGH" indicator when passthrough mode is active, hiding all catppuccin modules and windows.

**Architecture:** After TPM/catppuccin loads, capture the current window formats to user variables, then override all status bar options with conditional format strings that check `#{client_key_table}`. In passthrough mode, display a centered red bar; in normal mode, expand the saved catppuccin formats.

**Tech Stack:** tmux 3.5+, catppuccin/tmux plugin, TPM

---

## Background

### How Catppuccin Works
- Sets `window-status-format` and `window-status-current-format` with embedded color codes
- Uses user variables like `@thm_red`, `@thm_mantle` for colors
- Builds status modules as format strings in `@catppuccin_status_*` variables

### Key tmux Options
- `status-style` - Background/foreground of entire bar
- `status-left` / `status-right` - Content on left/right sides
- `window-status-format` - Format for inactive windows
- `window-status-current-format` - Format for active window
- `#{client_key_table}` - Current key table (empty = root, "passthrough" = passthrough)

### Catppuccin Colors (mocha)
- `@thm_red`: #f38ba8 (passthrough background)
- `@thm_crust`: #11111b (passthrough foreground)
- `@thm_mantle`: #181825 (normal background)
- `@thm_fg`: #cdd6f4 (normal foreground)

---

## Task 1: Add Format Capture Section

**Files:**
- Modify: `tmux/.tmux.conf` (after line 215, after TPM runs)

**Step 1: Add the format capture block**

Add this section immediately after `run '~/.tmux/plugins/tpm/tpm'` (line 215):

```tmux
# ==============================================================================
# PASSTHROUGH MODE STATUS BAR (captures catppuccin formats, sets conditionals)
# ==============================================================================
# Capture catppuccin's window formats before we override them.
# These run-shell commands store the current format strings in user variables.
run-shell 'tmux set -g @_normal_wsf "$(tmux show -gqv window-status-format)"'
run-shell 'tmux set -g @_normal_wscf "$(tmux show -gqv window-status-current-format)"'
```

**Step 2: Reload config and verify capture worked**

```bash
tmux source-file ~/.tmux.conf
tmux show -g @_normal_wsf
```

Expected: Output shows the catppuccin window-status-format string (with color codes and separators)

**Step 3: Commit**

```bash
cd ~/dotfiles && sl commit -m "tmux: capture catppuccin window formats for passthrough mode"
```

---

## Task 2: Define Passthrough Appearance

**Files:**
- Modify: `tmux/.tmux.conf` (continue in the passthrough section)

**Step 1: Add passthrough style definitions**

Add after the capture block:

```tmux
# Define the passthrough appearance - solid red bar with centered text
set -g @_passthrough_bg "#{@thm_red}"
set -g @_passthrough_fg "#{@thm_crust}"
```

**Step 2: Verify the variables are set**

```bash
tmux source-file ~/.tmux.conf
tmux show -g @_passthrough_bg
```

Expected: Shows `#{@thm_red}`

**Step 3: Commit**

```bash
cd ~/dotfiles && sl commit -m "tmux: define passthrough mode colors"
```

---

## Task 3: Add Conditional Status Style

**Files:**
- Modify: `tmux/.tmux.conf` (continue in the passthrough section)

**Step 1: Add conditional status-style**

Add after the passthrough definitions:

```tmux
# Conditional status bar background - red in passthrough, catppuccin mantle in normal
set -g status-style "#{?#{==:#{client_key_table},passthrough},bg=#{@thm_red} fg=#{@thm_crust},bg=#{@thm_mantle} fg=#{@thm_fg}}"
```

**Step 2: Test normal mode appearance**

```bash
tmux source-file ~/.tmux.conf
```

Expected: Status bar should still look normal (dark background from catppuccin)

**Step 3: Test passthrough mode appearance**

```bash
tmux set -g key-table passthrough
tmux refresh-client -S
```

Expected: Status bar background turns red (#f38ba8)

**Step 4: Return to normal mode**

```bash
tmux set -ug key-table
tmux refresh-client -S
```

Expected: Status bar returns to normal catppuccin appearance

**Step 5: Commit**

```bash
cd ~/dotfiles && sl commit -m "tmux: add conditional status-style for passthrough mode"
```

---

## Task 4: Add Conditional Status Left/Right

**Files:**
- Modify: `tmux/.tmux.conf` (continue in the passthrough section)

**Step 1: Add conditional status-left with centered PASSTHROUGH text**

```tmux
# In passthrough: centered PASSTHROUGH text. In normal: empty (catppuccin doesn't use status-left)
set -g status-left "#{?#{==:#{client_key_table},passthrough},#[align=centre bold] PASSTHROUGH ,}"
```

**Step 2: Add conditional status-right**

Note: This must preserve the existing status-right content from the user's config (catppuccin modules + claude constellation). We need to wrap the existing value.

```tmux
# In passthrough: empty. In normal: catppuccin modules + claude status
set -g status-right "#{?#{==:#{client_key_table},passthrough},,#{E:@catppuccin_status_application}#{E:@catppuccin_status_session}#(python3 ~/.claude/plugins/cache/claude-templates/tmux-statusline/1.1.0/bin/constellation.py --per-tab --space-before)}"
```

**Step 3: Test passthrough mode**

```bash
tmux source-file ~/.tmux.conf
tmux set -g key-table passthrough
tmux refresh-client -S
```

Expected: Status bar shows only centered "PASSTHROUGH" text on red background, no modules on the right

**Step 4: Test normal mode**

```bash
tmux set -ug key-table
tmux refresh-client -S
```

Expected: Status bar shows catppuccin modules on the right as usual

**Step 5: Commit**

```bash
cd ~/dotfiles && sl commit -m "tmux: add conditional status-left/right for passthrough mode"
```

---

## Task 5: Add Conditional Window Formats

**Files:**
- Modify: `tmux/.tmux.conf` (continue in the passthrough section)

**Step 1: Add conditional window-status-format**

```tmux
# In passthrough: hide windows. In normal: use captured catppuccin format
set -g window-status-format "#{?#{==:#{client_key_table},passthrough},,#{E:@_normal_wsf}}"
set -g window-status-current-format "#{?#{==:#{client_key_table},passthrough},,#{E:@_normal_wscf}}"
```

**Step 2: Test passthrough mode - windows should be hidden**

```bash
tmux source-file ~/.tmux.conf
tmux set -g key-table passthrough
tmux refresh-client -S
```

Expected: Status bar shows only "PASSTHROUGH" - no window tabs visible

**Step 3: Test normal mode - windows should appear**

```bash
tmux set -ug key-table
tmux refresh-client -S
```

Expected: Window tabs appear with catppuccin styling

**Step 4: Commit**

```bash
cd ~/dotfiles && sl commit -m "tmux: add conditional window formats for passthrough mode"
```

---

## Task 6: Simplify Toggle Bindings

**Files:**
- Modify: `tmux/.tmux.conf` (lines 138-149, the existing passthrough bindings)

**Step 1: Replace the existing passthrough bindings**

Find and replace lines 138-149 (the current passthrough ON/OFF bindings) with:

```tmux
# Passthrough ON: Disable prefix, switch to passthrough key-table, refresh display
bind-key -n M-\\ \
  set-option prefix None \; \
  set-option key-table passthrough \; \
  refresh-client -S

# Passthrough OFF: Restore prefix, return to root key-table, refresh display
bind-key -T passthrough M-\\ \
  set-option -u prefix \; \
  set-option -u key-table \; \
  refresh-client -S
```

**Step 2: Test the toggle**

```bash
tmux source-file ~/.tmux.conf
```

Press `M-\` (Alt+Backslash):
- Expected: Bar turns solid red with centered "PASSTHROUGH", windows hidden

Press `M-\` again:
- Expected: Bar returns to catppuccin appearance with windows and modules

**Step 3: Commit**

```bash
cd ~/dotfiles && sl commit -m "tmux: simplify passthrough toggle bindings"
```

---

## Task 7: Remove Old Passthrough Window Text Variables

**Files:**
- Modify: `tmux/.tmux.conf` (lines 182-186, the old @passthrough_mode_text variables)

**Step 1: Remove the obsolete passthrough window text definitions**

Delete these lines (they are no longer needed since we hide windows entirely):

```tmux
set -g @normal_window_text " #W#{@claude}"
set -g @passthrough_mode_text "#[fg=#{@thm_crust},bg=#{@thm_red},bold]#{E:@normal_window_text} [REMOTE]"
set -g @passthrough_mode_text_inactive "#[fg=#{@thm_crust},bg=#{@thm_maroon},bold]#{E:@normal_window_text}"
set -g @catppuccin_window_current_text '#{?#{==:#{client_key_table},passthrough},#{E:@passthrough_mode_text},#{E:@normal_window_text}}'
set -g @catppuccin_window_text '#{?#{==:#{client_key_table},passthrough},#{E:@passthrough_mode_text_inactive},#{E:@normal_window_text}}'
```

Replace with simple catppuccin window text (the default):

```tmux
set -g @catppuccin_window_text " #W#{@claude}"
set -g @catppuccin_window_current_text " #W#{@claude}"
```

**Step 2: Reload and verify everything still works**

```bash
tmux source-file ~/.tmux.conf
```

Test toggle with `M-\`:
- Passthrough: Solid red bar, centered "PASSTHROUGH"
- Normal: Catppuccin bar with windows and modules

**Step 3: Commit**

```bash
cd ~/dotfiles && sl commit -m "tmux: remove obsolete passthrough window text variables"
```

---

## Task 8: Final Integration Test

**Step 1: Full reload from scratch**

Kill your tmux server and restart to test fresh initialization:

```bash
tmux kill-server
tmux new-session
```

**Step 2: Verify normal mode**

Expected:
- Catppuccin-styled status bar (dark background)
- Window tabs with rounded separators
- Right side shows application module, session module, claude constellation

**Step 3: Verify passthrough mode**

Press `M-\`:

Expected:
- Solid red background (#f38ba8)
- Centered "PASSTHROUGH" text in dark color (#11111b)
- No window tabs visible
- No modules on right side
- Keys pass through to inner session

**Step 4: Verify return to normal**

Press `M-\` again:

Expected:
- Returns to catppuccin appearance
- All windows visible
- All modules visible
- Prefix key works again

**Step 5: Commit final state**

```bash
cd ~/dotfiles && sl commit -m "tmux: complete passthrough mode status bar redesign"
```

---

## Troubleshooting

### If format capture fails (empty @_normal_wsf)
The run-shell commands might be executing before catppuccin fully loads. Try adding a small delay:
```tmux
run-shell 'sleep 0.1 && tmux set -g @_normal_wsf "$(tmux show -gqv window-status-format)"'
```

### If conditionals don't refresh
Ensure `refresh-client -S` is in the toggle bindings. The `-S` flag forces status line redraw.

### If escaping issues occur
The captured format strings might contain characters that break the shell. Alternative approach: manually define the normal format instead of capturing it dynamically.

### If colors look wrong
Verify catppuccin is loading correctly:
```bash
tmux show -g @thm_red
```
Should output: `#f38ba8`
