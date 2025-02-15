`timescale 1ns / 1ps

module one_sec_gen

#(
        parameter P_COUNT_BIT = 30
)

(
        input clk,
        input reset,
        input i_run_en,
        input [P_COUNT_BIT-1:0] i_freq, // 2^30 = 1GHz
        output reg o_one_sec_tick
);

reg [P_COUNT_BIT-1:0] r_counter; // counting value
always @ (posedge clk) begin
        if (reset) begin
                r_counter <= {P_COUNT_BIT{1'b0}};
                o_one_sec_tick <= 1'b0;
        end else if (i_run_en) begin
                if (r_counter == i_freq - 1) begin
                        r_counter <= 0;
                        o_one_sec_tick <= 1'b1;
                end else begin
                        r_counter <= r_counter + 1'b1;
                        o_one_sec_tick <= 1'b0;
                end
        end else begin
                o_one_sec_tick <= 1'b0;
        end
end

endmodule