module constants_tb;
    reg [1:0] sel;
    wire signed [31:0] value;
    integer fails = 0;
    constants dut (.sel(sel), .value(value));

    task check(input [1:0] s, input signed [31:0] exp);
        begin
            sel = s; #1;
            if (value !== exp) begin
                fails = fails + 1;
                $display("FAIL sel=%0d -> %0d (expected %0d)", s, value, exp);
            end
        end
    endtask

    initial begin
        check(0, 205887);  // pi   ~ 3.14159 in Q16.16
        check(1, 178145);  // e    ~ 2.71828 in Q16.16
        if (fails == 0) $display("PASS"); else $display("%0d FAILED", fails);
        $finish(fails != 0);
    end
endmodule
