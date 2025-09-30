`timescale 1ns / 10ps

module cache_set_associative(
    input  logic            clk_i,
    input  logic            rst_n_i,
    input  logic [15: 0]    addr_i,       // connect to physical_address[pa_pointer]
    output logic            hit_o,
    output logic [31: 0]    data_o
);

    // two ways, each entry : {valid(1), tag(6), data(4×32=128)} = 135 bits
    logic [133: 0] cache0 [127: 0];
    logic [133: 0] cache1 [127: 0];

    // decode address
    logic [4:0] tag;
    logic [6:0] index;
    logic [1:0] word_offset;

    always_comb begin
        tag         =  addr_i[15: 11];
        index       =  addr_i[10: 4];
        word_offset = ~addr_i[ 3: 2];
    end

    // hit logic - check both ways
    always_comb begin
        if (cache0[index][133] && cache0[index][132:128] == tag) begin
            data_o <= cache0[index][32 * word_offset +: 32];
            hit_o  <= 1'b1;
        end
        else if (cache1[index][133] && cache1[index][132:128] == tag) begin
            data_o <= cache1[index][32 * word_offset +: 32];
            hit_o  <= 1'b1;
        end
        else begin
            data_o <= 32'b0;
            hit_o  <= 1'b0;
        end
    end

endmodule
