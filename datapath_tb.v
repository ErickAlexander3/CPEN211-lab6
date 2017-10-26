//define the registers
`define R0 3'b000
`define R1 3'b001
`define R2 3'b010
`define R3 3'b011
`define R4 3'b100
`define R5 3'b101
`define R6 3'b110
`define R7 3'b111

//define ALU operations
`define SUM 2'b00
`define SUB 2'b01
`define AND 2'b10
`define NOT 2'b11

//define shifter operations
`define UNCHANGED 2'b00
`define SHIFT_LEFT 2'b01
`define SHIFT_RIGHT_MSB_0 2'b10
`define SHIFT_RIGHT_MSB_COPY 2'b11

module datapath_tb();
	//testbench do not take inputs or outputs
	//declare simulated inputs and outputs
	reg sim_clk, sim_write, sim_asel, sim_bsel, sim_loada, sim_loadb, sim_loadc, sim_loads, error;
	reg [2:0] sim_readnum, sim_writenum;
	reg [1:0] sim_ALUop, sim_shift, sim_vsel;
	reg [15:0] sim_mdata, sim_sximm8, sim_sximm5;
	reg [7:0] sim_PC;
	wire [2:0] sim_status;
	wire [15:0] sim_datapath_out;  

	//instiate datapath as DUT
        //NOTE: CHANGE THIS TO SUPPORT NEW INPUTS
	datapath DP(.clk(sim_clk), .readnum(sim_readnum), .vsel(sim_vsel), .loada(sim_loada), .loadb(sim_loadb), .shift(sim_shift), .asel(sim_asel), .bsel(sim_bsel), .ALUop(sim_ALUop), .loadc(sim_loadc), .loads(sim_loads), .writenum(sim_writenum), .write(sim_write), .mdata(sim_mdata), .sximm8(sim_sximm8), .sximm5(sim_sximm5), .PC(sim_PC), .status(sim_status), .datapath_out(sim_datapath_out));

        //Generate a rising edge every 10 seconds starting from second 5
        initial begin
          error = 1'b0;
          forever begin
            sim_clk = 1'b0; #5;
            sim_clk = 1'b1; #5;
          end
        end

        //Task for MOV <register_address>, <value>
        task MOV;    
          input [2:0] register_address; //the address of the register
          input [15:0] value;  //value to write in the specified address
        begin
          $display("Setting the register at %b with the value %h", register_address, value);
          sim_sximm8 = value; //we want to read the sign extended 16 bit input
          sim_writenum = register_address;
          sim_readnum = register_address; //this is only done for testing and is not required for the task
          sim_vsel = 2'b10; //select the sximm8
          sim_write = 1'b1; //we want to write to the register
                       
	  #10; //wait 1 cycle

          //check if the register has the value saved in the address          
          if( DP.REGFILE.data_out !== value ) begin
            $display("ERROR ** the register has a value of %b, expected %b", DP.REGFILE.data_out, value);
            error = 1'b1;
          end
        end
        endtask

        //Task for ADD <register_address>, <a_input_address>, <b_input_address>, <shifting_operation>
        task OPERATION;
          input [2:0] register_address, a_input_address, b_input_address;
          input [1:0] alu_operation;
          input [1:0] shifting_operation;
          input [15:0] expected_result;
	  input [2:0] expected_status;
        begin
          //reading values from register and store in A and B respectively
          $display("Adding the values from %b and %b, with the shifting operation %b, and storing it in %b",
                    a_input_address, b_input_address, shifting_operation, register_address);
          
          //read from A and assign to loadA
	  sim_readnum = a_input_address;
	  sim_loada = 1'b1; //we want to store the value in A
	  sim_loadb = 1'b0; //we dont want to store the value in B

	  #10; //wait 1 cycle
          //read from B and assign to loadB
	  sim_readnum = b_input_address;
	  sim_loada = 1'b0; //we want to store the value in A
	  sim_loadb = 1'b1; //we dont want to store the value in B

	  #10; //wait 1 cycle
          sim_loadb = 1'b0; //stop loading into b
          //perform the shifting operation and the ADD operation, and store both the status and the result in loads and loadc respectively
          sim_shift = shifting_operation;	
	  sim_asel = 1'b0; //select loada
	  sim_bsel = 1'b0; //select loadb
	  sim_ALUop = alu_operation; //what we want to perform
	  sim_loads = 1'b1; //pass on value
	  sim_loadc = 1'b1; //pass on value

	  #10; //wait 1 cycle

	  //check if the resulting output is as expected
          if( expected_result == sim_datapath_out ) begin
            $display("The result was %b as expected", sim_datapath_out);
          end else begin
            $display("The result was %b, but the expected result was %b", sim_datapath_out, expected_result);
            error = 1'b1;
          end

	  //check if the resulting status is as expected
	  if( expected_status == sim_status) begin
	     $display("The status was %h as expected", sim_status);
	  end else begin //if result is not as expected, checkwhich bit is not correct
	     if (expected_status[2] != sim_status[2]) begin
		case(expected_status[2])
			0: $display("The result should not have overflown but indicates it is");
			1: $display("The result should have overflown but indicates it is not ");
			default: $display("error assigning status");
		endcase
	     end
	     if(expected_status[1] != sim_status[1]) begin
		case(expected_status[1])
			0: $display("The result should not be negative but indicates it is");
			1: $display("The result should be negative but indicates it is not ");
			default: $display("error assigning status");
		endcase
	     end
	     if(expected_status[0] != sim_status[0]) begin
		case(expected_status[0])
			0: $display("The result should not be 0 but indicates it is");
			1: $display("The result should be 0 but indicates it is not ");
			default: $display("error assigning status");
		endcase
	     end
	     error = 1'b1;
	   end
          
          //store the result in the given register
          sim_writenum = register_address;
          sim_readnum = register_address; //just to be able to read it for the test
          sim_vsel = 2'b00; //we want to store the result of loadc instead of datapath_in
          sim_write = 1'b1;

          #10; //wait 1 cycle
          //check if the register has the value saved in the address          
          if( DP.REGFILE.data_out !== sim_datapath_out ) begin
            $display("ERROR ** the register has a value of %b, expected %b", DP.REGFILE.data_out, sim_datapath_out);
            error = 1'b1;
          end
        end

        endtask 
	initial begin
                //try adding two values with shifting
                MOV(`R0, 16'h7); //7 into register R0
                MOV(`R1, 16'h2); //2 into register R1
                OPERATION(`R2, `R1, `R0, `SUM, `SHIFT_LEFT, 16'h10, 3'b000); //2 + E(7 shifted to the left) = 10 into register R2

 		//try adding two values without shifting
                MOV(`R3, 16'h42); //42 into register R3
                MOV(`R4, 16'h13); //13 into register R4
                OPERATION(`R5, `R4, `R3, `SUM,`UNCHANGED, 16'h55, 3'b000); //42 + 13 = 55 into register R5

                //try substracting previous results and save them in a previously used register
                OPERATION(`R0, `R5, `R2, `SUB,`UNCHANGED, 16'h45, 3'b000); //55 - 10 = 45 into register R0

                //and now try adding 5 to that result
                MOV(`R1, 16'h5);
                OPERATION(`R2, `R0, `R1, `SUM,`UNCHANGED, 16'h4A, 3'b000); //45 + 5 = 4A into register R2

		//test when result is negative
		OPERATION(`R6, `R0, `R0, `SUB, `SHIFT_LEFT, 16'hffbb, 3'b010); //(45 - 90) is negative

		//test when result is 0
		OPERATION(`R7, `R3, `R3, `SUB, `UNCHANGED, 16'h0, 3'b001); //(45 - 90) is negative

		//test when there is overflow
		MOV(`R7, 16'b1000000000000001);
		OPERATION(`R0, `R7, `R7, `SUM, `UNCHANGED, 16'b0000000000000010, 3'b100); //value can't be stored in 16 bits

                if(!error) $display("ALL TESTS PASSED");
		$stop; //break out
		
	end
endmodule

