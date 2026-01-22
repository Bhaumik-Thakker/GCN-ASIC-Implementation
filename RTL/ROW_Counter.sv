module ROW_Counter #(
    parameter MAX_ADDRESS_WIDTH = 2,
    parameter FEATURE_ROWS = 6,
    parameter NUM_OF_NODES = 6,			 
    parameter COO_NUM_OF_COLS = 6,
    parameter WEIGHT_COLS = 3,
    parameter DOT_PROD_WIDTH = 16,			
    parameter COO_NUM_OF_ROWS = 2,			
    parameter COO_BW = $clog2(COO_NUM_OF_COLS)
)(
    input logic clk,	// Clock
    input logic reset,	// Reset 
    input logic enable_count,
    //input logic enable_read_coo_in,


    output logic [$clog2(FEATURE_ROWS)-1:0] row_count,
    output logic [COO_BW - 1:0] coo_address // The column of the COO Matrix 
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            row_count <= 0;
        end else if (enable_count) begin
            if (row_count == 5) begin
                row_count <= 0;
            end else begin
                row_count <= row_count + 1;
            end
        end
    end

    assign coo_address = row_count;


endmodule
