
module Max_Func #(
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

  output logic [2:0]read_row_arg,
  output logic [MAX_ADDRESS_WIDTH - 1:0] max_addi_answer [0:FEATURE_ROWS - 1],
  output logic done

);

logic [1:0] max_column_indices [0 : FEATURE_ROWS - 1];

  // Main process
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      read_row_arg <= 0;

    end else if ( done_comb == 0) begin
		 read_row_arg <= 0;

        end else if (done_comb) begin
              if (read_row_arg==5) begin
		read_row_arg <= 0;
		done<=1'b1;
		end else begin
   			read_row_arg <= read_row_arg + 1;
			done <= 1'b0;
		end 

       if(fm_wm_adj_out[0] > fm_wm_adj_out[1]) begin

              if(fm_wm_adj_out[0]> fm_wm_adj_out[2]) begin
                        max_column_indices[read_row_arg] <= 0;
              end
                        else begin
                        max_column_indices[read_row_arg] <= 2;
                        end
       end

                    else if(fm_wm_adj_out[1] > fm_wm_adj_out[2])begin 
                             max_column_indices[read_row_arg] <= 1;
                    end
                             else begin
                                max_column_indices[read_row_arg] <= 2;
                             end
      end
  end
  always_comb begin
	 for (int k = 0; k < 6; k = k+1) begin
 	 max_addi_answer[k] = max_column_indices[k];
	 end
      end

endmodule
