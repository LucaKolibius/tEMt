


c=0;for i in *; do c=$((c +1));mv ${i} "cn1_${c}.${i#*.}"; done
c=0;for i in *; do c=$((c +1));mv ${i} "cn2_${c}.${i#*.}"; done

