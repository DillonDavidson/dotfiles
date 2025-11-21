#!/usr/bin/env bash

num="$1"

KANJI=$(echo "$num" | sed \
	-e 's/10/拾/g' \
	-e 's/0/零/g'  \
	-e 's/1/壱/g'  \
	-e 's/2/弐/g'  \
	-e 's/3/参/g'  \
	-e 's/4/肆/g'  \
	-e 's/5/伍/g'  \
	-e 's/6/陸/g'  \
	-e 's/7/漆/g'  \
	-e 's/8/捌/g'  \
	-e 's/9/玖/g')
echo "$KANJI"
