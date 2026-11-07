// Combinational calculator datapath: signed add, subtract, multiply, divide, shift right/left.
module alu #(
    parameter W = 32
) (
    input  signed [W-1:0] a,
    input  signed [W-1:0] b,
    input         [2:0]   op,        // 0 add, 1 sub, 2 mul, 3 div, 4 shr, 5 shl (b = shift amount)
    output reg signed [W-1:0] result,
    output reg            overflow,  // result does not fit in W bits
    output reg            div_by_zero
);
    localparam OP_ADD = 3'd0, OP_SUB = 3'd1, OP_MUL = 3'd2, OP_DIV = 3'd3,
               OP_SHR = 3'd4, OP_SHL = 3'd5;

    wire signed [W:0]     sum  = a + b;
    wire signed [W:0]     diff = a - b;
    wire signed [2*W-1:0] prod = a * b;
    wire signed [W-1:0]   min  = {1'b1, {(W-1){1'b0}}};

    always @* begin
        result      = {W{1'b0}};
        overflow    = 1'b0;
        div_by_zero = 1'b0;
        case (op)
            OP_ADD: begin
                result   = sum[W-1:0];
                overflow = sum[W] != sum[W-1];
            end
            OP_SUB: begin
                result   = diff[W-1:0];
                overflow = diff[W] != diff[W-1];
            end
            OP_MUL: begin
                result   = prod[W-1:0];
                overflow = prod != {{W{result[W-1]}}, result};
            end
            OP_DIV: begin
                if (b == 0) begin
                    div_by_zero = 1'b1;
                end else if (a == min && b == -1) begin
                    result   = min;
                    overflow = 1'b1;
                end else begin
                    result = a / b;  // truncates toward zero
                end
            end
            // Shifts: b is the amount. Negative amount is invalid: result 0, overflow set.
            // Right shift is arithmetic (sign-filling); amounts >= W give 0 or -1.
            // Left shift sets overflow if bits are lost (result not a<<b exactly).
            OP_SHR: begin
                if (b < 0) overflow = 1'b1;
                else if (b >= W) result = a[W-1] ? {W{1'b1}} : {W{1'b0}};
                else result = a >>> b;
            end
            OP_SHL: begin
                if (b < 0) overflow = 1'b1;
                else if (b >= W) overflow = (a != 0);
                else begin
                    result   = a << b;
                    overflow = (result >>> b) != a;
                end
            end
        endcase
    end
endmodule
