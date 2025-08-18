`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2025 07:47:00 PM
// Design Name: 
// Module Name: uart
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


module uart(
    input logic clk, rst, tx_valid, rx_data,
    
    input logic [7:0] d_in,
    input logic [1:0] sel_baud,
    
    output logic  rx_status, tx_data, tx_status,
    output logic [7:0] d_out
);
    logic bclkx8, bclk;
    
    bdrate_gen bdrate(clk, rst, sel_baud, bclk, bclkx8); //baudrate generation
    
    receiver uart_receive(bclkx8, rst, rx_data, rx_status, d_out); //receiver
    
    transmitter uart_transmit(bclk, rst, tx_valid, d_in, tx_data, tx_status); //transmitter
endmodule
