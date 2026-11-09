# calculator

Minimalist calculator app: a numpad UI with continuous expression evaluation, backed by a Verilog ALU datapath.

Live demo: https://thedeepestspace.github.io/calculator/

Deployment: the Pages workflow runs `make site`, which publishes `index.html` (UI), `evaluate.js` (the JS build of the datapath used in the browser, since Verilog can't run there) and the Verilog sources under `rtl/`.
