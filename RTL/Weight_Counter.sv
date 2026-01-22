module Weight_Counter #(                                        
    parameter WEIGHT_COLS = 3,
    parameter COUNTER_WEIGHT_WIDTH = $clog2(WEIGHT_COLS),
    parameter ADDRESS_WIDTH = 13,
    parameter WEIGHT_ADDRESS = 13'h0
)(
    input logic clk,
    input logic reset,
    input logic enable_weight_counter,

    output logic [4:0] weight_count
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            weight_count <= 0;
        end else if (enable_weight_counter) begin
            if (weight_count == 2) begin
            	weight_count <= 0;
            end else begin
                weight_count <= weight_count + 1;
            end
        end
    end

endmodule
