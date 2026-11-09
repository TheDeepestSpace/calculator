test:
	iverilog -g2005 -o build_alu rtl/alu.v tb/alu_tb.v && vvp build_alu
	iverilog -g2005 -o build_const rtl/constants.v tb/constants_tb.v && vvp build_const
	@rm -f build_alu build_const
	node evaluate.test.js
	node images.test.js
	node site.test.js

# Assemble the GitHub Pages artifact: frontend (index.html) + backend.
# The browser can't run verilator/iverilog, so the backend is the JS build of the
# datapath (evaluate.js); the Verilog sources are published alongside for reference.
site:
	rm -rf site
	mkdir -p site/rtl
	cp index.html evaluate.js site/
	cp rtl/*.v site/rtl/

.PHONY: test site
