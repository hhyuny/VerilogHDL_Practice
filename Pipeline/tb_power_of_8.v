`timescale 1ns / 1ps
module tb_power_of_8;
        reg clk, reset_n;
        reg i_valid;
        reg [31:0] i_value;
        wire o_valid;
        wire [63:0] o_power_of_8;

// clk gen
always
        #5 clk = ~clk;

        integer i;
        integer fd;

initial begin
        $display("initialize value [%d]", $time);
        clk <= 0;
        reset_n <= 1;
        i_valid <= 0;
        i_value <= 0;
        fd <= $fopen("rtl_v.txt", "w"); // file open

// reset_n gen
        $display("Reset! [%d]", $time);
        # 100
        reset_n <= 0;
        # 10
        reset_n <= 1;
        # 10
        @ (posedge clk);
        $display("Start! [%d]", $time);
        for (i = 0; i < 100; i = i + 1) begin
                @ (negedge clk);
                i_value <= i;
                i_valid <= 1;
                @ (posedge clk);
        end
        @ (negedge clk);
        i_valid <= 0;
        i_value <= 0;
        #100
        $display("Finish! [%d]", $time);
        $fclose(fd);
        $finish;
end

// file write
        always @ (posedge clk) begin
                if (o_valid) begin
                        $fwrite(fd, "result = %0d\n", o_power_of_8);
                end
        end

// Call DUT
        power_of_8 u_power_of_8(
                .clk(clk),
                .reset_n(reset_n),
                .i_valid(i_valid),
                .i_value(i_value),
                .o_valid(o_valid),
                .o_power_of_8(o_power_of_8)
        );
endmodule
