module Vector_Multiplier #(

    parameter DOT_PROD_WIDTH = 16,
    parameter FEATURE_ROWS = 6,
    parameter WEIGHT_COLS = 3,
    parameter WEIGHT_ROWS = 6,
    parameter FEATURE_COLS = 96,    
    parameter WEIGHT_WIDTH = 5,
    parameter FEATURE_WIDTH = $clog2(FEATURE_ROWS)

)(

    input logic [WEIGHT_WIDTH-1:0] feature_row_in [0:WEIGHT_ROWS-1],
    input logic [WEIGHT_WIDTH-1:0] weight_col_out [0:WEIGHT_ROWS-1],
    
    output logic [DOT_PROD_WIDTH-1:0] fm_wm_in
);
    logic [DOT_PROD_WIDTH-1:0] temp_prod         [0:FEATURE_COLS-1];
    logic [DOT_PROD_WIDTH-1:0] inter_sum [0:7];


always_comb begin
        for (int i = 0; i < FEATURE_COLS; i++) begin
            temp_prod[i] = feature_row_in[i] * weight_col_out[i];
        end

        inter_sum[0] = temp_prod[0]  + temp_prod[1]  + temp_prod[2]  + temp_prod[3]  +
                                         temp_prod[4]  + temp_prod[5]  + temp_prod[6]  + temp_prod[7]  +
                                         temp_prod[8]  + temp_prod[9]  + temp_prod[10] + temp_prod[11];

        inter_sum[1] = temp_prod[12] + temp_prod[13] + temp_prod[14] + temp_prod[15] +
                                         temp_prod[16] + temp_prod[17] + temp_prod[18] + temp_prod[19] +
                                         temp_prod[20] + temp_prod[21] + temp_prod[22] + temp_prod[23];

        inter_sum[2] = temp_prod[24] + temp_prod[25] + temp_prod[26] + temp_prod[27] +
                                         temp_prod[28] + temp_prod[29] + temp_prod[30] + temp_prod[31] +
                                         temp_prod[32] + temp_prod[33] + temp_prod[34] + temp_prod[35];

        inter_sum[3] = temp_prod[36] + temp_prod[37] + temp_prod[38] + temp_prod[39] +
                                         temp_prod[40] + temp_prod[41] + temp_prod[42] + temp_prod[43] +
                                         temp_prod[44] + temp_prod[45] + temp_prod[46] + temp_prod[47];

        inter_sum[4] = temp_prod[48] + temp_prod[49] + temp_prod[50] + temp_prod[51] +
                                         temp_prod[52] + temp_prod[53] + temp_prod[54] + temp_prod[55] +
                                         temp_prod[56] + temp_prod[57] + temp_prod[58] + temp_prod[59];

        inter_sum[5] = temp_prod[60] + temp_prod[61] + temp_prod[62] + temp_prod[63] +
                                         temp_prod[64] + temp_prod[65] + temp_prod[66] + temp_prod[67] +
                                         temp_prod[68] + temp_prod[69] + temp_prod[70] + temp_prod[71];

        inter_sum[6] = temp_prod[72] + temp_prod[73] + temp_prod[74] + temp_prod[75] +
                                         temp_prod[76] + temp_prod[77] + temp_prod[78] + temp_prod[79] +
                                         temp_prod[80] + temp_prod[81] + temp_prod[82] + temp_prod[83];

        inter_sum[7] = temp_prod[84] + temp_prod[85] + temp_prod[86] + temp_prod[87] +
                                         temp_prod[88] + temp_prod[89] + temp_prod[90] + temp_prod[91] +
                                         temp_prod[92] + temp_prod[93] + temp_prod[94] + temp_prod[95];

        fm_wm_in = inter_sum[0] + inter_sum[1] + inter_sum[2] + inter_sum[3] +
                   inter_sum[4] + inter_sum[5] + inter_sum[6] + inter_sum[7];
   end
endmodule
