#!/bin/bash
pactree -lu mingw-w64-x86_64-libkdegames-qt5 | tac |  sed -e 's/mingw-w64-x86_64\-\(.*\)/\1/'
