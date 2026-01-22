
module argmax #(
  parameter ROWS = 6,
  parameter COLS = 3,
  parameter FEATURE_ROWS = 6,
  parameter MAX_ADDRESS_WIDTH = 2,  
  parameter DATA_WIDTH = 16 
)(
  input logic clk,
  input logic rst,
  input logic done_comb,
  input logic [DATA_WIDTH-1:0] fm_wm_adj_out [0:2],

  output logic [2:0]current_row,
  output logic [MAX_ADDRESS_WIDTH - 1:0] max_addi_answer [0:FEATURE_ROWS - 1],
  output logic done

);

logic [1:0] max_column_indices [0 : FEATURE_ROWS - 1];

  // Main process
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      current_row <= 0;
 

    end else if ( done_comb == 0) begin
		 current_row <= 0;



        end else if (done_comb) begin
                   
      current_row <= (current_row==5) ? 0 : current_row + 1;
      
      
      done <= (current_row == 5) ? 1 : 0;
       if(fm_wm_adj_out[0] > fm_wm_adj_out[1]) begin

              if(fm_wm_adj_out[0]> fm_wm_adj_out[2]) begin
                        max_column_indices[current_row] <= 0;
              end
                        else begin
                        max_column_indices[current_row] <= 2;
                        end
       end

                    else if(fm_wm_adj_out[1] > fm_wm_adj_out[2])begin 
                             max_column_indices[current_row] <= 1;
                    end
                             else begin
                                max_column_indices[current_row] <= 2;
                             end
      end
  end
assign max_addi_answer = max_column_indices;


endmodule
