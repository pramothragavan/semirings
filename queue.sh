#!/usr/bin/env bash
set -e

./parallel.sh "NrCommutativeSemiringsWithOneAndZero(8, true)" | tee gen_numbers_5/comm-0-1.txt
./parallel.sh "NrSemiringsWithOneAndZero(8, true)" | tee gen_numbers_5/semi-iso-anti-0-1.text
./parallel.sh "NrSemiringsWithOneAndZero(8, false)" | tee gen_numbers_5/semi-iso-0-1.text
./parallel.sh "NrCommutativeAiSemiringsWithOneAndZero(9, true)" | tee gen_numbers_5/comm-ai-0-1.txt
