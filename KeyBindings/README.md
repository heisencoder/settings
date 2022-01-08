# Mac Key Bindings

This directory contains files to help change MacOS key shortcuts to more
closely match those of Windows.  These files are meant to be used together.

## DefaultKeyBindings.dict

This file should be copied to ~/Library/KeyBindings/DefaultKeyBinding.Dict
and will change Cocoa app key bindings (which includes Chrome and Safair) to
mostly match those of Windows assuming that you have switched Command for
Control on your external keyboard.  This file must not be a symlink.

Note that this file would have been sufficient except that Google Docs
overrides the keyboard shorts to explicitly match those of Mac, so it is
necessary to use Karabiner-Elements (see below) to remap several shortcuts
at a higher level.

However, Karabiner-Elements is not sufficient on its own because remapping
Home/End to Command-Left/Right Arrow causes Chrome to navigate forward and
backward when not focused in a input area.

## windows_shortcuts.json

This file is used by <a href="https://karabiner-elements.pqrs.org/">Karabiner-Elements</a>

First, install Karabiner-Elements, then visit this URL to install this file:

    karabiner://karabiner/assets/complex_modifications/import?url=https://github.com/heisencoder/settings/blob/master/KeyBindings/windows_shortcuts.json

See also https://github.com/rux616/karabiner-windows-mode for the primary source of this JSON file.
