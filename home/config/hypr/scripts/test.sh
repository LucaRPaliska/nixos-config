echo -e "$(([ $(( $(date +%s%N) / 500000000 % 2 )) -eq 1 ] && echo "<i>...</i>" || echo "<i>   </i>"))"
