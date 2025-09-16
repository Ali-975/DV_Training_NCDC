`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Mr Muddassir Ali Siddiqui
// Project Name: Custom Processor
//
// Create Date: 08/19/2025 09:01:01 PM
// Module Name: program_counter
// 
//////////////////////////////////////////////////////////////////////////////////


module program_counter #(
    parameter PROG_VALUE = 3)(
    input  logic clk,
    input  logic rst,
    output logic [$clog2(PROG_VALUE+1)-1: 0] pc
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) 
            pc <= 0;
        else if (pc < PROG_VALUE)
            pc <= pc + 1;
        else
            pc <= 0;
    end

endmodule

