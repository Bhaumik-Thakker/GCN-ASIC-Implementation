
module Combination_FSM #(
    parameter MAX_ADDRESS_WIDTH = 2,
    parameter NUM_OF_NODES = 6,			 
    parameter COO_NUM_OF_COLS = 6,
    parameter WEIGHT_COLS = 3,
    parameter FEATURE_ROWS = 6,
    parameter DOT_PROD_WIDTH = 16,			
    parameter COO_NUM_OF_ROWS = 2,			
    parameter COO_BW = $clog2(COO_NUM_OF_COLS)	
)(
  input logic clk,	// Clock
  input logic reset,	// Reset 
  input logic done_trans,
  input logic [$clog2(FEATURE_ROWS)-1:0] row_count,



  output logic enable_read_row_1,
  output logic enable_count,
  output logic wr_en,
  output logic write_enable, 
  output logic done_comb
);

  typedef enum logic [2:0] {
	DONE_TRANS,
	READ_ROW_1,
	WRITE_ROW_1,
	READ_ROW_2,
	WRITE_ROW_2,
	INCREMENT_COUNTER,
	DONE_COMB
  } state_t;

  state_t current_state, next_state;

  always_ff @(posedge clk or posedge reset) begin
    if (reset)
      current_state <= DONE_TRANS;
    else
      current_state <= next_state;
end

  always_comb begin
    case (current_state)

      DONE_TRANS: begin
		enable_count = 1'b0;
		wr_en = 1'b0;
		write_enable = 1'b0;
		done_comb = 1'b0;
		enable_read_row_1 = 1'b0;

		if (done_trans) begin 
			next_state = READ_ROW_1;
		end 
		else begin 
			next_state = DONE_TRANS;
		end 
        	

      end


      READ_ROW_1: begin
		enable_count = 1'b0;
		wr_en = 1'b0;
		write_enable = 1'b0;
		done_comb = 1'b0;
		enable_read_row_1 = 1'b1;


		next_state = WRITE_ROW_1;

      end

      WRITE_ROW_1: begin
		enable_count = 1'b0;
		wr_en = 1'b1;
		write_enable = 1'b0;
		done_comb = 1'b0;
		enable_read_row_1 = 1'b1;

		next_state = READ_ROW_2;
      end


      READ_ROW_2: begin
		enable_count = 1'b0;
		wr_en = 1'b0;
		write_enable = 1'b1;
		done_comb = 1'b0;
		enable_read_row_1 = 1'b0;

		next_state = WRITE_ROW_2;
      end

      WRITE_ROW_2: begin
		enable_count = 1'b0;
		wr_en = 1'b1;
		write_enable = 1'b1;
		done_comb = 1'b0;
		enable_read_row_1 = 1'b0;

		next_state = INCREMENT_COUNTER;
      end
      INCREMENT_COUNTER: begin
		enable_count = 1'b1;
		wr_en = 1'b0;
		write_enable = 1'b0;
		done_comb = 1'b0;
		enable_read_row_1 = 1'b0;

		if (row_count == 5) begin
			next_state = DONE_COMB;
		end
		else  begin
			next_state = READ_ROW_1;
		end
      end

      DONE_COMB: begin
		enable_count = 1'b0;
		wr_en = 1'b0;
		write_enable = 1'b0;
		done_comb = 1'b1;
		enable_read_row_1 = 1'b0;

		next_state = DONE_COMB;
      end

       default : begin
		enable_count = 1'b0;
		wr_en = 1'b0;
		write_enable = 1'b0;
		done_comb = 1'b0;
		enable_read_row_1 = 1'b0;

		next_state = DONE_TRANS;
	end

    endcase
  end

endmodule
