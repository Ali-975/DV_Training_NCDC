`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Muddassir Ali Siddiqui
// 
// Create Date: 08/27/2025 03:14:51 PM
// Design Name: rv32i core
// Module Name: control_unit
// Project Name: micore
// 
//////////////////////////////////////////////////////////////////////////////////


module control_unit(
    input logic [6: 0] opcode,
    
    output logic reg_we,
    output logic mem_we,
    output logic mem_reg_w,
    output logic [1: 0] alu_op,
    output logic op_b_sel,
    output logic [1: 0] op_a_sel,
    output logic [1: 0] pc_sel,
    output logic jump,
    output logic branch
    );
    
    always_comb begin
        if(opcode == 7'b0110011) begin // R-type
            reg_we = 1'b1;
            mem_reg_w = 1'b0;
            mem_we = 1'b0;
            alu_op = 2'b10;
            op_b_sel = 1'b0;
            op_a_sel = 2'b00;
            pc_sel = 2'b00;
            jump = 1'b0;
            branch = 1'b0;
        end
        
        else if(opcode == 7'b0010011) begin // I-type
            reg_we = 1'b1;
            mem_reg_w = 1'b0;
            mem_we = 1'b0;
            alu_op = 2'b10;
            op_b_sel = 1'b1;
            op_a_sel = 2'b00;
            pc_sel = 2'b00;
            jump = 1'b0;
            branch = 1'b0;
        end
        else if(opcode == 7'b0100011) begin // store
            reg_we = 1'b0;
            mem_reg_w = 1'b0;
            mem_we = 1'b1;
            alu_op = 2'b00;
            op_a_sel = 2'b00;
            op_b_sel = 1'b1;
            pc_sel = 2'b00;
            jump = 1'b0;
            branch = 1'b0;
        end
        else if(opcode == 7'b0000011) begin // load
            reg_we = 1'b1;
            mem_reg_w = 1'b1;
            mem_we = 1'b0;
            alu_op = 2'b00;
            op_a_sel = 2'b00;
            op_b_sel = 1'b1;
            pc_sel = 2'b00;
            jump = 1'b0;
            branch = 1'b0;
        end
        else if(opcode == 7'b1101111) begin // Jal
            reg_we = 1'b1;
            mem_reg_w = 1'b0;
            mem_we = 1'b0;
            alu_op = 2'b00;
            op_b_sel = 1'b1;
            op_a_sel = 2'b00;
            pc_sel = 2'b01;
            jump = 1'b1;
            branch = 1'b0;
        end
        else if(opcode == 7'b1100111) begin // Jalr
            reg_we = 1'b1;
            mem_reg_w = 1'b0;
            mem_we = 1'b0;
            alu_op = 2'b00;
            op_b_sel = 1'b1;
            op_a_sel = 2'b00;
            pc_sel = 2'b10;
            jump = 1'b1;
            branch = 1'b0;
        end
        else if(opcode == 7'b1100011) begin // Branch
            reg_we = 1'b0;
            mem_reg_w = 1'b0;
            mem_we = 1'b0;
            alu_op = 2'b01;
            op_b_sel = 1'b0;
            op_a_sel = 2'b00;
            pc_sel = 2'b11;
            jump = 1'b1;
            branch = 1'b1;
        end
        else if(opcode == 7'b0110111) begin // lui
            reg_we = 1'b1;
            mem_reg_w = 1'b0;
            mem_we = 1'b0;
            alu_op = 2'b00;
            op_b_sel = 1'b1;
            op_a_sel = 2'b11;
            pc_sel = 2'b10;
            jump = 1'b1;
            branch = 1'b0;
        end
        else if(opcode == 7'b0010111) begin // auipc
            reg_we = 1'b1;
            mem_reg_w = 1'b0;
            mem_we = 1'b0;
            alu_op = 2'b00;
            op_b_sel = 1'b1;
            op_a_sel = 2'b01;
            pc_sel = 2'b10;
            jump = 1'b1;
            branch = 1'b0;
        end
        else begin
            reg_we = 1'b0;
            mem_reg_w = 1'b0;
            mem_we = 1'b0;
            alu_op = 2'b00;
            op_b_sel = 1'b0;
            op_a_sel = 2'b00;
            pc_sel = 2'b00;
            jump = 1'b0;
            branch = 1'b0;
        end
    end
    
endmodule
