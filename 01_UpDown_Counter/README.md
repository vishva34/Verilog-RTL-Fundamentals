# Front-End RTL Design Fundamentals

## Overview
This repository serves as a continuous engineering log of my front-end digital logic design projects. As an Electronics and Communication Engineering undergraduate preparing for advanced Master's studies in Integrated Circuit Design, I am undertaking an intensive, self-directed sprint to master RTL architecture, sequential logic, and hardware verification.

## Repository Architecture (Monorepo)
Rather than fragmenting fundamental modules into separate repositories, this monorepo demonstrates a clear progression of complexity:
* **01_UpDown_Counter:** 4-bit synchronous counter with asynchronous reset (Completed)
* *(Future projects like ALUs, State Machines, and Memory Controllers will be logged here)*

## Verification Standard
Every module included in this repository is fully simulated and verified using custom Verilog testbenches. Icarus Verilog (`iverilog`) is used for compilation, and waveforms are analyzed via GTKWave to ensure synthesis-ready, race-free hardware.
