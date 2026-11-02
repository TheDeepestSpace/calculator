test:
	iverilog -g2005 -o build_alu rtl/alu.v tb/alu_tb.v && vvp build_alu
	@rm -f build_alu
