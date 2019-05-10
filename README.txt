MMS 2019 Winter Project

< Simulation >
If you want to simulate this project, type 'make sim_top' You can get more imformation in 'Makefile'
For simulation, you have to use 'verilog/src/sdfa_top_sim.v' This file is top module for simulation.

< Synthesis & Implementation >
If you want to synthesize this project, you have to use 'sdfa_top.v', not 'sdfa_top_sim.v'.
'sdfa_top.v' is located in 'verilog/src/top/'
Also, you have to instantiate PLL module from IP catalog.


