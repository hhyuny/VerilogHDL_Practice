`timescale 1ns / 1ps
module tb_watch_top;

// parameter list
localparam P_COUNT_BIT = 30; // 2^30 = 1GHz
localparam P_MAX_SEC_BIT = 6; // 2^6 = 64
localparam P_MAX_MIN_BIT = 6; // 2^6 = 64
localparam P_MAX_HOUR_BIT = 5; // 2^5 = 32

// port list
reg clk, reset, i_run_en;
reg [P_COUNT_BIT-1:0] i_freq;
wire [P_MAX_SEC_BIT-1:0] o_sec;
wire [P_MAX_MIN_BIT-1:0] o_min;
wire [P_MAX_HOUR_BIT-1:0] o_hour;


// clk gen
always
        #5 clk = ~clk;

// Main
initial begin
        // Initialize value
        i_freq <= 10; // 1 second per 10 cycles
        assert(i_freq <= 1000 * 1000 * 1000); // less than 1GHz

        $display("Initialize value [%d]", $time);
        clk <= 0;
        reset <= 0;
        i_run_en <= 0;

        // start reset
        $display("Reset [%d]", $time);
        #100
        reset <= 1;
        #10
        reset <= 0;
        i_run_en <= 1;
        #10
        @ (posedge clk);

        $display("Start [%d]", $time);

        #10000000 // 3600 * 24 * 100 = 8,640,000

        $display("Finish [%d]", $time);
        i_run_en <= 0;

        $finish;
end


//// Call DUT
watch_top
#(
        .P_COUNT_BIT (P_COUNT_BIT),
        .P_MAX_SEC_BIT (P_MAX_SEC_BIT),
        .P_MAX_MIN_BIT (P_MAX_MIN_BIT),
        .P_MAX_HOUR_BIT (P_MAX_HOUR_BIT)
) u_watch_top(
        .clk (clk),
        .reset (reset),
        .i_run_en (i_run_en),
        .i_freq (i_freq),
        .o_sec (o_sec),
        .o_min (o_min),
        .o_hour (o_hour)
);

endmodule