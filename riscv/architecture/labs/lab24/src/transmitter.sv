`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2025 04:44:08 PM
// Design Name: 
// Module Name: transmitter
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


module transmitter (
    input  logic bclk,
    input  logic rst,          // active-low async reset
    input  logic tx_valid,     // active low trigger
    input  logic [7:0] d_in, 
    
    output logic tx_data,      // serial output
    output logic tx_status     // 1 while transmitting
);

    typedef enum logic [1:0]{
        IDLE = 2'b00,
        START = 2'b01,
        DATA = 2'b11,
        STOP = 2'b10
    } fsm_state;
    
    fsm_state current_state;
    logic [2:0] index;
    logic [7:0] data_reg;   

    // Sequential FSM
    always_ff @(posedge bclk or negedge rst) begin
        if (!rst) begin
            current_state <= IDLE;
            tx_data   <= 1'b1;
            tx_status <= 1'b0;
            index     <= 0;
            data_reg  <= 8'h00;
        end 
        else begin
            case (current_state)
                IDLE: begin
                    tx_data   <= 1'b1; // idle high
                    tx_status <= 1'b0;
                    index     <= 0;
                    current_state <= START;
                end

                START: begin
                    index   <= 0;
                    if (!tx_valid) begin   // trigger transmission
                        tx_data = 1'b0;
                        data_reg  <= d_in;
                        tx_status <= 1'b1;
                        current_state     <= DATA;
                    end
                end

                DATA: begin
                    tx_data <= data_reg[index];
                    if (index == 7)
                        current_state <= STOP;
                    else
                        index <= index + 1;
                end

                STOP: begin
                    tx_data   <= 1'b1; // stop bit
                    tx_status <= 1'b0;
                    current_state     <= IDLE;
                end
                default: current_state <= IDLE;
            endcase
        end
    end
endmodule