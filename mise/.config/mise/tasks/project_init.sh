#!/bin/bash

# mise.name=init
# mise.alias=init
# mise.description=Create new project structure in directory
# mise.dir={{cwd}}

[ "$(ls -A .)" ] && echo "Directory is not empty {{.USER_WORKING_DIR}}" && exit 1 || exit 0

git init
echo "# " >> README.md
echo "node_modules" >> .gitignore
echo "dist" >> .gitignore
echo "!.mise.toml" >> .gitignore
mise use task
task --init
mkdir apps
mkdir src
npm init -y
git add --all
git commit -m "Initial commit"
