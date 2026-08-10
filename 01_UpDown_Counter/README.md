# 4-Bit Synchronous Up/Down Counter

## Overview
RTL design and testbench for a 4-bit synchronous up/down counter written in Verilog. 

## Architecture
* **Synchronous Operation:** State changes are bound to the rising edge of the master clock (`posedge clk`).
* **Asynchronous Reset:** Active-high reset clears the register to `4'b0000` instantly.
* **Directional Control:** Signal `up_down` toggles direction (1 = Up, 0 = Down).

## Verification
Tested using Icarus Verilog (`iverilog`) and GTKWave. The testbench validates continuous increment, decrement, and mid-count asynchronous resets.
