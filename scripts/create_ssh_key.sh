#!/bin/bash

ssh-keygen -t rsa -b 4096 -f id_rsa -N ""

cat ~/.ssh/id_rsa.pub
