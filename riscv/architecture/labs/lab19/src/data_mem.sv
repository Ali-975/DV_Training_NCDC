`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Muddassir Ali Siddiqui
// 
// Create Date: 08/27/2025 03:14:51 PM
// Design Name: rv32i core
// Module Name: data_mem
// Project Name: micore
// 
//////////////////////////////////////////////////////////////////////////////////


module data_mem(
    input logic clk,
    input logic rst,
    input logic [2: 0] mem_re,
    input logic mem_we,
    
    input logic [31: 0] d_mem_addr,
    input logic [31: 0] data_in,
    
    output logic [31: 0] data_out
);

    
    logic datatype;    // '0' = signed, '1' = unsigned for half/byte loads
    logic [1: 0]  datasize;    // 00=word, 01=half, 10=byte
    
    assign datatype = mem_re[2];
    assign datasize = mem_re[1: 0];
    
    //64 x 32-bit memory array
    logic [31: 0] data_mem [0: 1023];

    // Synchronous reset + writes
    always_ff @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < 1024; i++)
                data_mem[i] <= 32'h00000000; // clear entire memory
        end
        else if (mem_we) begin
            int idx;
            idx = d_mem_addr[11: 2];  // word alligned index
            
            unique case (datasize)
                2'b10: begin
                    // full word
                    data_mem[idx] <= data_in;
                end
                
                2'b01: begin
                    // half word
                    if (d_mem_addr[1] == 1'b0)
                        data_mem[idx][15:0] <= data_in[15:0];
                    else
                        data_mem[idx][31:16] <= data_in[15:0];
                end
                
                2'b00: begin
                    // byte
                    unique case (d_mem_addr[1:0])
                        2'b00: data_mem[idx][7: 0] <= data_in[7:0];
                        2'b01: data_mem[idx][15: 8] <= data_in[7:0];
                        2'b10: data_mem[idx][23:16] <= data_in[7:0];
                        2'b11: data_mem[idx][31:24] <= data_in[7:0];
                    endcase
                end
                
                default: ; // no action
            endcase
        end
    end

    // Asynchronous read + sign/zero extension
    always_comb begin
        int idx;
        logic [31: 0] word;
        
        idx = d_mem_addr[11: 2];
        word = data_mem [idx];
        
        unique case (datasize)
            2'b10: begin // word
            
                data_out = word;
            end
            
            2'b01: begin //half word
                logic [15:0] half;
                logic        signbit;
                
                //1. load word
                if (d_mem_addr[1] == 1'b0) begin
                    half    = word[15:0];
                    signbit = word[15];
                end 
                else begin
                    half    = word[31:16];
                    signbit = word[31];
                end
                
                //2. load sign and read
                if (datatype == 1'b0) begin
                    // signed
                    data_out = {{16{signbit}}, half};
                end
                else begin
                    // unsigned
                    data_out = {16'b0, half};
                end
            end
            
            2'b00: begin // byte
                logic [7:0] bytes;
                logic       signbit;
                
                //1.load byte
                unique case (d_mem_addr[1:0])
                    2'b00: begin bytes = word[7: 0]; signbit = word[7]; end
                    2'b01: begin bytes = word[15: 8]; signbit = word[15]; end
                    2'b10: begin bytes = word[23:16]; signbit = word[23]; end
                    2'b11: begin bytes = word[31:24]; signbit = word[31]; end
                endcase
                
                //2. load sign and read
                if (datatype == 1'b0) begin
                    // signed
                    data_out = {{24{signbit}}, bytes};
                end 
                else begin
                    // unsigned
                    data_out = {24'b0, bytes};
                end
            end
            
            default: data_out = 32'b0;
        endcase
    end

endmodule
