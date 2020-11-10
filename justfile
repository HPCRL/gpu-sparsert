tuneall:
    #!/usr/bin/env zsh
    source notchpeak.env.sh
    for i in `seq 0 6` 11 12;
        bash autotune_float.sh $i
runall:
    #!/usr/bin/env zsh
    source notchpeak.env.sh
    for i in best.*.exe;
        echo $(echo $i | cut -d. -f 2)
        ./$i > runtime
        runtime=$(grep "kernel used" runtime | awk '{print $3}')