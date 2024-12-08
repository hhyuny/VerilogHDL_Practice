`timescale 1ns / 1ps
module tb_counter_100;
reg clk, reset_n;
wire [6:0] o_cnt;
wire [6:0] o_cnt_always;

// clk gen
always
#5 clk = ~clk;

initial begin
// initialize value
    $display ("initialize value [%d]", $time);
    reset_n <= 1;
    clk <= 0;
// reset_n gen
    $display ("Start Reset! [%d]", $time);
    #100
    reset_n <= 0;
    #10
    reset_n <= 1;
    #10
    $display("Start! [%d]", $time);
    #2000
    $display("Finish! [%d]", $time);
    $finish;
end

// Call DUT
counter_100 u_counter_100(
        .clk (clk),
        .reset_n (reset_n),
        .o_cnt (o_cnt),
        .o_cnt_always (o_cnt_always)
);

endmodule