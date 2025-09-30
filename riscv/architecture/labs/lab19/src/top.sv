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
    logic [1: 0] pc_sel;
    logic jump;
    
    // Instr Mem signals
    logic [31: 0] instr;
    logic [9: 0] addr;
    
    // Data Mem signals
    logic [31: 0] d_mem_d_out;
//    logic [11: 0] mem_we;
    
    // Control Unit signals
    logic reg_we;
    logic mem_we;
    logic mem_reg_w;
//    logic [2: 0] mem_re;
    logic op_b_sel;
    logic [1: 0] alu_op;
    logic [6: 0] opcode;
    
    
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
//    logic [6: 0] opcode;

    assign op_a = reg_out_1;
//    assign op_b = reg_out_2;

    prog_cntr p_c(.clk(clk), .rst(rst), 
                .next_pc(next_pc), .pc(pc));
    assign addr = pc[9: 0];
//    assign next_pc = pc;
    instr_mem IM(.addr(addr), .instr(instr));
    
    assign opcode = instr[6: 0];
    assign rs1 = instr[19: 15];
    assign rs2 = instr[24: 20];
    assign rd = instr[11: 7];
    assign func_3 = instr[14: 12];
    assign func_7 = instr[31: 25];
    
    control_unit cu(.opcode(opcode), .reg_we(reg_we), .mem_we(mem_we), 
                .mem_reg_w(mem_reg_w), .alu_op(alu_op), 
                .op_b_sel(op_b_sel), .pc_sel(pc_sel), .jump(jump));
                
    imm_generation imm_gen(.instr(instr), .imm(imm));
    
    assign op_b = (op_b_sel) ? imm : reg_out_2;
    
    alu a_l_u(.op_1(op_a), .op_2(op_b), 
                .result(alu_out), .alu_instr(alu_instr));
                
    alu_cntrl a_l_u_cntrl(.alu_op(alu_op), .func_3(func_3), 
                .func_7(func_7), .alu_instr(alu_instr));
                
    reg_file rf(.clk(clk), .rst(rst), .we(reg_we), .rs1(rs1), 
                .rs2(rs2), .rd(rd), .data_in(wb_data), 
                .reg_out_1(reg_out_1), .reg_out_2(reg_out_2));
                
    data_mem dm(.clk(clk), .rst(rst), .mem_re(func_3), 
                .mem_we(mem_we), .d_mem_addr(alu_out), 
                .data_in(reg_out_2), .data_out(d_mem_d_out));
    
//    assign wb_data = (mem_reg_w) ? d_mem_d_out : alu_out;
    
    always_comb begin
        if(jump)
            wb_data = pc + 4; 
        else
            wb_data = (mem_reg_w) ? d_mem_d_out : alu_out;
    end
    
    always_comb begin
        unique case (pc_sel)
            2'b00: next_pc = pc + 4;
            2'b01: next_pc = pc + imm; // jal
            2'b10: next_pc = reg_out_1 + imm; // jalr
            2'b11: next_pc = pc + 4;
        endcase
    end
endmodule
