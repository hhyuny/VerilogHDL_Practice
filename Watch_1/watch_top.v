`timescale 1ns / 1ps

module watch_top

// parameter
#(
        parameter P_COUNT_BIT = 30, // 2^30 = 1GHz
        parameter P_MAX_SEC_BIT = 6, // 2^6 = 64 (60 seconds)
        parameter P_MAX_MIN_BIT = 6, // 2^6 = 64 (60 minutes)
        parameter P_MAX_HOUR_BIT = 5 // 2^5 = 32 (24 hours)
)

// input, output
(
        input clk,
        input reset,
        input i_run_en,
        input [P_COUNT_BIT-1:0] i_freq,
        output reg [P_MAX_SEC_BIT-1:0] o_sec,
        output reg [P_MAX_MIN_BIT-1:0] o_min,
        output reg [P_MAX_HOUR_BIT-1:0] o_hour
);

// Call one_sec_gen
wire w_one_sec_tick;
one_sec_gen
#(
        .P_COUNT_BIT (P_COUNT_BIT)
) u_one_sec_gen(
        .clk (clk),
        .reset (reset),
        .i_run_en (i_run_en),
        .i_freq (i_freq),
        .o_one_sec_tick (w_one_sec_tick)
);

//// sec/min/hour counter ////
wire max_sec = o_sec == 60 - 1; // 59 seconds
wire max_min = o_min == 60 - 1; // 59 minutes
wire max_hour = o_hour == 24 - 1; // 23 hours

// sec ounter
always @ (posedge clk) begin
        if (reset) begin
                o_sec <= 0;
        end else if (w_one_sec_tick) begin
                if (max_sec) begin
                        o_sec <= 0;
                end else begin
                        o_sec <= o_sec + 1'b1;
                end
        end
end

// min counter
reg [5:0] r_sec_in_min_cnt;
always @ (posedge clk) begin
        if (reset) begin
                o_min <= 0;
                r_sec_in_min_cnt <= 0;
        end else if (w_one_sec_tick) begin
                if (max_min & max_sec) begin
                        o_min <= 0;
                        r_sec_in_min_cnt <= 0;
                end else if (r_sec_in_min_cnt == 60 - 1) begin
                        o_min <= o_min + 1'b1;
                        r_sec_in_min_cnt <= 0;
                end else begin
                        r_sec_in_min_cnt <= r_sec_in_min_cnt + 1'b1;
                end
        end
end

// hour counter
reg [11:0] r_sec_in_hour_cnt;
always @ (posedge clk) begin
        if (reset) begin
                o_hour <= 0;
                r_sec_in_hour_cnt <= 0;
        end else if (w_one_sec_tick) begin
                if (max_hour & max_min & max_sec) begin
                        o_hour <= 0;
                        r_sec_in_hour_cnt <= 0;
                end else if (r_sec_in_hour_cnt == 3600 - 1) begin
                        o_hour <= o_hour + 1'b1;
                        r_sec_in_hour_cnt <= 0;
                end else begin
                        r_sec_in_hour_cnt <= r_sec_in_hour_cnt + 1'b1;
                end
        end
end

endmodule