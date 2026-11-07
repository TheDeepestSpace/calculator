// Combinational calculator datapath: signed add, subtract, multiply, divide, sine.
// sin: a is an angle in radians, Q16.16 fixed point; result is Q16.16 (b ignored). Assumes W=32.
module alu #(
    parameter W = 32
) (
    input  signed [W-1:0] a,
    input  signed [W-1:0] b,
    input         [2:0]   op,        // 0 add, 1 sub, 2 mul, 3 div, 4 sin
    output reg signed [W-1:0] result,
    output reg            overflow,  // result does not fit in W bits
    output reg            div_by_zero
);
    localparam OP_ADD = 3'd0, OP_SUB = 3'd1, OP_MUL = 3'd2, OP_DIV = 3'd3, OP_SIN = 3'd4;

    // Q16.16 constants
    localparam signed [63:0] ONE = 64'sd65536, PI = 64'sd205887,
                             HALF_PI = 64'sd102944, TWO_PI = 64'sd411775;
    reg signed [63:0] r, z, t;

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
            OP_SIN: begin
                // reduce to [-pi, pi], fold to [-pi/2, pi/2]
                r = a;
                r = r % TWO_PI;
                if (r > PI)  r = r - TWO_PI;
                if (r < -PI) r = r + TWO_PI;
                if (r > HALF_PI)  r = PI - r;
                if (r < -HALF_PI) r = -PI - r;
                // sin x = x(1 - z/6(1 - z/20(1 - z/42(1 - z/72)))), z = x^2
                z = (r * r) >>> 16;
                t = ONE - (z * ONE) / (72 * ONE);
                t = ONE - (z * t / ONE) / 42;
                t = ONE - (z * t / ONE) / 20;
                t = ONE - (z * t / ONE) / 6;
                result = (r * t) >>> 16;
            end
        endcase
    end
endmodule
