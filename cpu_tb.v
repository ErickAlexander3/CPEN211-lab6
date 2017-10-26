module cpu_tb();
	//testbench do not take input or outputs
	//declare simulated input and outputs
	reg sim_clk, sim_reset, sim_s, sim_load, error;
	reg [15:0] sim_in,
	wire [15:0] sim_out; 
	wire sim_N, sim_V, sim_Z, sim_w;
	
	//instantiate cpu as DUT
	cpu DUT(.clk(sim_clk), .reset(sim_reset), .s(sim_s), .load(sim_load), .in(sim_in), //connect ports
		.out(sim_out), .N(sim_N), .V(sim_V), .Z(sim_Z), .w(sim_w));

	//Generate a rising edge every 10 seconds starting from second 5
        initial begin
          error = 1'b0;
          forever begin
            sim_clk = 1'b0; #5;
            sim_clk = 1'b1; #5;
          end
        end

	task ALU_TRY;

	//test to test N
	task ALU_TRY;
		input [15:0] inCode;
		input [2:0] expected_status;
		input [15:0] expected_out; 
		input in_reset;
		input in_s;
		input in_load;
		begin
			sim_in = inCode;
			sim_reset = in_reset;
			sim_load = in_load;

			if(sim_out == expected_out) begin
				$display("Output");
			end else begin
				error = 1'b1;
			end


			if({sim_N, sim_V, sim_Z} == expected_out) begin

			end else begin
				error = 1'b1;
			end

		end


	endtask

	initial begin
	
	//test cases for instruction M0V Rn, #<im8>
	TRYCPU(16'b, 3'b, 16'b, 1'b, 1'b, 1'b); //takes 16'b in, 3'b expect status, 16'b expect out, 1'b reset, 1'b load, 1'b s
	TRYCPU();
	TRYCPU();

	//test cases for instruction M0V Rd, Rm{,<sh_op>}
	TRYCPU();
	TRYCPU();
	TRYCPU();

	//test cases for instruction ADD Rd, Rn, Rm{,<sh_op>}
	TRYCPU();
	TRYCPU();
	TRYCPU();

	//test cases for instruction CMP Rd, Rn{,<sh_op>}
	TRYCPU();
	TRYCPU();
	TRYCPU();

	//test cases for instruction AND Rd, Rn, Rm{,<sh_op>}
	TRYCPU();
	TRYCPU();
	TRYCPU();

	//test cases for instruction MVN Rd, Rn{,<sh_op>}
	TRYCPU();
	TRYCPU();
	TRYCPU();	end
endmodule








	