#!/bin/sh
# MSCS 630 Lab 2, Part 1: Virtual Memory Paging
# Simulator: ostep-homework/vm-paging/paging-linear-translate.py
# Run from inside ostep-homework/vm-paging. All runs use the default seed (0)
# unless -s is given, so outputs are reproducible.

mkdir -p results

# Task 1: Page table size analysis (-n 0 prints only the page table)
python3 paging-linear-translate.py -P 1k -a 1m -p 512m -v -n 0 > results/task1_a1m.txt
python3 paging-linear-translate.py -P 1k -a 2m -p 512m -v -n 0 > results/task1_a2m.txt
python3 paging-linear-translate.py -P 1k -a 4m -p 512m -v -n 0 > results/task1_a4m.txt
grep -c "0x8" results/task1_*.txt          # valid entries per run

# Task 2: Page allocation experiment (-c prints computed translations)
python3 paging-linear-translate.py -P 1k -a 16k -p 32k -v -u 0 -c > results/task2_u0.txt
python3 paging-linear-translate.py -P 1k -a 16k -p 32k -v -u 25 -c > results/task2_u25.txt
python3 paging-linear-translate.py -P 1k -a 16k -p 32k -v -u 50 -c > results/task2_u50.txt
python3 paging-linear-translate.py -P 1k -a 16k -p 32k -v -u 100 -c > results/task2_u100.txt
grep -c "0x8" results/task2_*.txt          # valid entries
grep -c "Invalid" results/task2_*.txt      # invalid accesses

# Task 3: Random seed experiments
python3 paging-linear-translate.py -P 8 -a 32 -p 1024 -v -s 1 -c > results/task3_s1.txt
python3 paging-linear-translate.py -P 8k -a 32k -p 1m -v -s 2 -c > results/task3_s2.txt
python3 paging-linear-translate.py -P 1m -a 256m -p 512m -v -s 3 -c > results/task3_s3.txt
grep -c "0x8" results/task3_*.txt
grep -c "Invalid" results/task3_*.txt

# Task 4 (Challenge): Paging limits (2>&1 captures error messages)
python3 paging-linear-translate.py -P 1k -a 64k -p 32k -v -c > results/task4_a_gt_p.txt 2>&1     # address space > physical memory
python3 paging-linear-translate.py -P 1k -a 32k -p 32k -v -c > results/task4_a_eq_p.txt 2>&1     # address space = physical memory
python3 paging-linear-translate.py -P 4k -a 1g -p 2g -v -n 0 > results/task4_too_big.txt 2>&1    # sizes of 1 GB or more
python3 paging-linear-translate.py -P 1 -a 16 -p 64 -v -c > results/task4_tiny_page.txt 2>&1     # smallest page (1 byte)
python3 paging-linear-translate.py -P 16k -a 16k -p 32k -v -c > results/task4_page_eq_a.txt 2>&1 # page = address space
python3 paging-linear-translate.py -P 32k -a 16k -p 64k -v -c > results/task4_page_gt_a.txt 2>&1 # page > address space
python3 paging-linear-translate.py -P 1k -a 15k -p 32k -v -c > results/task4_not_pow2.txt 2>&1   # non-power-of-2 space
grep -h "Error" results/task4_*.txt
