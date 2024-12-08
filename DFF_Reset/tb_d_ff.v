`timescale 1ns / 1ps

module tb_d_ff;

reg clk;
reg clk_enable; // 클럭을 활성화할지, 비활성화할지 결정하는 신호
reg sync_reset; // 동기 리셋 신호. 클럭 신호에 맞춰 동작함.
reg async_reset; // 비동기 리셋 신호. 클럭 신호와 무관하게 즉시 동작함.
reg async_reset_n; // 비동기 네거티브 리셋 신호. 1이 아닌 0일 때 동작함.

reg i_value; // D F/F의 입력

// clk gen (100 MHz)
// 주기가 10ns인 클럭 생성(5ns마다 클럭 신호를 반전 시킴)
always
    #5 clk = ~clk;

// initial begin ~ end: 시뮬레이션이 시작될 때 한 번만 실행됨. 회로의 초기 상태를 결정함.
initial begin
        $display("initialize value [%d]", $time);
        $display("No input clock [%d]", $time);
        clk                 <= 0;
        clk_enable              <= 0; // no input clk
        sync_reset              <= 0;
        async_reset             <= 0;
        async_reset_n   <= 1;

        i_value                 <= 1;
#50
        $display("Async Reset [%d]", $time);
        sync_reset              <= 1;
        async_reset             <= 1;
        async_reset_n   <= 0;

#10
        sync_reset              <= 0;
        async_reset             <= 0;
        async_reset_n   <= 1;
#10
        $display("Input clock [%d]", $time); // 70
        clk_enable              <= 1; // input clk
#10
        $display("Sync Reset [%d]", $time);
        sync_reset              <= 1;
#10
        sync_reset              <= 0;
#50
        $display("Finish! [%d]", $time);
$finish;
end

wire clk_for_dut = clk && clk_enable;

d_ff_test DUT(
    .clk(clk_for_dut),
    .sync_reset(sync_reset),
    .async_reset(async_reset),
    .async_reset_n(async_reset_n),

    .i_value(i_value),
    .o_value_sync_reset(),
    .o_value_async_reset(),
    .o_value_async_reset_n(),
    .o_value_mixed_reset(),
    .o_value_no_reset()
);

endmodule