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
    input  logic rst,        // active-low async reset
    input  logic tx_valid,     // active low trigger
    input  logic [7:0] d_in,
    
    output logic tx_data,      // serial output
    output logic tx_status     // 1 while transmitting
);

    typedef enum logic [1:0] { IDLE, START, DATA, STOP } fsm_state;
    
    fsm_state state;
    logic [2:0] index;
    logic [7:0] data_reg;   

    // Main FSM
    always_ff @(posedge bclk or negedge rst) begin
        if (!rst) begin
            state     <= IDLE;
            tx_data   <= 1'b1;       
            tx_status <= 1'b0;
            index     <= 0;
            data_reg  <= 8'h00;
        end else begin
            case (state)
                IDLE: begin
                    tx_data <= 1'b1; // idle high
                    if (!tx_valid && !tx_status) begin // active-low start
                        state     <= START;
                        data_reg  <= d_in;
                        tx_status <= 1'b1;
                    end
                end

                START: begin
                    tx_data <= 1'b0; // start bit
                    state   <= DATA;
                    index   <= 0;
                end

                DATA: begin
                    tx_data <= data_reg[index];
                    if (index == 7) begin
                        state <= STOP;
                    end else begin
                        index <= index + 1;
                    end
                end

                STOP: begin
                    tx_data   <= 1'b1; // stop bit
                    tx_status <= 1'b0;
                    state     <= IDLE;
                end
            endcase
        end
    end
endmodule
