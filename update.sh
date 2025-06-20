#!/bin/bash
git pull
rm -rf ./KernelSU
curl -LSs "https://raw.githubusercontent.com/SukiSU-Ultra/SukiSU-Ultra/main/kernel/setup.sh" | bash -s susfs-main
git add .
git commit -m 升级SukiSU-Ultra
git push