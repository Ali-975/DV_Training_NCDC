`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Muddassir Ali Siddiqui
// 
// Create Date: 09/08/2025 03:02:51 PM
// Design Name: rv32i core
// Module Name: system_on_chip
// Project Name: misoc
// 
//////////////////////////////////////////////////////////////////////////////////


module system_on_chip(
    input  logic clk,
    input  logic rst
);

    // Instruction Bus Signals
    logic [31:0] addr;           // PC to instruction memory
    logic [31:0] instr;          // Instruction from memory
    
    // Data Bus Signals
    logic [31:0] data_addr;      // Address from core
    logic [31:0] d_mem_d_in;     // Data from core (for writes)
    logic [31:0] d_mem_d_out;    // Data to core (from reads)
    logic        data_we;        // Write enable from core
    logic [2:0]  data_be;        // Byte enable (func_3)
    logic        data_re;        // Read enable
    
    // Memory Mapping Unit Signals
    logic        mem_sel;        // Select data memory
    logic        uart_sel;       // Select UART
    logic [31:0] mem_data_out;   // Data from memory
    logic [31:0] uart_data_out;  // Data from UART
    logic        mem_we;         // Write enable to memory
    logic        uart_we;        // Write enable to UART

// ===================================================================
// Core Module Instantiation
// ===================================================================
    rv32i core(
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .d_mem_d_out(d_mem_d_out),
        .instr_mem_addr(addr),
        .data_mem_addr(data_addr),
        .d_mem_d_in(d_mem_d_in),
        .data_mem_we(data_we),
        .data_be(data_be),
        .data_re(data_re)
    );
    
// ===================================================================
// Instruction Memory Module Instantiation
// ===================================================================
    instr_mem instr_mem(
        .addr(addr),
        .instr(instr)
    );
    
// ===================================================================
// Memory Mapping Unit Module Instantiation
// ===================================================================
    memory_mapping_unit mmu(
        .data_addr(data_addr),
        .data_we(data_we),
        .data_re(data_re),
        .mem_data_out(mem_data_out),
        .uart_data_out(uart_data_out),
        .mem_sel(mem_sel),
        .uart_sel(uart_sel),
        .mem_we(mem_we),
        .uart_we(uart_we),
        .data_in_core(d_mem_d_out)
    );
    
// ===================================================================
// Data Memory Module Instantiation
// ===================================================================
    data_mem data_mem(
        .clk(clk),
        .rst(rst),
        .mem_re(data_be),
        .mem_we(mem_we),
        .d_mem_addr(data_addr),
        .data_in(d_mem_d_in),
        .data_out(mem_data_out)
    );
    
// ===================================================================
// UART Interface Module Instantiation (replaces old uart_tx)
// ===================================================================
    uart_interface uart(
        .clk(clk),
        .rst(rst),
        .data_addr(data_addr),
        .data_in(d_mem_d_in),
        .uart_we(uart_we),
        .data_be(data_be),
        .data_out(uart_data_out)
    );

endmodule