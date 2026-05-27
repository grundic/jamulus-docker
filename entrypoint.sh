#!/bin/sh
if [ $# -eq 0 ]; then
   echo "launching default server"
   exec Jamulus -s -n
fi
exec Jamulus "$@"
