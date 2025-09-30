`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/27/2025 03:15:24 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input logic clk,
    input logic rst

    );
    
    // Prog Cntr signals
    logic [31: 0]pc;
    
    // Instr Mem signals
    logic [31: 0] instr;
    logic [11: 0] addr;
    
    // Control Unit signals
    logic we;
    logic op_b_sel;
    logic [1: 0] alu_op;
    logic [6: 0] opcode;
    
    // regfile signals
    logic [4: 0] rs1;
    logic [4: 0] rs2;
    logic [4: 0] rd;
    logic [31: 0] reg_out_1;
    logic [31: 0] reg_out_2;
    
    // Immediate signal
    logic [31: 0] imm;
    
    // AlU signals
    logic [31: 0] op_a;
    logic [31: 0] op_b;
    logic [31: 0] wb_data;
    logic [2: 0] func_3;
    logic [6: 0] func_7;
    logic [3:0] alu_instr;
//    logic [6: 0] opcode;

    assign op_a = reg_out_1;
//    assign op_b = reg_out_2;

    prog_cntr p_c(.clk(clk), .rst(rst), .pc(pc));
    assign addr = pc[31: 0];
    instr_mem IM(.addr(addr), .instr(instr));
    
    assign opcode = instr[6: 0];
    assign rs1 = instr[19: 15];
    assign rs2 = instr[24: 20];
    assign rd = instr[11: 7];
    assign func_3 = instr[14: 12];
    assign func_7 = instr[31: 25];
    
//    reg_file rf(.clk(clk), .rst(rst), .we(we), .rs1(rs1), .rs2(rs2), .rd(rd), 
//                .data_in(wb_data), .reg_out_1(reg_out_1), .reg_out_2(reg_out_2));
    control_unit cu(.opcode(opcode), .we(we), .alu_op(alu_op), .op_b_sel(op_b_sel));
    imm_generation imm_gen(.instr(instr), .imm(imm));
    
    always_comb begin
        if(op_b_sel)
            op_b = imm;
        else
            op_b = reg_out_2;
    end
    
    alu a_l_u(.op_1(op_a), .op_2(op_b), .result(wb_data),.alu_instr(alu_instr));
    alu_cntrl a_l_u_cntrl(.alu_op(alu_op), .func_3(func_3), .func_7(func_7), .alu_instr(alu_instr));
    reg_file rf(.clk(clk), .rst(rst), .we(we), .rs1(rs1), .rs2(rs2), .rd(rd), 
                .data_in(wb_data), .reg_out_1(reg_out_1), .reg_out_2(reg_out_2));
    
    
    
endmodule
