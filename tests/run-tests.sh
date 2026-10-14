#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

./bin/practical01 < samples/p01.txt > "$tmp/p01"
grep -Fq 'KEYWORD      int' "$tmp/p01"
grep -Fq 'NUMBER       12' "$tmp/p01"

./bin/practical02 < samples/p02.c > "$tmp/p02"
grep -Fq 'Comments:   2' "$tmp/p02"
grep -Fq 'Keywords:   3' "$tmp/p02"
grep -Fq 'Identifiers:3' "$tmp/p02"
grep -Fq 'Lines:      7' "$tmp/p02"

./bin/practical03 < samples/p03.txt > "$tmp/p03"
grep -Fq 'Words starting with A/a: 2' "$tmp/p03"
grep -Fq 'Exponential numbers: 2' "$tmp/p03"

./bin/practical04 < samples/p04.txt > "$tmp/p04"
grep -Fq '= 14' "$tmp/p04"
grep -Fq '= 4' "$tmp/p04"

./bin/practical05 --upper < samples/p05.txt > "$tmp/p05-upper"
./bin/practical05 --lower < samples/p05.txt > "$tmp/p05-lower"
grep -Fxq 'FLEX AND YACC ON UBUNTU!' "$tmp/p05-upper"
grep -Fxq 'flex and yacc on ubuntu!' "$tmp/p05-lower"

./bin/practical06 samples/p06.txt > "$tmp/p06"
printf '0xA apples\nvalue=0xFF\n0x0\n' > "$tmp/p06-expected"
diff -u "$tmp/p06-expected" "$tmp/p06"

./bin/practical07 < samples/p07.txt > "$tmp/p07"
grep -Fq 'MATCH: This line ends with COM' "$tmp/p07"
grep -Fq 'MATCH: Another match.COM' "$tmp/p07"
! grep -Fq 'ends with com' "$tmp/p07"

./bin/practical08 < samples/p08.txt > "$tmp/p08"
grep -Fq '= 14' "$tmp/p08"
grep -Fq '= 5' "$tmp/p08"

./bin/practical09 < samples/p09.txt > "$tmp/p09" 2> "$tmp/p09.err"
grep -Fq '= 7' "$tmp/p09"
grep -Fq '= 3' "$tmp/p09"
grep -Fq 'Invalid input; continuing' "$tmp/p09"
grep -Fq '= 8' "$tmp/p09"

./bin/practical10 < samples/p10.txt > "$tmp/p10"
grep -Fq 'Valid FOR loop' "$tmp/p10"

./bin/value_added_icg < samples/icg.txt > "$tmp/icg"
grep -Fq 't1 = a + b' "$tmp/icg"
grep -Fq 't2 = t1 * 3' "$tmp/icg"
grep -Fq 'result = t4' "$tmp/icg"

echo 'All 11 practical smoke tests passed.'
