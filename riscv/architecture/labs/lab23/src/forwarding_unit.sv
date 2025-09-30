`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Muddassir Ali Siddiqui
// 
// Create Date: 09/03/2025 04:00:01 PM
// Design Name: rv32i pipelined core
// Module Name: forwarding_unit
// Project Name: micore
// 
//////////////////////////////////////////////////////////////////////////////////


module forwarding_unit(
    // ID_EX stage register addresses
    input logic [4:0] id_ex_rs1,
    input logic [4:0] id_ex_rs2,
    input logic [4:0] id_ex_rd,
    
    // EX_MEM stage signals
    input logic [4:0] ex_mem_rd,
    input logic ex_mem_reg_we,
    input logic ex_mem_mem_re,
    
    // MEM_WB stage signals
    input logic [4:0] mem_wb_rd,
    input logic mem_wb_reg_we,
    
    // Forwarding control outputs
    output logic [1:0] forward_op_a_sel,
    output logic [1:0] forward_op_b_sel
);

    // Forward operand A (rs1) logic
    always_comb begin
        // Priority: EX/MEM stage forwarding first (most recent)
        if (ex_mem_rd == id_ex_rs1 && ex_mem_reg_we == 1'b1 && id_ex_rs1 != 5'b00000) begin
            if (ex_mem_mem_re == 1'b1)
                forward_op_a_sel = 2'b01; // Forward from memory (load hazard - need stall)
            else
                forward_op_a_sel = 2'b10; // Forward from EX/MEM ALU result
        end
        // MEM/WB stage forwarding (lower priority)
        else begin
            if (mem_wb_rd == id_ex_rs1 && mem_wb_reg_we == 1'b1 && id_ex_rs1 != 5'b00000) 
                forward_op_a_sel = 2'b11; // Forward from WB stage
            else 
                forward_op_a_sel = 2'b00; // No forwarding needed
        end
    end
    
    // Forward operand B (rs2) logic
    always_comb begin
        // Priority: EX/MEM stage forwarding first (most recent)
        if (ex_mem_rd == id_ex_rs2 && ex_mem_reg_we == 1'b1 && id_ex_rs2 != 5'b00000) begin
            if (ex_mem_mem_re == 1'b1)
                forward_op_b_sel = 2'b01; // Forward from memory (load hazard also need stall)
            else
                forward_op_b_sel = 2'b10; // Forward from EX_MEM ALU result
        end
        // MEM/WB stage forwarding (lower priority)
        else begin
            if (mem_wb_rd == id_ex_rs2 && mem_wb_reg_we == 1'b1 && id_ex_rs2 != 5'b00000) 
                forward_op_b_sel = 2'b11; // Forward from WB stage
            else 
                forward_op_b_sel = 2'b00; // No forwarding needed
        end
    end

endmodule
