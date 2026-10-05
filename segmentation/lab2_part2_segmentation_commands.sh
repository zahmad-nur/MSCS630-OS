#!/bin/sh
# MSCS 630 Lab 2, Part 2: Virtual Memory Segmentation
# Simulator: ostep-homework/vm-segmentation/segmentation.py
# Run from inside ostep-homework/vm-segmentation.
# Flags: -a address space, -p physical memory, -b/-l segment 0 base/limit,
#        -B/-L segment 1 base/limit, -s seed, -A explicit addresses, -c compute answers

mkdir -p results
ALL=$(python3 -c "print(','.join(map(str,range(128))))")   # virtual addresses 0..127

# Task 1: Address translation with segmentation
python3 segmentation.py -a 128 -p 512 -b 0 -l 20 -B 512 -L 20 -s 0 -c > results/task1_s0.txt
python3 segmentation.py -a 128 -p 512 -b 0 -l 20 -B 512 -L 20 -s 1 -c > results/task1_s1.txt
python3 segmentation.py -a 128 -p 512 -b 0 -l 20 -B 512 -L 20 -s 2 -c > results/task1_s2.txt
grep -H "VA" results/task1_s*.txt

# Task 2: Segment boundaries (19 / 20 / 107 / 108), then all 128 addresses
python3 segmentation.py -a 128 -p 512 -b 0 -l 20 -B 512 -L 20 -A 19,20,107,108 -c > results/task2_bounds.txt
python3 segmentation.py -a 128 -p 512 -b 0 -l 20 -B 512 -L 20 -A $ALL -c > results/task2_sweep.txt
grep "VA" results/task2_bounds.txt
grep -c "VALID in" results/task2_sweep.txt     # expected 40
grep -c "VIOLATION" results/task2_sweep.txt    # expected 88

# Task 3: No valid addresses (both limits set to 0)
python3 segmentation.py -a 128 -p 512 -b 0 -l 0 -B 512 -L 0 -A $ALL -c > results/task3_none_valid.txt
grep -c "VALID in" results/task3_none_valid.txt    # expected 0
grep -c "VIOLATION" results/task3_none_valid.txt   # expected 128
