#!/bin/bash

#####
# TODO add check for installed software and may install it. 
#####

# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

git clone https://github.com/kboshold/nvim.dotfiles ~/.config/nvim
