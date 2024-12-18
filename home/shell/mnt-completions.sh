#!/usr/bin/env bash

IFS=':' dbs=($ENCRYPTED_DIRS)
complete -W "${dbs[@]}" mnt
complete -W "${dbs[@]}" umnt
complete -W "${dbs[@]}" mntm
complete -W "${dbs[@]}" umntm
