module FIR_Filter_tb;

parameter N = 4;
parameter DATA_WIDTH = 8;

reg clk, rst;
reg signed [DATA_WIDTH-1:0] x_in;
wire signed [DATA_WIDTH+3:0] y_out;

FIR_Filter #(N, DATA_WIDTH) dut (
    .clk(clk),
    .rst(rst),
    .x_in(x_in),
    .y_out(y_out)
);

// Clock generation
always #5 clk = ~clk;

initial begin
    clk = 0; rst = 1;
    x_in = 0;

    #10 rst = 0;

    // Apply input sequence: 1, 2, 3, 4, 0, 0...
    x_in = 1; #10;
    x_in = 2; #10;
    x_in = 3; #10;
    x_in = 4; #10;
    x_in = 0; #10;
    x_in = 0; #10;

    $finish;
end

initial begin
    $monitor("Time=%0t | x_in=%d | y_out=%d", $time, x_in, y_out);
end

endmodule
