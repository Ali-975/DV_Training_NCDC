`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Muddassir Ali Siddiqui
// 
// Create Date: 08/27/2025 03:14:51 PM
// Design Name: rv32i core
// Module Name: reg_file
// Project Name: micore
// 
//////////////////////////////////////////////////////////////////////////////////


module reg_file(
    input logic clk,
    input logic rst,
    input logic we,
    
    input logic [4: 0] rs1,
    input logic [4: 0] rs2,
    input logic [4: 0] rd,
    
    input logic  [31: 0] data_in,
    output logic [31: 0] reg_out_1,
    output logic [31: 0] reg_out_2
);
    
    integer i;
    logic [31: 0] register_file [0: 31];
    
    // write on clk edge
    always_ff @(posedge clk) begin
        if(rst) begin
            for (i = 0 ; i<=31 ; i=i+1) begin
                register_file[i] = 0;
            end
        end
        else begin
            if(we) begin
                if(rd != 00)
                    register_file[rd] = data_in;
                else
                    register_file[0] = 0;
            end
        end
    end
    
    // read combinational
    assign reg_out_1 = (rs1 != 0) ? register_file[rs1] : 0; // if access x0 so it is zero
    assign reg_out_2 = (rs2 != 0) ? register_file[rs2] : 0; // if access x0 so it is zero
    
endmodule
