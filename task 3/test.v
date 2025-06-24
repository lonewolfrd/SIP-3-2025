module PipelinedCPU_tb;
reg clk = 0, reset = 1;
PipelinedCPU cpu(.clk(clk), .reset(reset));

// Clock
always #5 clk = ~clk;

initial begin
    // Initialize instruction memory with ADD, SUB, LOAD
    cpu.instruction_mem[0] = 16'b0000_0001_0010_0011; // ADD R1 = R2 + R3
    cpu.instruction_mem[1] = 16'b0001_0100_0001_0011; // SUB R4 = R1 - R3
    cpu.instruction_mem[2] = 16'b0010_0101_1000_0000; // LOAD R5 = MEM[R8]

    // Initialize registers
    cpu.reg_file[2] = 8'd10;
    cpu.reg_file[3] = 8'd5;
    cpu.reg_file[8] = 8'd2; // LOAD address
    cpu.data_mem[2] = 8'd99;

    #10 reset = 0;

    // Run simulation for enough cycles
    #100;

    // Check results
    $display("R1 = %d", cpu.reg_file[1]); // Expect 15
    $display("R4 = %d", cpu.reg_file[4]); // Expect 10
    $display("R5 = %d", cpu.reg_file[5]); // Expect 99

    $finish;
end
endmodule
