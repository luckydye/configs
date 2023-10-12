#!/bin/bash

git -C $HOME/configs/ stash
git -C $HOME/configs/ pull
git -C $HOME/configs/ stash pop

play setup_mac

sleep 0.5

git -C $HOME/configs/ add --all
git -C $HOME/configs/ commit -m "sync config"
git -C $HOME/configs/ push
