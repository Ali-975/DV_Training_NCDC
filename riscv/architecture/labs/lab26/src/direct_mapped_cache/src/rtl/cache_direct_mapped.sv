`timescale 1ns / 10ps

module cache_direct_mapped(
    input  logic            clk_i,
    input  logic            rst_n_i,
    input  logic [15: 0]    addr_i,       // connect to physical_address[pa_pointer]
    output logic            hit_o,
    output logic [31: 0]    data_o
);
    
    // data array (256 blocks × 4 words × 32 bits)
    logic [132: 0] cache [255: 0];

    // decode address
    logic [3: 0] tag;
    logic [7: 0] index;
    logic [1: 0] word_offset;
    
    always_comb begin
        tag         =  addr_i[15: 12];
        index       =  addr_i[11: 4];
        word_offset = ~addr_i[3: 2];
    end
    
    // On a miss, fill tag & set valid (write-allocate assumed for this task)
    always_comb begin
            if (cache[index][132] && cache[index][131: 128] == tag) begin
                data_o  <= cache [index] [32 * word_offset +: 32];
                hit_o   <= 1'b1;
            end
            else begin
                data_o  <= 32'b0;
                hit_o   <= 1'b0;
            end
    end
    
endmodule
