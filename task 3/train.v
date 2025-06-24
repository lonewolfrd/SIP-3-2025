module PipelinedCPU (
    input clk,
    input reset
);

// Define registers
reg [15:0] instruction_mem [0:15];  // Instruction memory
reg [7:0] data_mem [0:15];          // Data memory
reg [7:0] reg_file [0:15];          // Register file

// Pipeline registers
reg [15:0] IF_ID;
reg [15:0] ID_EX;
reg [7:0] EX_WB_result;
reg [3:0] EX_WB_dest;
reg [3:0] EX_WB_opcode;

// Fetch
reg [3:0] PC;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        PC <= 0;
    end else begin
        IF_ID <= instruction_mem[PC];
        PC <= PC + 1;
    end
end

// Decode
reg [3:0] opcode, dest, src1, src2;
reg [7:0] operand1, operand2;

always @(posedge clk) begin
    ID_EX <= IF_ID;

    opcode <= IF_ID[15:12];
    dest   <= IF_ID[11:8];
    src1   <= IF_ID[7:4];
    src2   <= IF_ID[3:0];

    operand1 <= reg_file[IF_ID[7:4]];
    operand2 <= reg_file[IF_ID[3:0]];
end

// Execute
reg [7:0] alu_result;

always @(posedge clk) begin
    case (opcode)
        4'b0000: alu_result <= operand1 + operand2;             // ADD
        4'b0001: alu_result <= operand1 - operand2;             // SUB
        4'b0010: alu_result <= data_mem[operand1];              // LOAD from address in operand1
        default: alu_result <= 8'h00;
    endcase

    EX_WB_result <= alu_result;
    EX_WB_dest   <= dest;
    EX_WB_opcode <= opcode;
end

// Write Back
always @(posedge clk) begin
    if (EX_WB_opcode != 4'bxxxx) begin
        reg_file[EX_WB_dest] <= EX_WB_result;
    end
end

endmodule
