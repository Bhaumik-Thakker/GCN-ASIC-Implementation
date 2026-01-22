module Transformation_Block #(
    parameter FEATURE_COLS = 96,
    parameter WEIGHT_ROWS = 96,
    parameter FEATURE_ROWS = 6,
    parameter WEIGHT_COLS = 3,
    parameter DOT_PROD_WIDTH = 16,
    parameter ADDRESS_WIDTH = 13,
    parameter FEATURE_WIDTH = 5,
    parameter WEIGHT_WIDTH = 5,
    parameter COUNTER_FEATURE_WIDTH = $clog2(FEATURE_ROWS),
    parameter COUNTER_WEIGHT_WIDTH = $clog2(WEIGHT_COLS),
    parameter FEATURE_ADDRESS = 13'h200,
    parameter WEIGHT_ADDRESS = 13'h0
)(
    input logic clk,
    input logic reset,
    input logic start,

    // Data Inputs
    input logic [WEIGHT_WIDTH-1:0] data_in [0:WEIGHT_ROWS-1],

    input logic [2:0] read_row,

    // Outputs
    output logic done_trans,
    output logic enable_read,
    output logic [ADDRESS_WIDTH-1:0] read_address,
    output logic [DOT_PROD_WIDTH-1:0] FM_WM_Row [0:WEIGHT_COLS-1]
);

    // Internal Signals
    logic enable_scratch_pad, enable_feature_counter, enable_weight_counter;
    //logic [WEIGHT_WIDTH-1:0] weight_row [0:WEIGHT_ROWS-1],
    //logic enable_read;
    logic enable_write_fm_wm_prod, read_feature_or_weight;
    logic [FEATURE_WIDTH-1:0] feature_count;
    logic [WEIGHT_WIDTH-1:0] weight_count;
    logic [DOT_PROD_WIDTH-1:0] fm_wm_in;
    //logic [FEATURE_WIDTH-1:0] feature_row_in [0:FEATURE_ROWS-1];
    logic [WEIGHT_WIDTH-1:0] weight_col_out [0:WEIGHT_ROWS-1];


    // **Feature Counter**
    Feature_Counter feature_counter_inst (
        .clk(clk),
        .reset(reset),
        //.enable(enable),
        .enable_feature_counter(enable_feature_counter),
        .enable_write_fm_wm_prod(enable_write_fm_wm_prod),
        .enable_scratch_pad(enable_scratch_pad),
        .enable_read(enable_read),
        .read_feature_or_weight(read_feature_or_weight),
        .weight_count(weight_count),
        .feature_count(feature_count),
        .read_address(read_address)
    );

    // **Weight Counter**
    Weight_Counter #(
        .WEIGHT_COLS(WEIGHT_COLS),
        .COUNTER_WEIGHT_WIDTH(COUNTER_WEIGHT_WIDTH),
        .ADDRESS_WIDTH(ADDRESS_WIDTH),
        .WEIGHT_ADDRESS(WEIGHT_ADDRESS)
    ) weight_counter_inst (
        .clk(clk),
        .reset(reset),
        //.enable(enable),
        .enable_weight_counter(enable_weight_counter),
        .weight_count(weight_count)
    );

    // **Vector Multiplier**
    Vector_Multiplier #(
        .DOT_PROD_WIDTH(DOT_PROD_WIDTH),
        .FEATURE_ROWS(FEATURE_ROWS),
        .WEIGHT_ROWS(WEIGHT_ROWS),
        .WEIGHT_COLS(WEIGHT_COLS),
        .FEATURE_COLS(FEATURE_COLS),
        .WEIGHT_WIDTH(WEIGHT_WIDTH),
        .FEATURE_WIDTH(FEATURE_WIDTH)
    ) vector_multiplier_inst (
        .feature_row_in(data_in),
        .weight_col_out(weight_col_out),
        .fm_wm_in(fm_wm_in)
    );

    // **Matrix Memory for Feature & Weight**
    Matrix_FM_WM_Memory #(
        .FEATURE_ROWS(FEATURE_ROWS),
        .WEIGHT_COLS(WEIGHT_COLS),
        .DOT_PROD_WIDTH(DOT_PROD_WIDTH),
        .ADDRESS_WIDTH(ADDRESS_WIDTH),
        .WEIGHT_WIDTH(WEIGHT_WIDTH),
        .FEATURE_WIDTH(FEATURE_WIDTH)
    ) matrix_mem_inst (
        .clk(clk),
        .rst(reset),
        .write_row(feature_count),
        .write_col(weight_count),
        .read_row(read_row),
        .wr_en(enable_write_fm_wm_prod),
        .fm_wm_in(fm_wm_in),
        .fm_wm_row_out(FM_WM_Row)
    );

    // **Scratch Pad**
    Scratch_Pad #(
        .WEIGHT_ROWS(WEIGHT_ROWS),
        .WEIGHT_WIDTH(WEIGHT_WIDTH)
    ) scratch_pad_inst (
        .clk(clk),
        .reset(reset),
        .write_enable(enable_scratch_pad),
        .weight_col_in(data_in),
        .weight_col_out(weight_col_out)
    );

    // **FSM - Transformation Control**
    Transformation_FSM #(
        .FEATURE_ROWS(FEATURE_ROWS),
        .WEIGHT_COLS(WEIGHT_COLS),
        .COUNTER_WEIGHT_WIDTH(WEIGHT_WIDTH),
        .COUNTER_FEATURE_WIDTH(FEATURE_WIDTH)
    ) fsm_inst (
        .clk(clk),
        .reset(reset),
        .weight_count(weight_count),
        .feature_count(feature_count),
        .start(start),
        .enable_write_fm_wm_prod(enable_write_fm_wm_prod),
        .enable_read(enable_read),
        //.enable_write(enable_write),
        .enable_scratch_pad(enable_scratch_pad),
        .enable_weight_counter(enable_weight_counter),
        .enable_feature_counter(enable_feature_counter),
        .read_feature_or_weight(read_feature_or_weight),
        .done(done_trans)
    );

endmodule
