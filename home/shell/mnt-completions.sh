#!/usr/bin/env bash

complete -W "${dbs[@]}" mnt
complete -W "${dbs[@]}" umnt
complete -W "${dbs[@]}" mntm
complete -W "${dbs[@]}" umntm
