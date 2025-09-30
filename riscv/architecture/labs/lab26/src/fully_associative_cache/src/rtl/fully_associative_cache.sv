`timescale 1ns / 1ps

module cache_fully_associative(
    input  logic            clk_i,
    input  logic            rst_n_i,
    input  logic [15: 0]    addr_i,       // connect to physical_address[pa_pointer]
    output logic            hit_o,
    output logic [31: 0]    data_o
);
    
    logic [140:0] cache [0:255];

    // decode address
    logic [11: 0] tag;
    logic [1: 0]  word_offset;

    always_comb begin
        tag         = addr_i[15:4];
        word_offset = ~addr_i[3:2];
    end

    integer i;
    
    always_comb begin
        hit_o  = 1'b0;
        data_o = 32'b0;
        for (i = 0; i < 256; i = i + 1) begin
            if (cache[i][140] && (cache[i][139:128] == tag)) begin
                hit_o  = 1'b1;
                data_o = cache[i][32 * word_offset +: 32];
                break;  // stop search after hit
            end
        end
    end
endmodule