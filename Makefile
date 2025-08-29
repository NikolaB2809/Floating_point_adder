SRC_DIR = ./
BUILD_DIR = ./build

SIMULATOR = iverilog

COMPILER = vvp

Adder_module:
	mkdir -p $(BUILD_DIR)
	$(SIMULATOR) -o ./build/Adder_module_tb.vvp Adder_module_tb.v Adder_module.v
	$(COMPILER) ./build/Adder_module_tb.vvp

FP_Adder_top:
	mkdir -p $(BUILD_DIR)
	$(SIMULATOR) -o ./build/FP_Adder_top_tb.vvp FP_Adder_top_tb.v FP_Adder_top.v
	$(COMPILER) ./build/FP_Adder_top_tb.vvp

Output_reg:
	mkdir -p $(BUILD_DIR)
	$(SIMULATOR) -o ./build/Output_reg_tb.vvp Output_reg_tb.v Output_reg.v
	$(COMPILER) ./build/Output_reg_tb.vvp

Setup_reg:
	mkdir -p $(BUILD_DIR)
	$(SIMULATOR) -o ./build/Setup_reg_tb.vvp Setup_reg_tb.v Setup_reg.v
	$(COMPILER) ./build/Setup_reg_tb.vvp

Shift_reg:
	mkdir -p $(BUILD_DIR)
	$(SIMULATOR) -o ./build/Shift_reg_tb.vvp Shift_reg_tb.v Shift_reg.v
	$(COMPILER) ./build/Shift_reg_tb.vvp

Wrapper:
	mkdir -p $(BUILD_DIR)
	$(SIMULATOR) -o ./build/FP_Adder_wrapper_tb.vvp FP_Adder_wrapper_tb.v FP_Adder_wrapper.v
	$(COMPILER) ./build/FP_Adder_wrapper_tb.vvp

clean:
	rm -rf $(BUILD_DIR)
	rm -rf *.vcd

.PHONY: clean
