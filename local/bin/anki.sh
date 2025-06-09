#!/bin/bash

QT_QPA_PLATFORM=xcb anki
export PIPEWIRE_LATENCY=128/48000
source /etc/profile
anki &
