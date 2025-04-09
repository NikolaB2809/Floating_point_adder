# Floating_point_adder

This Github repository containts a hardware implementation of an FP16 adder that can have up to 4 operands based on [John Hauser's HardFloat](https://github.com/bsg-external/HardFloat) written in Verilog, as well as simple testbenches used for testing the various modules which are part of the adder.

To clone the repository type in terminal:  
`git clone git@github.com:NikolaB2809/Floating_point_adder.git`

To run tests you must first change directory to the repo directory and run a Make command:  
```
cd Floating_point_adder  
make FP_Adder
```
You can test different modules by running different Make commands:
- `make FP_Adder`
- `make Adder_module`
- `make Output_reg`
- `make Setup_reg`
- `make Shift_reg`

To remove all of the generated files created by compiling the verilog code run:  
`make clean`
