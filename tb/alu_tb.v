module alu_tb;
    reg signed [31:0] a, b;
    reg [2:0] op;
    wire signed [31:0] result;
    wire overflow, div_by_zero;
    integer fails = 0;

    alu dut (.a(a), .b(b), .op(op), .result(result), .overflow(overflow), .div_by_zero(div_by_zero));

    task check(input [2:0] o, input signed [31:0] x, y, input signed [31:0] exp,
               input exp_ovf, input exp_dz);
        begin
            op = o; a = x; b = y; #1;
            if (result !== exp || overflow !== exp_ovf || div_by_zero !== exp_dz) begin
                fails = fails + 1;
                $display("FAIL op=%0d a=%0d b=%0d -> %0d ovf=%b dz=%b", o, x, y, result, overflow, div_by_zero);
            end
        end
    endtask

    // sin check with tolerance of 2 LSB (Q16.16)
    task check_sin(input signed [31:0] x, input signed [31:0] exp);
        begin
            op = 6; a = x; b = 0; #1;
            if (result - exp > 2 || exp - result > 2 || overflow !== 1'b0 || div_by_zero !== 1'b0) begin
                fails = fails + 1;
                $display("FAIL sin(%0d) -> %0d expected %0d", x, result, exp);
            end
        end
    endtask

    initial begin
        check(0, 2, 3, 5, 0, 0);
        check(0, -2, -3, -5, 0, 0);
        check(0, 32'h7fffffff, 1, 32'h80000000, 1, 0);
        check(1, 2, 3, -1, 0, 0);
        check(1, 32'h80000000, 1, 32'h7fffffff, 1, 0);
        check(2, 6, 7, 42, 0, 0);
        check(2, -6, 7, -42, 0, 0);
        check(2, 65536, 65536, 0, 1, 0);
        check(3, 7, 2, 3, 0, 0);
        check(3, -7, 2, -3, 0, 0);
        check(3, 7, -2, -3, 0, 0);
        check(3, 5, 0, 0, 0, 1);
        check(3, 32'h80000000, -1, 32'h80000000, 1, 0);
        // right shift (arithmetic)
        check(4, 8, 2, 2, 0, 0);
        check(4, -8, 1, -4, 0, 0);
        check(4, -1, 31, -1, 0, 0);
        check(4, 5, 0, 5, 0, 0);
        check(4, 5, 32, 0, 0, 0);
        check(4, -5, 40, -1, 0, 0);
        check(4, 5, -1, 0, 1, 0);
        // left shift
        check(5, 3, 2, 12, 0, 0);
        check(5, -3, 2, -12, 0, 0);
        check(5, 1, 31, 32'h80000000, 1, 0);
        check(5, 1, 30, 32'h40000000, 0, 0);
        check(5, 1, 32, 0, 1, 0);
        check(5, 0, 40, 0, 0, 0);
        check(5, 32'h40000000, 1, 32'h80000000, 1, 0);
        check(5, 5, -1, 0, 1, 0);
        check_sin(0, 0);
        check_sin(102944, 65536);        // sin(pi/2) = 1
        check_sin(-102944, -65536);      // sin(-pi/2) = -1
        check_sin(205887, 0);            // sin(pi) = 0
        check_sin(34315, 32768);         // sin(pi/6) = 0.5
        check_sin(-34315, -32768);
        check_sin(411775 + 102944, 65536); // sin(2pi + pi/2): range reduction
        check_sin(-411775*3 + 34315, 32768);
        if (fails == 0) $display("PASS"); else $display("%0d FAILED", fails);
        $finish(fails != 0);
    end
endmodule
