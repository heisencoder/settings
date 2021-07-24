#/bin/bash
# This script will setup a new home directory to point to ~/settings for overridden settings files

# The location of this repository.  Should be placed in ~/settings
SETTINGS=settings

# These files will be copied to ~ with a period prepended
CONFIG_FILES='
  Xmodmap
  Xresources
  bashrc
  i3status.conf
  imwheelrc
  inputrc
  profile
  vimrc
  xsession
'

# These directories will be linked to ~/.config
CONFIG_DIRS='
  i3
  dunst
  terminator
'

cd ~

for f in $CONFIG_FILES; do
  if [ ! -e .$f ]; then
    echo "Linking $f"
    ln -s $SETTINGS/$f .$f
  else
    echo "File $f already exists"
  fi
done

cd ~/.config

for d in $CONFIG_DIRS; do
  if [ ! -e $d ]; then
    echo "Linking $d"
    ln -s ../$SETTINGS/$d .
  else
    echo "Directory $d already exists"
  fi
done

