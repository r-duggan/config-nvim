#!/bin/zsh
if [ -z "$(git status --short)" ]; then
  exit 0
else
  exit -1
fi
