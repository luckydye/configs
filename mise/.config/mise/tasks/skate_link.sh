#!/bin/bash

[[ ! -z $(skate list) ]] && echo Skate already linked || skate link
