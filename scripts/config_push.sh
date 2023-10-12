#!/bin/bash

sleep 0.5
cfg add --all
cfg commit -m "sync config"
cfg push
