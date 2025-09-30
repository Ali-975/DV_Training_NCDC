`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Muddassir Ali Siddiqui
// 
// Create Date: 09/01/2025 04:17:22 PM
// Design Name: rv32i pipelined core
// Module Name: top_5_stage_pipeline
// Project Name: micore
// 
//////////////////////////////////////////////////////////////////////////////////


module top_5_stage_pipeline(
    input logic clk,
    input logic rst
);

    // Prog Cntr signals
    logic [31: 0] pc;
    logic [31: 0] next_pc;
    
    
    // Instr Mem signals
    logic [31: 0] instr;
    
    // Data Mem signals
    logic [31: 0] d_mem_d_out;
    
    // Control Unit signals
    logic reg_we;
    logic mem_we;
    logic mem_re;
    logic mem_reg_w;
    logic op_b_sel;
    logic [1: 0] op_a_sel;
    logic [1: 0] alu_op;
    logic [6: 0] opcode;
    logic [1: 0] pc_sel;
    logic jump;
    logic branch;
    
    // regfile signals
    logic [4: 0] rs1;
    logic [4: 0] rs2;
    logic [4: 0] rd;
    logic [31: 0] reg_out_1;
    logic [31: 0] reg_out_2;
    logic [31: 0] wb_data;
    
    // Immediate signal
    logic [31: 0] imm;
    
    // AlU signals
    logic [31: 0] op_a;
    logic [31: 0] op_b;
    logic [31: 0] alu_out;
//    logic [2: 0] func_3;
//    logic [6: 0] func_7;
    logic [3:0] alu_instr;
    logic [3: 0] zero;
    logic n, z, c, v;
    
//=====================================================================
    // IF_ID_stage
//=====================================================================

    // instr mem
    
    logic [6: 0] if_id_opcode;
    logic [4: 0] if_id_rs1;
    logic [4: 0] if_id_rs2;
    logic [4: 0] if_id_rd;
    logic [2: 0] if_id_func_3;
    logic [6: 0] if_id_func_7;
//    logic [31: 0] if_id_imm_val;
    logic [31: 0] if_id_instr;
    
    // prog cntr
    logic [31: 0] if_id_pc;
    
//=====================================================================
    // ID_EX_stage
//=====================================================================

    // register file
    logic [31: 0] id_ex_reg_out_1;
    logic [31: 0] id_ex_reg_out_2;
    logic [4: 0] id_ex_rs1;
    logic [4: 0] id_ex_rs2;
    logic [4: 0] id_ex_rd;
    
    // immediate
//    logic [31: 0] if_id_imm;
    logic [31: 0] id_ex_imm;
    
    // control unit
    logic id_ex_reg_we;
    logic id_ex_mem_we;
    logic id_ex_mem_re;
    logic id_ex_mem_reg_w;
    logic [1: 0] id_ex_alu_op;
    logic id_ex_op_b_sel;
    logic [1: 0] id_ex_op_a_sel;
    logic [1: 0] id_ex_pc_sel;
    logic id_ex_jump;
    logic id_ex_branch;
    
    // alu
    logic [2: 0] id_ex_func_3;
    logic [6: 0] id_ex_func_7;
    
    // prog cntr output
    logic [31: 0] id_ex_pc;

//=====================================================================
    // EX_MEM_stage
//=====================================================================
    
    // alu
    logic [3: 0] ex_mem_zero;
    logic [31: 0] ex_mem_result;
    
    // register file
    logic [4: 0] ex_mem_rs1;
    logic [4: 0] ex_mem_rs2;
    logic [4: 0] ex_mem_rd;
    logic [31: 0] ex_mem_reg_out_1;
    logic [31: 0] ex_mem_reg_out_2;
    
    // control unit
    logic ex_mem_reg_we;
    logic ex_mem_mem_we;
    logic ex_mem_mem_re;
    logic ex_mem_mem_reg_w;
    logic [1: 0] ex_mem_pc_sel;
    logic ex_mem_jump;
    logic ex_mem_branch;
    logic [2: 0] ex_mem_func_3;
    
    // prog cntr output
    logic [31: 0] ex_mem_pc;
    
    // immediate
    logic [31: 0] ex_mem_imm;

//=====================================================================
    // MEM_WB_stage
//=====================================================================
    
    // control unit
    logic mem_wb_reg_we;
    logic mem_wb_mem_reg_w;
    logic mem_wb_jump;
    
    // register file
    logic [4: 0] mem_wb_rs1;
    logic [4: 0] mem_wb_rs2;
    logic [4: 0] mem_wb_rd;
    logic [31: 0] mem_wb_reg_out_1;
    
    // alu
    logic [31: 0] mem_wb_result;
    
    // data memory
    logic [31: 0] mem_wb_d_mem_d_out;
    
    // prog cntr output
    logic [31: 0] mem_wb_pc;
    
    // immediate
    logic [31: 0] mem_wb_imm;
    
//=====================================================================
    // Data Hazards Modules
//=====================================================================

// ======================= Forwarding Unit ============================
    
    // ======================= Forwarding Unit ============================
    
    logic [1: 0] forward_op_a_sel;
    logic [1: 0] forward_op_b_sel;
    logic [1: 0] forward_store_data_sel;
    
    logic [31: 0] forwarded_op_a;
    logic [31: 0] forwarded_op_b;
    logic [31: 0] forwarded_store_data;
    
// ======================= Hazard Detection Unit =======================
    
    logic stall;
    logic [31: 0] stall_pc;
    
// =====================================================================
// ======================== INSTANTIATION OF MODULES ===================
// =====================================================================

    prog_cntr p_c(.clk(clk), .rst(rst), 
                .next_pc(next_pc), .pc(pc));
    
    instr_mem IM(.addr(pc), .instr(instr));
    
    control_unit cu(.opcode(if_id_opcode), .stall(stall),
                .reg_we(reg_we), .mem_we(mem_we), .mem_re(mem_re),
                .mem_reg_w(mem_reg_w), .alu_op(alu_op), .op_a_sel(op_a_sel),
                .op_b_sel(op_b_sel), .pc_sel(pc_sel), .jump(jump), .branch(branch));
                
    imm_generation imm_gen(.instr(if_id_instr), .imm(imm));
    
    alu a_l_u(.op_1(op_a), .op_2(op_b), 
                .result(alu_out), .alu_instr(alu_instr), .zero(zero));
                
    alu_cntrl a_l_u_cntrl(.alu_op(id_ex_alu_op), .func_3(id_ex_func_3), 
                .func_7(id_ex_func_7), .alu_instr(alu_instr));
                
    reg_file rf(.clk(clk), .rst(rst), .we(mem_wb_reg_we), .rs1(if_id_rs1), 
                .rs2(if_id_rs2), .rd(mem_wb_rd), .data_in(wb_data), 
                .reg_out_1(reg_out_1), .reg_out_2(reg_out_2));
                
    data_mem dm(.clk(clk), .rst(rst), .byte_en(ex_mem_func_3), 
                .mem_we(ex_mem_mem_we), .mem_re(ex_mem_mem_re), .d_mem_addr(ex_mem_result), 
                .data_in(ex_mem_reg_out_2), .data_out(d_mem_d_out));
    
    
// =====================================================================
// ======================== INSTANTIATION OF STAGES ====================
// =====================================================================

//    top single_cycle_module(.clk(clk), .rst(rst));
    
    if_id_stage IF_ID(.clk(clk), .rst(rst), .stall(stall),
                
                .instr(instr), .if_id_opcode(if_id_opcode), .if_id_rs1(if_id_rs1), 
                .if_id_rs2(if_id_rs2), .if_id_rd(if_id_rd), .if_id_func_3(if_id_func_3), 
                .if_id_func_7(if_id_func_7), .if_id_instr(if_id_instr), 
                
                .pc(pc), .if_id_pc(if_id_pc)
    );
    
    id_ex_stage ID_EX(.clk(clk), .rst(rst), .stall(stall),
                .reg_out_1(reg_out_1), .reg_out_2(reg_out_2), .if_id_rs1(if_id_rs1),
                .if_id_rs2(if_id_rs2), .if_id_rd(if_id_rd), 
                
                .id_ex_reg_out_1(id_ex_reg_out_1), .id_ex_reg_out_2(id_ex_reg_out_2), 
                .id_ex_rs1(id_ex_rs1), .id_ex_rs2(id_ex_rs2), .id_ex_rd(id_ex_rd), 
                
                .imm(imm), .id_ex_imm(id_ex_imm),
                
                .reg_we(reg_we), .mem_re(mem_re), .mem_we(mem_we), .mem_reg_w(mem_reg_w), 
                .alu_op(alu_op), .op_b_sel(op_b_sel), .op_a_sel(op_a_sel),
                .pc_sel(pc_sel), .jump(jump), .branch(branch),
                  
                .id_ex_reg_we(id_ex_reg_we), .id_ex_mem_we(id_ex_mem_we), .id_ex_mem_re(id_ex_mem_re), 
                .id_ex_mem_reg_w(id_ex_mem_reg_w), .id_ex_alu_op(id_ex_alu_op),
                .id_ex_op_b_sel(id_ex_op_b_sel), .id_ex_op_a_sel(id_ex_op_a_sel),
                .id_ex_pc_sel(id_ex_pc_sel), .id_ex_jump(id_ex_jump), 
                .id_ex_branch(id_ex_branch), 
                
                .if_id_func_3(if_id_func_3), .if_id_func_7(if_id_func_7),
                
                .id_ex_func_3(id_ex_func_3), .id_ex_func_7(id_ex_func_7),
                
                .if_id_pc(if_id_pc), .id_ex_pc(id_ex_pc)
    );
                
    ex_mem_stage EX_MEM(.clk(clk), .rst(rst), 
                
                .zero(zero), .result(alu_out),
                
                .ex_mem_zero(ex_mem_zero), .ex_mem_result(ex_mem_result), 
                
                .id_ex_rs1(id_ex_rs1), .id_ex_rs2(id_ex_rs2),
                .id_ex_rd(id_ex_rd), .id_ex_reg_out_1(id_ex_reg_out_1), 
                .id_ex_reg_out_2(forwarded_op_b),
                
                .ex_mem_rs1(ex_mem_rs1), .ex_mem_rs2(ex_mem_rs2),
                .ex_mem_rd(ex_mem_rd), .ex_mem_reg_out_1(ex_mem_reg_out_1),
                .ex_mem_reg_out_2(ex_mem_reg_out_2),
                
                .id_ex_reg_we(id_ex_reg_we), .id_ex_mem_we(id_ex_mem_we), 
                .id_ex_mem_re(id_ex_mem_re), .id_ex_mem_reg_w(id_ex_mem_reg_w), 
                .id_ex_pc_sel(id_ex_pc_sel), .id_ex_jump(id_ex_jump), 
                .id_ex_branch(id_ex_branch), .id_ex_func_3(id_ex_func_3),
                
                .ex_mem_reg_we(ex_mem_reg_we), .ex_mem_mem_we(ex_mem_mem_we), 
                .ex_mem_mem_re(ex_mem_mem_re), .ex_mem_mem_reg_w(ex_mem_mem_reg_w), 
                .ex_mem_pc_sel(ex_mem_pc_sel), .ex_mem_jump(ex_mem_jump), 
                .ex_mem_branch(ex_mem_branch), .ex_mem_func_3(ex_mem_func_3),
                
                .id_ex_pc(id_ex_pc), .ex_mem_pc(ex_mem_pc),
                
                .id_ex_imm(id_ex_imm), .ex_mem_imm(ex_mem_imm)
    );
                
    mem_wb_stage MEM_WB(.clk(clk), .rst(rst), 
                
                .ex_mem_reg_we(ex_mem_reg_we), .ex_mem_mem_reg_w(ex_mem_mem_reg_w), 
                .ex_mem_jump(ex_mem_jump), 
                
                .mem_wb_reg_we(mem_wb_reg_we), .mem_wb_mem_reg_w(mem_wb_mem_reg_w), 
                .mem_wb_jump(mem_wb_jump),
                
                .ex_mem_rs1(ex_mem_rs1), .ex_mem_rs2(ex_mem_rs2),
                .ex_mem_rd(ex_mem_rd), .ex_mem_reg_out_1(ex_mem_reg_out_1),
                
                .mem_wb_rs1(mem_wb_rs1), .mem_wb_rs2(mem_wb_rs2), 
                .mem_wb_rd(mem_wb_rd), .mem_wb_reg_out_1(mem_wb_reg_out_1),
                
                .ex_mem_result(ex_mem_result), .mem_wb_result(mem_wb_result),
                
                .d_mem_d_out(d_mem_d_out), .mem_wb_d_mem_d_out(mem_wb_d_mem_d_out),
                
                .ex_mem_pc(ex_mem_pc), .mem_wb_pc(mem_wb_pc),
                
                .ex_mem_imm(ex_mem_imm), .mem_wb_imm(mem_wb_imm)
    );
    
// ====================================================================================
// ======================== INSTANTIATION OF HANDLING DATA HAZARDS ====================
// ====================================================================================

    forwarding_unit FWD_U(
        .id_ex_rs1(id_ex_rs1), .id_ex_rs2(id_ex_rs2), .id_ex_rd(id_ex_rd),
        
        .ex_mem_rd(ex_mem_rd), .ex_mem_reg_we(ex_mem_reg_we), .ex_mem_mem_re(ex_mem_mem_re),
        
        .mem_wb_rd(mem_wb_rd), .mem_wb_reg_we(mem_wb_reg_we),
        
        .id_ex_mem_we(id_ex_mem_we),
        .ex_mem_rs2(ex_mem_rs2),
        
        .forward_op_a_sel(forward_op_a_sel), .forward_op_b_sel(forward_op_b_sel),
        .forward_store_data_sel(forward_store_data_sel) 
    );

    hazard_detection_unit HDU(
    .id_opcode(if_id_opcode), 
    .id_rs1(if_id_rs1), 
    .id_rs2(if_id_rs2), 
    
    .id_ex_opcode(7'b0), 
    .id_ex_rd(id_ex_rd), 
    .id_ex_mem_re(id_ex_mem_re), 
    
    .pc(pc), 
    
    .stall(stall),
    .stall_pc(stall_pc)
);
// ====================================================================================
    
    // Flags negative, zero, carry, overflow
    assign n = ex_mem_zero[3];
    assign z = ex_mem_zero[2];
    assign c = ex_mem_zero[1];
    assign v = ex_mem_zero[0];
    
    
    // instruction decode
    assign opcode = instr[6: 0];
    assign rs1 = instr[19: 15];
    assign rs2 = instr[24: 20];
    assign rd = instr[11: 7];
    
    // for alu operand b
    assign op_b = (id_ex_op_b_sel) ? id_ex_imm : forwarded_op_b;
    
    // forwarded operand b
    always_comb begin
        unique case (forward_op_b_sel)
            2'b00: forwarded_op_b = id_ex_reg_out_2;   // No forwarding
            2'b01: forwarded_op_b = d_mem_d_out;       // Forward from memory (load)
            2'b10: forwarded_op_b = ex_mem_result;     // Forward from EX/MEM ALU  
            2'b11: forwarded_op_b = wb_data;           // Forward from WB stage
        endcase
    end
    
    // for alu operand a
    always_comb begin
        unique case (id_ex_op_a_sel)
            2'b00: op_a = forwarded_op_a;
            2'b01: op_a = id_ex_pc; // for pc + imm
            2'b10: op_a = id_ex_pc; // for pc + imm
            2'b11: op_a = 0;
        endcase
    end
    
    // forwarded operand a
    always_comb begin
        unique case (forward_op_a_sel)
            2'b00: forwarded_op_a = id_ex_reg_out_1;   // No forwarding
            2'b01: forwarded_op_a = d_mem_d_out;       // Forward from memory (load)
            2'b10: forwarded_op_a = ex_mem_result;     // Forward from EX/MEM ALU
            2'b11: forwarded_op_a = wb_data;           // Forward from WB stage
        endcase
    end
    
    // for register file what to write
    always_comb begin
        if(mem_wb_jump)
            wb_data = mem_wb_pc + 4; 
        else begin
            if(mem_wb_mem_reg_w)
                wb_data = mem_wb_d_mem_d_out;  // Load instruction
            else
                wb_data = mem_wb_result;       // ALU result
        end
    end
    
    // for program counter what is next pc
    always_comb begin
            unique case (ex_mem_pc_sel)
                2'b00: begin
                    if (stall)
                         next_pc =  stall_pc;
                     else
                        next_pc =  pc + 4;
                end
                2'b01: next_pc = mem_wb_pc + mem_wb_imm;                        // jal and branch
                2'b10: next_pc = ex_mem_reg_out_1 + mem_wb_imm;                 // jalr
                2'b11: begin                                                    // branch
                    unique case (ex_mem_func_3)
                        3'b000: next_pc = (z)       ? ex_mem_pc + ex_mem_imm : pc + 4; // beq
                        3'b001: next_pc = (!z)      ? ex_mem_pc + ex_mem_imm : pc + 4; // bne
                        3'b100: next_pc = (n != v)  ? ex_mem_pc + ex_mem_imm : pc + 4; // blt
                        3'b101: next_pc = (n == v)  ? ex_mem_pc + ex_mem_imm : pc + 4; // bge
                        3'b110: next_pc = !c        ? ex_mem_pc + ex_mem_imm : pc + 4; // bltu
                        3'b111: next_pc = (c)       ? ex_mem_pc + ex_mem_imm : pc + 4; // bgeu
                        default: next_pc = ex_mem_pc + 4;
                    endcase
                end
            endcase
        end
endmodule
