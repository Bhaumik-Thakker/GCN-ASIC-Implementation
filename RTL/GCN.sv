module GCN
  #(parameter FEATURE_COLS = 96,
    parameter WEIGHT_ROWS = 96,
    parameter FEATURE_ROWS = 6,
    parameter WEIGHT_COLS = 3,
    parameter FEATURE_WIDTH = 5,
    parameter WEIGHT_WIDTH = 5,
    parameter DOT_PROD_WIDTH = 16,
    parameter ADDRESS_WIDTH = 13,
    parameter COUNTER_WEIGHT_WIDTH = $clog2(WEIGHT_COLS),
    parameter COUNTER_FEATURE_WIDTH = $clog2(FEATURE_ROWS),
    parameter MAX_ADDRESS_WIDTH = 2,
    parameter NUM_OF_NODES = 6,
    parameter COO_NUM_OF_COLS = 6,
    parameter COO_NUM_OF_ROWS = 2,
    parameter COO_BW = $clog2(COO_NUM_OF_COLS))
(
    input logic clk,
    input logic reset,
    input logic start,
    input logic [WEIGHT_WIDTH-1:0] data_in [0:WEIGHT_ROWS-1],
    input logic [0:WEIGHT_COLS-1][1:0] coo_in , 

    output logic [ADDRESS_WIDTH-1:0] read_address,
    output logic enable_read,
    output logic [COO_BW-1:0] coo_address,
    output logic done,
    output logic [MAX_ADDRESS_WIDTH-1:0] max_addi_answer [0:FEATURE_ROWS-1]
);


    logic done_trans;
    logic [DOT_PROD_WIDTH-1:0] FM_WM_Row [0:WEIGHT_COLS-1];
    logic [2:0] read_row;
    logic [DOT_PROD_WIDTH - 1:0] row_temp  [0:WEIGHT_COLS-1];
    logic [DOT_PROD_WIDTH-1:0] fm_wm_adj_out [0:WEIGHT_COLS-1];
    logic done_comb;
    logic [2:0] read_row_adj;



Transformation_Block transform(

 .clk(clk),
 .reset(reset),
 .data_in(data_in),
 .start(start),

 .read_address(read_address),
 .done_trans(done_trans),
 .enable_read(enable_read),
 .read_row(read_row),
 .FM_WM_Row(FM_WM_Row)

);

    Combination_block       u_combination (
 .clk(clk),
 .reset(reset),
 .done_trans(done_trans),
 .read_row(read_row),
 .coo_in(coo_in),
 .FM_WM_Row(FM_WM_Row),
 .read_row_adj(read_row_adj),
 .fm_wm_adj_out(fm_wm_adj_out),
 .coo_address(coo_address),
 .done_comb(done_comb)
    );


    Max_Func u_max (
  .clk(clk),
  .rst(reset),
  .done_comb(done_comb),
  .fm_wm_adj_out(fm_wm_adj_out),                 
  .read_row_arg(read_row_adj),         
  .max_addi_answer(max_addi_answer),
  .done(done)
    );

endmodule
