#!/usr/bin/env bash

cd /opt/minecraft || exit
git add --all
git commit -m "$(date)"
git push origin master
