#!/bin/bash

sleep 0.5

git -C $HOME/configs/ add --all
git -C $HOME/configs/ commit -m "sync config"
git -C $HOME/configs/ push
