`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Mr Muddassir Ali Siddiqui
// Project Name: Custom Processor
//
// Create Date: 08/19/2025 09:01:01 PM
// Module Name: register_file
// 
//////////////////////////////////////////////////////////////////////////////////


module register_file#(
    parameter REGF_WIDTH = 16)(
    input logic clk,
    
    input logic [$clog2($clog2(REGF_WIDTH))-1: 0] rs1,
    input logic [$clog2($clog2(REGF_WIDTH))-1: 0] rs2,
    input logic [$clog2($clog2(REGF_WIDTH))-1: 0] rd,
    
    input logic  [REGF_WIDTH - 1: 0] data_in,
    output logic [REGF_WIDTH - 1: 0] reg_out_1,
    output logic [REGF_WIDTH - 1: 0] reg_out_2
    );
    
    logic [REGF_WIDTH - 1: 0] register_file [0: $clog2(REGF_WIDTH)-1];
     
    initial begin
        $readmemb("fib_rf.mem", register_file);  // Initialize from memory file
//        $readmemh("register_file_init.hex", register_file);
    end
    
    // write on clk edge
    always_ff @(posedge clk) begin
        if(rd != 00)
            register_file[rd] = data_in;
        else
            register_file[rd] = 0;
    end
    
    // read combinational
    assign reg_out_1 = (rs1 != 0) ? register_file[rs1] : 0; // if access x0 so it is zero
    assign reg_out_2 = (rs2 != 0) ? register_file[rs2] : 0; // if access x0 so it is zero
    
endmodule
