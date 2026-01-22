
module coo_in #(
    parameter FEATURE_ROWS = 6,
    parameter WEIGHT_COLS = 3,
    parameter DOT_PROD_WIDTH = 16,
    parameter COO_NUM_OF_COLS = 6,
    parameter WEIGHT_WIDTH = $clog2(WEIGHT_COLS),
    parameter COO_BW = $clog2(COO_NUM_OF_COLS),
    parameter FEATURE_WIDTH = $clog2(FEATURE_ROWS)
)(
    //input logic clk,
    input logic enable_read_row_1,

    input logic write_enable,
    input logic [1:0][2:0] coo_in,
    input logic [DOT_PROD_WIDTH-1:0] FM_WM_Row [0:WEIGHT_COLS-1],
    //input logic [FEATURE_WIDTH-1:0] row_count,
    output logic [COO_BW-1:0] write_row,
    output logic [FEATURE_WIDTH-1:0] read_row,
    output logic [DOT_PROD_WIDTH-1:0] fm_wm_adj_row_in [0:WEIGHT_COLS-1]
);
 // reg [COO_BW-1:0] row_idx_1;
 // reg [COO_BW-1:0] row_idx_2;

    
    always_comb  begin

       /* if (reset) begin
     		row_idx_1 = 0;
      		row_idx_2 = 0;

	end else if (enable_read_coo_in) begin
      		row_idx_1 = coo_in[0];
      		row_idx_2 = coo_in[1];*/

        read_row = (enable_read_row_1) ? coo_in[0] - 1 : coo_in[1] - 1;
        write_row = (write_enable) ? coo_in[0] - 1 : coo_in[1] - 1;

  /*      end else if (enable_read_row_1) begin
                read_row = row_idx_1-1;   
		//fm_wm_adj_row_in=FM_WM_Row;
		write_row=row_idx_2-1;

        end else if (enable_read_row_2) begin
                read_row = row_idx_2-1;   
		//fm_wm_adj_row_in=FM_WM_Row;
		write_row=row_idx_1-1;
end*/

    for (int i = 0; i < 3; i++) begin
                fm_wm_adj_row_in[i] = FM_WM_Row[i];
    end                

end

endmodule
