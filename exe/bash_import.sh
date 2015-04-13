#!/bin/bash

function ls() { /bin/ls --color=auto --hide '*.rb.txt' "$@"; }
