// This module
// 
//
module cpu(clk,reset,s,load,in,out,N,V,Z,w);
  input clk, reset, s, load;
  input [15:0] in;
  output [15:0] out;
  output N, V, Z, w;

  //1) Create a load-enabled register that works as the Instruction Register
  wire [15:0] inst_reg_out;
  Load_enabled_register #(16) instruction_register(clk, load, in, inst_reg_out);

  //2) Create the instruction decoder
  wire [2:0] nsel, opcode, readnum, writenum;
  wire [1:0] op, ALUop, shift;
  wire [15:0] sximm5, sximm8;
  Inst_dec instruction_decoder(inst_reg_out, nsel, opcode, op, ALUop, sximm5, sximm8, shift, readnum, writenum);

  //3) Instantiate the state machine to control the datapathS
  wire [1:0] vsel;
  wire loada, loadb, asel, bsel, loadc, loads, write; 
  Controller datapath_controller(clk, s, reset, opcode, op, w, loada, loadb, loadc, loads, asel, bsel, vsel, nsel, write);

  //4) Instantiate the datapath from lab5 (with its modifications)
  datapath DP(.clk(clk), //clock controlling datapath               
                .readnum(readnum), .vsel(vsel), .loada(loada), .loadb(loadb),  // register operand fetch stage               
                .shift(shift), .asel(asel), .bsel(bsel), .ALUop(ALUop), .loadc(loadc), .loads(loads), .sximm5(sximm5), // computation stage (sometimes called "execute")
                .writenum(writenum), .write(write), .sximm8(sximm8), .mdata(16'b0), .PC(8'b0), // set when "writing back" to register file               
                .status({V, N, Z}), .datapath_out(out) // outputs from datapath
              );endmodule

// This module will decode the instruction from the register into usable outputs.
// It uses nsel to pick between the 3 register addresses enconded in the instruction.
module Inst_dec(inst_reg, nsel, opcode, op, ALUop, sximm5, sximm8, shift, readnum, writenum);
  input [15:0] inst_reg;
  input [2:0] nsel;
  output [2:0] opcode, readnum, writenum;
  output [1:0] op, ALUop, shift;
  output [15:0] sximm5, sximm8;

  //opcode and op are the first elements enconded
  assign opcode = inst_reg[15:13];
  assign op = inst_reg[12:11];
  assign ALUop = op; //same as op but required to output twice

  //the immediate values enconded, that should be sign-extended
  assign sximm5 = { {11{inst_reg[4]}}, inst_reg[4:0] };  //5-bits extended to 16-bits
  assign sximm8 = { {8{inst_reg[7]}}, inst_reg[7:0] };   //8-bits extended to 16-bits

  //this is the shifting op
  assign shift = inst_reg[4:3];

  //readnum and writenum are the same, but they depend on nsel
  assign readnum = (nsel == 3'b001) ? inst_reg[10:8]  //this is the same as Rn
                 : (nsel == 3'b010) ? inst_reg[7:5]   //this is the same as Rd
                 : (nsel == 3'b100) ? inst_reg[2:0]   //this is the same as Rm
                 : 3'bxxx;
  assign writenum = readnum;
endmodule

//Main types of state for the Controller
`define WAIT_STATE   3'b000
`define DECODE_STATE 3'b001
`define LOAD_A_STATE 3'b010
`define LOAD_B_STATE 3'b011
`define ALU_STATE    3'b100
`define WRITE_STATE  3'b101

module Controller(clk, s, reset, opcode, op, w, loada, loadb, loadc, loads, asel, bsel, vsel, nsel, write);
  input clk, s, reset;
  input [2:0] opcode;
  input [1:0] op;
  output w, loada, loadb, loadc, loads, asel, bsel, write;
  output [2:0] nsel;
  output [1:0] vsel;

  wire [2:0] present_state, next_state;
  wire [2:0] next_state_reset = reset ? `WAIT_STATE : next_state;
  reg [15:0] next;

  vDFF #(3) clk_state(clk, next_state_reset, present_state);

  always @(*) begin
    casex({s, opcode, op, present_state})
      {6'b0xxxxx, `WAIT_STATE}: next = {`WAIT_STATE, 13'b1000000000000};  //if in WAIT and s is 0, then remain in WAIT and set w=1
      {6'b1xxxxx, `WAIT_STATE}: next = {`DECODE_STATE, 13'b1000000000000}; //if in WAIT and s is 1, then go to DECODE and set w=1
      //Now come initial states with different conditions depending on opcode and op
      {6'bx11010, `DECODE_STATE}: next = {`WRITE_STATE, 13'b0}; //if in DECODE and operation is MOV Rn, then go to WRITE and output nothing 
      {6'bx10101, `DECODE_STATE}, {6'bx101x0, `DECODE_STATE}: next = {`LOAD_A_STATE, 13'b0}; //if in DECODE and operation is CMP, ADD or AND, then go to LOAD_A and output nothing
      {6'bx11000, `DECODE_STATE}, {6'bx10111, `DECODE_STATE}: next = {`LOAD_B_STATE, 13'b0}; //if in DECODE and operation is MOV Rd Rm or MVN, then go to LOAD_B and output nothing 
      //the following are intermediate states, so the input only matters for the output
      {6'bxxxxxx, `LOAD_A_STATE}: next = {`LOAD_B_STATE, 13'b0100000000010}; //if in LOAD_A, then go to LOAD_B and set loada=1, nsel=001
      {6'bxxxxxx, `LOAD_B_STATE}: next = {`ALU_STATE, 13'b0010000001000}; //if in LOAD_B, then go to ALU and set loadb=1, nsel=100
      {6'bx11000, `ALU_STATE}: next = {`WRITE_STATE, 13'b0001010000000}; //if in ALU and MOV Rd Rm operation, then next state is WRITE and set asel=1, bsel=0, loadc=1
      {6'bx10111, `ALU_STATE}, {6'bx101x0, `ALU_STATE}: next = {`WRITE_STATE, 13'b0001000000000}; //if in ALU and ALUop but not CMP, then next state is WRITE and set asel=bsel=0, loadc=1
      {6'bx10101, `ALU_STATE}: next = {`WAIT_STATE, 13'b0000100000000}; //if in ALU and CMP operation, then go to WAIT and output asel=bsel=0, loads=1
      {6'bx11010, `WRITE_STATE}: next = {`WAIT_STATE, 13'b0000000100011}; //if in WRITE and Mov Rn, then go to WAIT and set nsel=001, vsel=10, write=1
      {6'bxxxxxx, `WRITE_STATE}: next = {`WAIT_STATE, 13'b0000000000101}; //if in WRITE but not in MOV Rn, then same as before but set nsel=010, vsel=00, write=1
      default: next = {16{1'bx}};
   endcase
  end

  //assign all the outputs base on the current state, as seen in the always block
  assign {next_state, w, loada, loadb, loadc, loads, asel, bsel, vsel, nsel, write} = next;

endmodule
