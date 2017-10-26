//The register file consists of 8 load-enabled 16-bits registers, that will allow both writing to them and reading from them.
module Register_file(clk, data_in, write, writenum, readnum, data_out);
  input clk, write;  //clk allows a rising edge for the load-enabled registers, while write is a flag to allow writing on them
  input [2:0] writenum, readnum;  //writenum and readnum show which register to read from or write on respectively
  input [15:0] data_in; //this is the data that would be stored on the given writenum location if write is enabled on the next rising edge
  output [15:0] data_out; //this is the output from the readnum location

  //Decode the writenum into a one-hot code to know which register to write in
  wire [7:0] decoded_writenum;
  Decoder #(3, 8) decoder_write(writenum, decoded_writenum);

  //Create 8 wires storing the output of the load-enabled registers created in the next step
  wire [15:0] R0, R1, R2, R3, R4, R5, R6, R7; 

  //Create 8 load-enabled registers Rn, of width 16, where the load comes from the result of AND(write, decoded_writenum[n])
  //store their outputs in the wires defined before
  Load_enabled_register #(16) R0_reg(clk, write & decoded_writenum[0], data_in, R0);
  Load_enabled_register #(16) R1_reg(clk, write & decoded_writenum[1], data_in, R1);
  Load_enabled_register #(16) R2_reg(clk, write & decoded_writenum[2], data_in, R2);
  Load_enabled_register #(16) R3_reg(clk, write & decoded_writenum[3], data_in, R3);
  Load_enabled_register #(16) R4_reg(clk, write & decoded_writenum[4], data_in, R4);
  Load_enabled_register #(16) R5_reg(clk, write & decoded_writenum[5], data_in, R5);
  Load_enabled_register #(16) R6_reg(clk, write & decoded_writenum[6], data_in, R6);
  Load_enabled_register #(16) R7_reg(clk, write & decoded_writenum[7], data_in, R7);

  //Now, we have to decode the readnum into a one-hot code to know which register to read from
  wire [7:0] decoded_readnum;
  Decoder #(3, 8) decoder_read(readnum, decoded_readnum);

  //Finally, assign the value of data_out based on the decoded readnum value and the outputs of the 8 load-enabled registers
  MUX_8in #(16) output_multiplexer(R7, R6, R5, R4, R3, R2, R1, R0, decoded_readnum, data_out);
endmodule
