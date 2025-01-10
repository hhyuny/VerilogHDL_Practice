`timescale 1ns / 1ps

module watch_top

#(
        parameter P_COUNT_BIT = 30,
        parameter P_SEC_BIT = 6,
        parameter P_MIN_BIT = 6,
        parameter P_HOUR_BIT = 5
)

(
        input clk,
        input reset,
        input i_run_en,
        input [P_COUNT_BIT-1:0] i_freq, // input frequency. 2^30 = 1GHz.
        output [P_SEC_BIT-1:0] o_sec, // 2^6 = 64
        output [P_MIN_BIT-1:0] o_min, // 2^6 64
        output [P_HOUR_BIT-1:0] o_hour // 2^5 = 32
);

wire w_one_sec_tick;
wire w_one_min_tick;
wire w_one_hour_tick;


// Call one_sec_gen
one_sec_gen
#(
        .P_COUNT_BIT (P_COUNT_BIT)
) u_one_sec_gen (
        .clk (clk),
        .reset (reset),
        .i_run_en (i_run_en),
        .i_freq (i_freq),
        .o_one_sec_tick (w_one_sec_tick)
);

// sec counter
tick_gen
#(
        .P_DELAY_OUT (2), // 2 cycle delay
        .P_COUNT_BIT (P_SEC_BIT),
        .P_INPUT_CNT (60) // 60 sec
) u_tick_gen_sec(
        .clk (clk),
        .reset (reset),
        .i_run_en (i_run_en),
        .i_tick (w_one_sec_tick),
        .o_tick_gen (w_one_min_tick),
        .o_cnt_val (o_sec)
);

// min counter
tick_gen
#(
        .P_DELAY_OUT (1), // 1 cycle delay
        .P_COUNT_BIT (P_MIN_BIT),
        .P_INPUT_CNT (60) // 60 min

) u_tick_gen_min(
        .clk (clk),
        .reset (reset),
        .i_run_en (i_run_en),
        .i_tick (w_one_min_tick),
        .o_tick_gen (w_one_hour_tick),
        .o_cnt_val (o_min)
);

// hour counter
tick_gen
#(
        .P_DELAY_OUT (0), // no delay
        .P_COUNT_BIT (P_HOUR_BIT),
        .P_INPUT_CNT (24) // 24 hour
) u_tick_gen_hour(
        .clk (clk),
        .reset (reset),
        .i_run_en (i_run_en),
        .i_tick (w_one_hour_tick),
        .o_tick_gen (),
        .o_cnt_val (o_hour)

);

endmodule