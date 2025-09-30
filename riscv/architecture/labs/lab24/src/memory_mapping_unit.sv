`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Muddassir Ali Siddiqui
// 
// Create Date: 09/08/2025 03:02:51 PM
// Design Name: rv32i core
// Module Name: memory_mapping_unit
// Project Name: misoc
// 
//////////////////////////////////////////////////////////////////////////////////


module memory_mapping_unit(
    input  logic [31:0] data_addr,
    input  logic        data_we,
    input  logic        data_re,
    input  logic [31:0] mem_data_out,
    input  logic [31:0] uart_data_out,
    output logic        mem_sel,
    output logic        uart_sel,
    output logic        mem_we,
    output logic        uart_we,
    output logic [31:0] data_in_core
);

    // Address space partitioning
    // Data Memory: 0x00000000 - 0x00000FFF
    // UART:        0x00000640 (1600) and 0x00000644 (1604)
    
    always_comb begin
        if (data_addr == 32'd1600 || data_addr == 32'd1604) begin
            // UART address range
            uart_sel = 1'b1;
            mem_sel = 1'b0;
            uart_we = data_we;
            mem_we = 1'b0;
            data_in_core = uart_data_out;
        end 
        else begin
            // Data memory address range
            uart_sel = 1'b0;
            mem_sel = 1'b1;
            uart_we = 1'b0;
            mem_we = data_we;
            data_in_core = mem_data_out;
        end
    end

endmodule
