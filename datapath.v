module datapath(clk, //clock controlling datapath               
                readnum, vsel, loada, loadb,  // register operand fetch stage               
                shift, asel, bsel, ALUop, loadc, loads, sximm5, // computation stage (sometimes called "execute")
                writenum, write, sximm8, mdata, PC, // set when "writing back" to register file               
                status, datapath_out // outputs
              );
   // Set all the inputs and outputs to be used in the datapath. Refer to the datapath figure in lab5 to
   // understand how each input works
   input clk, write, asel, bsel, loada, loadb, loadc, loads;
   input [2:0] readnum, writenum;
   input [1:0] ALUop, shift, vsel;
   input [15:0] mdata, sximm8, sximm5;
   input [7:0] PC;
   output [2:0] status;
   output [15:0] datapath_out;  

   //1) The register file contains the 8 register where you can store up to 8 16-bits values
   wire [15:0] reg_data_in;  //This will be obtained from the output of part 10 (defined later)
   wire [15:0] reg_data_out;
   Register_file register_block(clk, reg_data_in, write, writenum, readnum, reg_data_out);

   //2) The output of the register file is then used in either of the two load-enabled pipeline registers after it
   wire [15:0] pipeline_reg_A_out, pipeline_reg_B_out;
   Load_enabled_register #(16) pipeline_reg_A(clk, loada, reg_data_out, pipeline_reg_A_out);
   Load_enabled_register #(16) pipeline_reg_B(clk, loadb, reg_data_out, pipeline_reg_B_out);

   //3) Shift the output of the pipeline register B
   wire [15:0] pipeline_reg_B_out_shifted;
   shifter shift_reg_B(pipeline_reg_B_out, shift, pipeline_reg_B_out_shifted);

   //4) Create the source operand multiplexers for the output of pipeline register A and pipeline register B (shifted)
   wire [15:0] source_operand_A_out, source_operand_B_out;
   MUX_2in_binary source_operand_A(16'b0, pipeline_reg_A_out, asel, source_operand_A_out);
   MUX_2in_binary source_operand_B(sximm5, pipeline_reg_B_out_shifted, bsel, source_operand_B_out);

   //5) Create the ALU with the outputs of the source operand multiplexers as its main inputs, and output its result and its status
   wire [15:0] alu_out;
   wire[2:0] alu_status;
   ALU alu_block(source_operand_A_out, source_operand_B_out, ALUop, alu_out, alu_status);

   //6) Create a load-enabled register to store the status of the ALU when loads is enabled
   Load_enabled_register #(3) status_register(clk, loads, alu_status, status);

   //7) Create the pipeline register C where you store the output of the ALU when loadc is enabled
   Load_enabled_register #(16) pipeline_reg_C(clk, loadc, alu_out, datapath_out);

   //8) To complete the loop, create a writeback multiplexer that will feed the register file according to vsel:
   //   00 -> output of register C
   //   01 -> {8'b0, PC}
   //   10 -> sximm8
   //   11 -> mdata
   MUX_4in_binary writeback_mux(mdata, sximm8, {8'b0, PC}, datapath_out, vsel, reg_data_in);
endmodule
