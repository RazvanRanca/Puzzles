#!/bin/sh

grep -Eo '[][+.,><-]|![0-9]*' $1 | tr -d '\n' | tr '!' '\n' | scala -J-Xss1g miniJS ../test\ suite/interpreter.not | awk '{printf "%c", $0}'
echo ""

