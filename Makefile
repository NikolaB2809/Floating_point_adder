SRC_DIR = ./
BUILD_DIR = ./build

SIMULATOR = iverilog

COMPILER = vvp

Adder_module:
	mkdir -p $(BUILD_DIR)
	$(SIMULATOR) -o ./build/Adder_module_tb.vvp Adder_module_tb.v Adder_module.v
	$(COMPILER) ./build/Adder_module_tb.vvp

FP_Adder:
	mkdir -p $(BUILD_DIR)
	$(SIMULATOR) -o ./build/FP_Adder_tb.vvp FP_Adder_tb.v FP_Adder.v
	$(COMPILER) ./build/FP_Adder_tb.vvp

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

clean:
	rm -rf $(BUILD_DIR)

.PHONY: clean
