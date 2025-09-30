`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Muddassir Ali Siddiqui
// 
// Create Date: 09/08/2025 03:02:51 PM
// Design Name: rv32i core
// Module Name: uart_top
// Project Name: misoc
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_interface(
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] data_addr,
    input  logic [31:0] data_in,
    input  logic        uart_we,
    input  logic [2:0]  data_be,
//    input  logic        rx_in,       // UART RX input
    output logic [31:0] data_out,
    output logic        tx_out       // UART TX output
);

    // UART interface signals
    logic [7:0]  uart_tx_data;
    logic [7:0]  uart_rx_data;
    logic        uart_tx_start;
    logic        uart_tx_busy;
    logic        uart_rx_done;
    logic        uart_rx_busy;
    logic [1:0]  baud_sel;
    logic [7:0]  uart_rx_buffer;
    logic        rx_data_valid;
    
    // Default baud rate selection (9600)
    assign baud_sel = 2'b00;
    
    // UART Top Module Instance
    uart uart_top(
        .clk(clk), .rst(rst), .tx_valid(uart_tx_start), .rx_data(uart_rx_buffer),
        .d_in(uart_tx_data), .sel_baud(baud_sel), .rx_status(uart_rx_busy),
        .tx_data(tx_out), .tx_status(uart_tx_busy), .d_out(uart_rx_data)
    );
    
    // Buffer received data
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            uart_rx_buffer <= 8'h00;
            rx_data_valid <= 1'b0;
        end else if (uart_rx_done) begin
            uart_rx_buffer <= uart_rx_data;
            rx_data_valid <= 1'b1;
        end else if (uart_we && data_addr == 32'd1600) begin
            // Clear valid flag when new data is written (for echo applications)
            rx_data_valid <= 1'b0;
        end
    end
    
    // Memory-mapped register access
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            uart_tx_data <= 8'h00;
            uart_tx_start <= 1'b0;
        end else begin
            uart_tx_start <= 1'b0;  // Default
            
            // Address 1600: Data register - triggers transmission
            if (uart_we && data_addr == 32'd1600 && !uart_tx_busy) begin
                uart_tx_data <= data_in[7:0];  // LSB of rs2
                uart_tx_start <= 1'b1;
            end
        end
    end
    
    // Memory-mapped register read
    always_comb begin
        data_out = 32'h00000000;
        
        case (data_addr)
            32'd1600: begin // Data register (read RX data)
                data_out = {24'h000000, uart_rx_buffer};
            end
            32'd1604: begin // Status register
                data_out = {28'h0000000, rx_data_valid, uart_rx_busy, uart_tx_busy, ~uart_tx_busy};
                // Bits: [3:0] = {rx_data_valid, rx_busy, tx_busy, tx_ready}
            end
            default: data_out = 32'h00000000;
        endcase
    end

endmodule
