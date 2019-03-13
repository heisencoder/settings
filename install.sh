#/bin/bash
# This script will setup a new home directory to point to ~/settings for overridden settings files
SETTINGS=settings
CONFIG_FILES='
  Xmodmap
  bashrc
  i3
  i3status.conf
  imwheel
  inputrc
  profile
  vimrc
  xsession
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
