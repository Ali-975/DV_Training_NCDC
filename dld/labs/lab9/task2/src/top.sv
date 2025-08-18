module top (
    input  logic        clk,
    input  logic        rst,
    input  logic [1:0]  mode,     // 00: SISO, 01: SIPO, 10: PISO, 11: PIPO
    input  logic        s_in,
    input  logic [3:0]  p_in,
    input  logic        load,

    output logic        s_out,
    output logic [3:0]  q_out
);

    // Internal wires for outputs from all shift registers
    logic [3:0] q_sipo, q_pipo;
    logic       s_siso, s_piso;
    logic clk_1hz;
    
    // Slow the Frequency of Clk
    slow_clk sc(
        .clk(clk),
        .rst(rst),
        .clk_1hz(clk_1hz)
    );

    // Instantiate all four types
    siso_shift_reg siso (.clk(clk_1hz), .rst(rst), .s_in(s_in), .s_out(s_siso));

    sipo_shift_reg sipo (.clk(clk_1hz), .rst(rst), .s_in(s_in), .q(q_sipo));

    piso_shift_reg piso (.clk(clk_1hz), .rst(rst), .load(load), .p_in(p_in), .s_out(s_piso));

    pipo_shift_reg pipo (.clk(clk_1hz), .rst(rst), .load(load), .p_in(p_in), .q(q_pipo));

    // Output selection logic based on mode
    always_comb begin
        case (mode)
            2'b00: begin q_out = 4'b0000; s_out = s_siso; end // SISO
            2'b01: begin q_out = q_sipo;  s_out = 1'b0;    end // SIPO
            2'b10: begin q_out = 4'b0000; s_out = s_piso;  end // PISO
            2'b11: begin q_out = pipo.q;  s_out = 1'b0;    end // PIPO
            default: begin q_out = 4'b0000; s_out = 1'b0;  end
        endcase
    end

endmodule
