#!/bin/zsh
if [ -z "$(git status --short)" ]; then
  exit -1
else
  exit -0
fi
