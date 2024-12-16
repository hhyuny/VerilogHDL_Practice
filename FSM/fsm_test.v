`timescale 1ns / 1ps
module fsm_test(
        input clk,
        input reset_n,
        input i_run,
        output reg o_done
);

// Define state
        localparam S_IDLE = 2'b00;
        localparam S_RUN  = 2'b01;
        localparam S_DONE = 2'b10;

// Type
        reg [1:0] c_state;
        reg [1:0] n_state;
        wire is_done = 1'b1;

// Step 1. Update state
        always @ (posedge clk or negedge reset_n) begin
                if (!reset_n) begin
                        c_state <= S_IDLE;
                end else begin
                        c_state <= n_state;
                end
        end

// Step 2. Compute n_state(How the next state occurs)
        always @ (*) begin
                n_state = S_IDLE; // To prevent Latch
                case (c_state)
                        S_IDLE: if (i_run) begin
                                n_state = S_RUN;
                        end
                        S_RUN: if (is_done)
                                        n_state = S_DONE;
                               else
                                        n_state = S_RUN;
                        S_DONE: n_state = S_IDLE;
                endcase
        end

// Step 3. Compute output
        always @ (*) begin
                o_done = 0; // To prevent Latch
                case (c_state)
                        S_DONE: o_done = 1;
                endcase
        end

endmodule
