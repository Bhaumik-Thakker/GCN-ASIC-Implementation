module Feature_Counter #(
    parameter FEATURE_ROWS = 6,
    parameter WEIGHT_COLS = 3,
    parameter COUNTER_FEATURE_WIDTH = $clog2(FEATURE_ROWS),
    parameter ADDRESS_WIDTH = 13,
    parameter COUNTER_WEIGHT_WIDTH = $clog2(WEIGHT_COLS)

)(
    input logic clk,
    input logic reset,
    //input logic enable,
    input logic enable_feature_counter,
    input logic enable_write_fm_wm_prod,
    input logic enable_read,
    input logic read_feature_or_weight,
    input logic [4:0] weight_count,
    input logic enable_scratch_pad,
 
    output logic [4:0] feature_count,
    output logic [ADDRESS_WIDTH-1:0] read_address
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            feature_count <= 0;
        end 
        else if (enable_feature_counter && enable_write_fm_wm_prod && read_feature_or_weight) begin
            if (feature_count == 5) begin
            	feature_count <= 0;
            end 
            else begin
                feature_count <= feature_count + 1;
            end
        end
   end

always_comb begin
    if (enable_read && read_feature_or_weight) begin
        read_address = feature_count + 512; 
    end else if (enable_read && enable_scratch_pad) begin
            read_address = weight_count;
        end
end


endmodule
