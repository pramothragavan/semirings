#!/usr/bin/env bash
set -e

./parallel.sh "NrSemiringsWithOne(7, true)" | tee gen_numbers_2/semi-1-anti.txt
./parallel.sh "NrSemiringsWithOne(7, false)" | tee gen_numbers_2/semi-1-iso.txt
./parallel.sh "NrSemiringsWithZero(7, true)" | tee gen_numbers_2/semi-0-anti.txt
./parallel.sh "NrSemiringsWithZero(7, false)" | tee gen_numbers_2/semi-0-iso.txt
./parallel.sh "NrSemirings(7, true)" | tee gen_numbers_2/semi-anti.txt
./parallel.sh "NrSemirings(7, false)" | tee gen_numbers_2/semi-iso.txt
