// Mathematical constants as signed Q(W-FRAC).FRAC fixed-point (default Q16.16).
module constants #(
    parameter W = 32
) (
    input         [1:0]   sel,       // 0 pi, 1 e
    output reg signed [W-1:0] value
);
    localparam FRAC = 16;
    // round(pi * 2^16) = 205887, round(e * 2^16) = 178145
    localparam signed [W-1:0] PI = 205887, E = 178145;
    always @* begin
        case (sel)
            2'd0:    value = PI;
            2'd1:    value = E;
            default: value = {W{1'b0}};
        endcase
    end
endmodule
