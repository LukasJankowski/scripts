#!/usr/bin/bash

echo ""
echo "MAC ESSID	FREQ CH	QLTY ENC TYP"

while IFS= read -r line; do

    ## test line contenst and parse as required
    [[ "$line" =~ Address ]] && mac=${line##*ss: }
    [[ "$line" =~ \(Channel ]] && { chn=${line##*nel }; chn=${chn:0:$((${#chn}-1))}; }
    [[ "$line" =~ Frequen ]] && { frq=${line##*ncy:}; frq=${frq%% *}; }
    [[ "$line" =~ Quality ]] && { 
        qual=${line##*ity=}
        qual=${qual%% *}
        lvl=${line##*evel=}
        lvl=${lvl%% *}
    }
    [[ "$line" =~ Encrypt ]] && enc=${line##*key:}
    [[ "$line" =~ ESSID ]] && {
        essid=${line##*ID:}
        typ=
    }
    [[ "$line" =~ IEEE ]] && {
    	typ="WPA/2"
    }
    [[ "$line" =~ "====" ]] && {
        [[ "$enc" = "off" ]] && {
            typ="Open"
        }
    	[[ "$enc" = "on" ]] && [[ "$typ" = "" ]] && {
    		typ="WEP"
    	}
    	echo "$mac $essid $frq $chn	$qual $enc $typ"  # output after ESSID
    }

done