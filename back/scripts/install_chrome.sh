#!/usr/bin/env bash

if [[ ! -d "$PWD/chrome" ]]; then
    mkdir chrome
fi

cd chrome

if [[ ! -f "$PWD/chrome/google-chrome-stable_current_amd64.deb" ]]; then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
fi

apt -y install ./google-chrome-stable_current_amd64.deb

cd ..
