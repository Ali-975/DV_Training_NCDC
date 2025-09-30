`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Muddassir Ali Siddiqui
// 
// Create Date: 08/27/2025 03:14:51 PM
// Design Name: rv32i core
// Module Name: top
// Project Name: micore
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input logic clk,
    input logic rst

    );
    
    // Prog Cntr signals
    logic [31: 0] pc;
    logic [31: 0] next_pc;
    
    
    // Instr Mem signals
    logic [31: 0] instr;
    
    // Data Mem signals
    logic [31: 0] d_mem_d_out;
    
    // Control Unit signals
    logic reg_we;
    logic mem_we;
    logic mem_reg_w;
    logic op_b_sel;
    logic [1: 0] op_a_sel;
    logic [1: 0] alu_op;
    logic [6: 0] opcode;
    logic [1: 0] pc_sel;
    logic jump;
    logic branch;
    
    // regfile signals
    logic [4: 0] rs1;
    logic [4: 0] rs2;
    logic [4: 0] rd;
    logic [31: 0] reg_out_1;
    logic [31: 0] reg_out_2;
    logic [31: 0] wb_data;
    
    // Immediate signal
    logic [31: 0] imm;
    
    // AlU signals
    logic [31: 0] op_a;
    logic [31: 0] op_b;
    logic [31: 0] alu_out;
    logic [2: 0] func_3;
    logic [6: 0] func_7;
    logic [3:0] alu_instr;
    logic [3: 0] zero;
    logic n, z, c, v;
    
    // Flags negative, zero, carry, overflow
    assign n = zero[3];
    assign z = zero[2];
    assign c = zero[1];
    assign v = zero[0];

    prog_cntr p_c(.clk(clk), .rst(rst), 
                .next_pc(next_pc), .pc(pc));
    
    instr_mem IM(.addr(pc), .instr(instr));
    
    // instruction decode
    assign opcode = instr[6: 0];
    assign rs1 = instr[19: 15];
    assign rs2 = instr[24: 20];
    assign rd = instr[11: 7];
    assign func_3 = instr[14: 12];
    assign func_7 = instr[31: 25];
    
    control_unit cu(.opcode(opcode), .reg_we(reg_we), .mem_we(mem_we), 
                .mem_reg_w(mem_reg_w), .alu_op(alu_op), .op_a_sel(op_a_sel),
                .op_b_sel(op_b_sel), .pc_sel(pc_sel), .jump(jump), .branch(branch));
                
    imm_generation imm_gen(.instr(instr), .imm(imm));
    
    alu a_l_u(.op_1(op_a), .op_2(op_b), 
                .result(alu_out), .alu_instr(alu_instr), .zero(zero));
                
    alu_cntrl a_l_u_cntrl(.alu_op(alu_op), .func_3(func_3), 
                .func_7(func_7), .alu_instr(alu_instr));
                
    reg_file rf(.clk(clk), .rst(rst), .we(reg_we), .rs1(rs1), 
                .rs2(rs2), .rd(rd), .data_in(wb_data), 
                .reg_out_1(reg_out_1), .reg_out_2(reg_out_2));
                
    data_mem dm(.clk(clk), .rst(rst), .mem_re(func_3), 
                .mem_we(mem_we), .d_mem_addr(alu_out), 
                .data_in(reg_out_2), .data_out(d_mem_d_out));
    
    // for alu operand b
    assign op_b = (op_b_sel) ? imm : reg_out_2;
    
    // for alu operand a
    always_comb begin
        unique case (op_a_sel)
            2'b00: op_a = reg_out_1;
            2'b01: op_a = pc; // 
            2'b10: op_a = pc; // 
            2'b11: op_a = 0;
        endcase
    end
    
    // for register file what to write
    always_comb begin
        if(jump)
            wb_data = pc + 4; 
        else
            wb_data = (mem_reg_w) ? d_mem_d_out : alu_out;
    end
    
    // for program counter what is next pc
    always_comb begin
            unique case (pc_sel)
                2'b00: next_pc = pc + 4;
                2'b01: next_pc = pc + imm;                          // jal and branch
                2'b10: next_pc = reg_out_1 + imm;                   // jalr
                2'b11: begin                                        // branch
                    unique case (func_3)
                        3'b000: next_pc = (z)       ? pc + imm : pc + 4; // beq
                        3'b001: next_pc = (!z)      ? pc + imm : pc + 4; // bne
                        3'b100: next_pc = (n != v)  ? pc + imm : pc + 4; // blt
                        3'b101: next_pc = (n == v)  ? pc + imm : pc + 4; // bge
                        3'b110: next_pc = !c        ? pc + imm : pc + 4; // bltu
                        3'b111: next_pc = (c)       ? pc + imm : pc + 4; // bgeu
                        default: next_pc = pc + 4;
                    endcase
                end
            endcase
        end
endmodule
