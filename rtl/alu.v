// Combinational calculator datapath: signed add, subtract, multiply, divide.
module alu #(
    parameter W = 32
) (
    input  signed [W-1:0] a,
    input  signed [W-1:0] b,
    input         [1:0]   op,        // 0 add, 1 sub, 2 mul, 3 div
    output reg signed [W-1:0] result,
    output reg            overflow,  // result does not fit in W bits
    output reg            div_by_zero
);
    localparam OP_ADD = 2'd0, OP_SUB = 2'd1, OP_MUL = 2'd2, OP_DIV = 2'd3;

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
        endcase
    end
endmodule
