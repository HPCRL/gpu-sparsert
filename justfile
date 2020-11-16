tuneall:
    #!/usr/bin/env zsh
    source notchpeak.env.sh > /dev/null 2>&1
    for i in `seq 0 6` 11 12;
        bash autotune_float.sh $i

runbest:
    #!/usr/bin/env zsh
    source notchpeak.env.sh > /dev/null 2>&1
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:`readlink -f build/lib`
    for i in best.*.exe;
        echo $(echo $i | cut -d. -f 2)
        ./$i > runtime
        runtime=$(grep "kernel used" runtime | awk '{print $3}')

nsysbest:
    #!/usr/bin/env zsh 
    source notchpeak.env.sh > /dev/null 2>&1
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:`readlink -f build/lib`
    set -x
    for i in best.*.exe; do
        echo "=-=-=-= Starting $i =-=-=-=";
        bash autotune_float.sh $(echo $i | sed -r -n 's/best.contraction_1x1_(.*)_transposed.exe/\1/p') skip;
        /uufs/chpc.utah.edu/sys/installdir/cuda/11.0.2/bin/nsys profile -f true -o $(basename $i .exe) ./$i > /dev/null 2>&1;
    done
    set +x

profilebest:
    #!/usr/bin/env zsh
    source notchpeak.env.sh > /dev/null 2>&1
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:`readlink -f build/lib`
    set -x
    for i in best.*.exe; do
        echo "=-=-=-= Starting $i =-=-=-=";
        bash autotune_float.sh $(echo $i | sed -r -n 's/best.contraction_1x1_(.*)_transposed.exe/\1/p') skip;
        /uufs/chpc.utah.edu/sys/installdir/cuda/11.0.2/bin/ncu --section MemoryWorkloadAnalysis -f -o $(basename $i .exe) ./$i > /dev/null 2>&1;
    done
    set +x

convertncutocsv:
    #!/usr/bin/env zsh
    for i in *.ncu-rep;
        /uufs/chpc.utah.edu/sys/installdir/cuda/11.0.2/bin/ncu -i $i --details-all --csv > $(basename $i .ncu-rep).ncu.csv

createsummaries:
    #!/usr/bin/env zsh
    for i in *.csv;
        python printbottlenecks.py $i