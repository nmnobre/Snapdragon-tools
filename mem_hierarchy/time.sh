#!/bin/sh

RUNS=10

for stride in 8 16 32
do	
	for k in `seq 1 $RUNS`
	do		
		sh ../darknet-on-arm/tools/scaling.sh -g performance -G powersave
		taskset 3 ./vec_aarch64_f $stride >> $stride.f.little.out
	done
	for k in `seq 1 $RUNS`
	do
		sh ../darknet-on-arm/tools/scaling.sh -g powersave -G performance
		taskset c ./vec_aarch64_f $stride >> $stride.f.big.out
	done
done

for stride in 8 16 32
do	
	for k in `seq 1 $RUNS`
	do		
		sh ../darknet-on-arm/tools/scaling.sh -g performance -G powersave
		taskset 3 ./vec_aarch64_b $stride >> $stride.b.little.out
	done
	for k in `seq 1 $RUNS`
	do
		sh ../darknet-on-arm/tools/scaling.sh -g powersave -G performance
		taskset c ./vec_aarch64_b $stride >> $stride.b.big.out
	done
done