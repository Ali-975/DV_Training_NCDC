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
    input logic clk,
    input logic rst,
    input logic tx_valid,
    input logic rx_data,
    
    input logic [7:0] d_in,
    input logic [1:0] sel_baud,
    
    output logic  rx_status,
    output logic  tx_data,
    output logic  tx_status,
    output logic [7:0] d_out
);
    logic bclkx8, bclk;
    
    // baudrate generation
    bdrate_gen bdrate(
            .clk(clk), .rst(rst), .sel_baud(sel_baud), 
            .bclk(bclk), .bclkx8(bclkx8)
    );
    
    // receiver
    receiver uart_receive(
            .clk(bclkx8), .rst(rst), .rx_data(rx_data), 
            .rx_status(rx_status), .d_out(d_out)
    );
    
    //transmitter
    transmitter uart_transmit(
            .bclk(bclk), .rst(rst), .tx_valid(tx_valid), 
            .d_in(d_in), .tx_data(tx_data), .tx_status(tx_status)
    );
endmodule
