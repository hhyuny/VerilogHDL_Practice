`timescale 1ns / 1ps
module fsm_counter_test(
	input				clk,
	input				reset_n,
	input				i_run,
	input 			[6:0] i_num_cnt, // 2^7 = 128
	output 			o_idle,
	output 			o_running,
	output 			reg o_done
);

// Define Three States (Using localparam)
localparam S_IDLE 	= 2'b00;
localparam S_RUN 	= 2'b01;
localparam S_DONE 	= 2'b10;

// Type
reg [1:0] c_state; // Current State (F/F)
reg [1:0] n_state; // Next State

// wire
wire is_done;

// Step 1. Update State.
always @ (posedge clk or negedge reset_n) begin
	if (!reset_n) begin
		c_state <= S_IDLE;
	end else begin
		c_state <= n_state;
	end
end

// Step 2. Compute n_state.
always @ (*) begin
	n_state = S_IDLE; // To prevent Latch.
	case (c_state)
	S_IDLE: if (i_run)
			n_state = S_RUN;
	S_RUN: if (i_done)
			n_state = S_DONE;
		  else
			n_state = S_RUN;
	S_DONE: n_state = S_IDLE;
	endcase
end

// Step 3. Compute output.
always @ (*) begin
	o_done = 0; // To prevent Latch.
	case (c_state)
	S_DONE: o_done = 1;
	endcase
end

// Added to communicate with control signals.
assign o_idle = (c_state == S_IDLE);
assign o_running = (c_state == S_RUN);

// Added code (Counter)

// Step 4. Registering (Capturing) number of Count
reg [6:0] num_cnt;
always @ (posedge clk or negedge reset_n) begin
	if (!reset_n) begin
		num_cnt <= 0;
	end else if (i_run) begin
		num_cnt <= i_num_cnt;
	end else if (o_done) begin
		num_cnt <= 0;
	end else if (o_done) begin
		num_cnt <= 0;
	end
end

// Step 5. Core(Counter)
reg [6:0] cnt_always;
assign is_done = o_running && (cnt_always == num_cnt -1);

always @ (posedge clk or negedge reset_n) begin
	if (!reset_n) begin
		cnt_always <= 0;
	end else if (is_done) begin
		cnt_always <= 0;
	end else if (o_running) begin
		cnt_always <= cnt_always + 1;
	end
end

endmodule