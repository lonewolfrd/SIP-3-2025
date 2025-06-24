module FIR_Filter #(
    parameter N = 4, // Number of taps
    parameter DATA_WIDTH = 8
)(
    input clk,
    input rst,
    input signed [DATA_WIDTH-1:0] x_in,        // Input sample
    output reg signed [DATA_WIDTH+3:0] y_out   // Output sample
);

    // Example coefficients (h0 = 1, h1 = 2, h2 = 3, h3 = 4)
    reg signed [DATA_WIDTH-1:0] coeffs [0:N-1] = '{8'd1, 8'd2, 8'd3, 8'd4};
    
    // Delay line
    reg signed [DATA_WIDTH-1:0] shift_reg [0:N-1];

    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < N; i = i + 1)
                shift_reg[i] <= 0;
            y_out <= 0;
        end else begin
            // Shift
            for (i = N-1; i > 0; i = i - 1)
                shift_reg[i] <= shift_reg[i-1];
            shift_reg[0] <= x_in;

            // Multiply-Accumulate
            y_out <= 0;
            for (i = 0; i < N; i = i + 1)
                y_out <= y_out + (shift_reg[i] * coeffs[i]);
        end
    end
endmodule
