module cpu_tb();
	//testbench do not take input or outputs
	//declare simulated input and outputs
	reg sim_clk, sim_reset, sim_s, sim_load;
	reg [15:0] sim_in;
	wire [15:0] sim_out; 
	wire sim_N, sim_V, sim_Z, sim_w;
	reg error;

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


	//MOV_TRY task <inCode><expected_status><expected_out><in_reset><in_s><in_load>
	task TRY_INPUT;
		input [15:0] inCode;
		begin
			sim_in = inCode;
   			sim_load = 1;
    			#10;
    			sim_load = 0;
    			sim_s = 1;
    			#10
    			sim_s = 0;

    			@(posedge sim_w); // wait for w to go high again
    			#10;
		end
	endtask


	//ALU_TRY task <inCode><expected_status><expected_out>
	task ALU_TRY;
		input [15:0] inCode;
		input [2:0] expected_status;
		input [15:0] expected_out; 
		begin
			sim_in = inCode;
			sim_load = 1;
    			#10;
    			sim_load = 0;
    			sim_s = 1;
    			#10
    			sim_s = 0;
    			@(posedge sim_w); // wait for w to go high again
    			#10;

			//check if output is as expected
			if(sim_out == expected_out) begin
				$display("Output %b is correct", sim_out);
			end else begin
				$display("Error, expects %b but actual output is %b", expected_out, sim_out);
				error = 1'b1;
			end

			//check if status is as expected
			if({sim_N, sim_V, sim_Z} == expected_status) begin
				$display("Status %b is correct", {sim_N, sim_V, sim_Z});
			end else begin
				$display("Error, expects %b but actual status is %b", expected_status, {sim_N, sim_V, sim_Z});
				error = 1'b1;
			end

		end
	endtask

	task TEST_VAL;
		input [15:0] check;
		input [15:0] expected_out;

		begin
			if(check == expected_out) begin
				$display("Values are equsl");
			end else begin
				$display("Error, expects %b but actual value is %b", expected_out, check);
				error = 1'b1;
			end
		end
	endtask

	initial begin //takes 16'b in, 3'b expect status, 16'b expect out
		sim_in = 16'b0;
		sim_reset = 1;
		sim_load = 0;
		sim_s = 0;
		#10;
		sim_reset = 0;
		#10;
		
		TRY_INPUT(16'b1101000000000111); //instruction 1, move 7 into R0
		TEST_VAL(cpu_tb.DUT.DP.REGFILE.R0, 16'h7);
	
		TRY_INPUT(16'b1101000100000010);//instruction 1, move 2 into R1
		TEST_VAL(cpu_tb.DUT.DP.REGFILE.R1, 16'h2);
		
		TRY_INPUT (16'b1010000101001000); //instruction 3, 2*R0 add R1, store in R2 is 16
		TEST_VAL(cpu_tb.DUT.DP.REGFILE.R2, 16'h10);


	/*
		//need to implement values
		MOV_TRY (16'b1101000000000111, 3'b000, 16'h7, 1'b0, 1'b0, 1'b1); //instruction 1, move 127 into R3
		MOV_TRY (16'b1101000100000010, 3'b000, 16'h2, 1'b0, 1'b0, 1'b1);//instruction 1, move 16 into R4
		ALU_TRY (16'b1010000101001000, 3'b000, 16'h10, 1'b0, 1'b1, 1'b1);//instruction 3, 2*R4 add R3 is 159 is over what 8 bit can hold, should have overflown, store in R5
	
		MOV_TRY (16'b1101000000000111, 3'b000, 16'h7, 1'b0, 1'b0, 1'b1); //instruction 2, move 13 shifted left into R6 = 26
		MOV_TRY (16'b1101000100000010, 3'b000, 16'h2, 1'b0, 1'b0, 1'b1); //instruction 2 move 2 shifted right into R7 = 1
		ALU_TRY (16'b1010000101001000, 3'b000, 16'h10, 1'b0, 1'b1, 1'b1);//instruction 4, R3 subtracted by R4 is 111, store in R8
	
		MOV_TRY (16'b1101000000000111, 3'b000, 16'h7, 1'b0, 1'b0, 1'b1); //instruction 2 move 9 non shifted into R0
		MOV_TRY (16'b1101000100000010, 3'b000, 16'h2, 1'b0, 1'b0, 1'b1); //instruction 2 move 42 MSB right shift into R1
	
		ALU_TRY (16'b1010000101001000, 3'b000, 16'h10, 1'b0, 1'b1, 1'b1);//instruction 4 R4 subtracted in R3 stored in R5 is negative
		ALU_TRY (16'b1010000101001000, 3'b000, 16'h10, 1'b0, 1'b1, 1'b1);//instruction 3 R7 add R5 is still negative store in R2
	
		ALU_TRY (16'b1010000101001000, 3'b000, 16'h10, 1'b0, 1'b1, 1'b1);//instruction 4 R0(+) subtracted by R7(-) is positive store in R3
		ALU_TRY (16'b1010000101001000, 3'b000, 16'h10, 1'b0, 1'b1, 1'b1);//instruction 4 R7 subtracted by R7 is 0, store in R5
		ALU_TRY (16'b1010000101001000, 3'b000, 16'h10, 1'b0, 1'b1, 1'b1);//instruction 5 R5 anded with R1 is still 0, store in R4
		ALU_TRY (16'b1010000101001000, 3'b000, 16'h10, 1'b0, 1'b1, 1'b1);//instruction 5 R7 anded with  R3 is positive, store in R6
		ALU_TRY (16'b1010000101001000, 3'b000, 16'h10, 1'b0, 1'b1, 1'b1);//instruction 5, and negative values
		ALU_TRY (16'b1010000101001000, 3'b000, 16'h10, 1'b0, 1'b1, 1'b1);//instruction 6, not R1 which is positive
		ALU_TRY (16'b1010000101001000, 3'b000, 16'h10, 1'b0, 1'b1, 1'b1);//instruction 6, not R4 which is 0
		ALU_TRY (16'b1010000101001000, 3'b000, 16'h10, 1'b0, 1'b1, 1'b1);//instruction 6, not R2 which is negative
	*/
		if (!error) $display("All tests passed");
		$stop;		end
endmodule
	