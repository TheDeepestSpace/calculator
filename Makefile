test:
	iverilog -g2005 -o build_alu rtl/alu.v tb/alu_tb.v && vvp build_alu
	iverilog -g2005 -o build_const rtl/constants.v tb/constants_tb.v && vvp build_const
	@rm -f build_alu build_const
