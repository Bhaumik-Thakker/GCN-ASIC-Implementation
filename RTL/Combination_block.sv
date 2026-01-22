module Combination_block #(
    parameter MAX_ADDRESS_WIDTH = 2,
    parameter FEATURE_ROWS = 6,
    parameter NUM_OF_NODES = 6,			 
    parameter COO_NUM_OF_COLS = 6,
    parameter WEIGHT_COLS = 3,
    parameter DOT_PROD_WIDTH = 16,			
    parameter COO_NUM_OF_ROWS = 2,
    parameter FEATURE_WIDTH = $clog2(FEATURE_ROWS),
    parameter WEIGHT_WIDTH = $clog2(WEIGHT_COLS),		
    parameter COO_BW = $clog2(COO_NUM_OF_COLS)
)(
    input logic clk,
    input logic reset,
    input logic done_trans,
    input logic [0:WEIGHT_COLS-1][1:0] coo_in, 
    input logic [DOT_PROD_WIDTH-1:0] FM_WM_Row [0:WEIGHT_COLS-1],
    input logic [FEATURE_WIDTH - 1:0] read_row_adj,


    output logic [2:0] read_row,
    output logic [DOT_PROD_WIDTH - 1:0] fm_wm_adj_out [0:WEIGHT_COLS-1],
    output logic [COO_BW - 1:0] coo_address,
    output logic done_comb
    
);

    // Internal wires
    logic enable_count,write_enable,enable_read_row_1;
    logic wr_en;
    logic [$clog2(FEATURE_ROWS)-1:0] row_count;
    logic [$clog2(FEATURE_ROWS)-1:0] write_row;
    logic [DOT_PROD_WIDTH-1:0] fm_wm_adj_row_in [0:WEIGHT_COLS-1];


    //--------------------------
    // FSM
    //--------------------------
    Combination_FSM fsm_inst (
        .clk(clk),
        .reset(reset),
        .done_trans(done_trans),
	.enable_read_row_1(enable_read_row_1),
        .row_count(row_count),
        .wr_en(wr_en),
        .enable_count(enable_count),
        .write_enable(write_enable),
        .done_comb(done_comb)
    );

    //--------------------------
    // ROW Counter
    //--------------------------
    ROW_Counter counter_inst (
        .clk(clk),
        .reset(reset),
        .enable_count(enable_count),
        .row_count(row_count),
        .coo_address(coo_address)
    );

    //--------------------------
    // COO Accumulation
    //--------------------------
    coo_in  coo_accum_inst (
        //.reset(reset),
        .coo_in(coo_in),
	.enable_read_row_1(enable_read_row_1),
        .FM_WM_Row(FM_WM_Row),
        .write_enable(write_enable),
        .write_row(write_row),
        .read_row(read_row),
        .fm_wm_adj_row_in(fm_wm_adj_row_in)
    );

    //--------------------------
    // Memory to store final result using proper instantiation
    //--------------------------
    Matrix_FM_WM_ADJ_Memory adj_mem_inst (
        .clk(clk),
        .rst(reset),
        .write_row(write_row), 
        .read_row(read_row_adj),
        .wr_en(wr_en),
        .fm_wm_adj_row_in(fm_wm_adj_row_in),
        .fm_wm_adj_out(fm_wm_adj_out)
    );

endmodule
