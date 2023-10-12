#!/bin/bash

sleep 0.5

git -C $HOME/configs/ stash
git -C $HOME/configs/ pull
git -C $HOME/configs/ stash pop
