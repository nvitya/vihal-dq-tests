#!/bin/bash
set -e

DQC=/workvc/dq-lang/build/dq-comp
VIHAL=/workvc/vihal-dq

$DQC --target=arm_m7f-bare -O0 -g cpuonly.dq

clang++ --target=thumbv7em-none-eabihf -fuse-ld=lld -nostdlib \
  -Xlinker "--library-path=$VIHAL/core/ld" \
  -Xlinker "--script=$VIHAL/armm/stm32/f7/STM32F750x8_ram.ld" \
  .dqbuild/arm_m7f-bare/local/cpuonly.o \
  .dqbuild/arm_m7f-bare/local/armm_startup.o \
  .dqbuild/arm_m7f-bare/local/armm_vector_table.o \
  -o cpuonly.elf

llvm-size --format=sysv --radix=16 cpuonly.elf
