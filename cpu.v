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

  //3) Instantiate the state machine to control the datapath (TODO)
  Controller datapath_controller();

  //4) Instantiate the datapath from lab5 (with its modifications)
  datapath DP(.clk(clk), //clock controlling datapath               
                readnum, vsel, loada, loadb,  // register operand fetch stage               
                shift, asel, bsel, ALUop, loadc, loads, sximm5, // computation stage (sometimes called "execute")
                writenum, write, sximm8, .mdata(16'b0), .PC(16'b0), // set when "writing back" to register file               
                .status({V, N, Z}), .datapath_out(out) // outputs from datapath
              );endmodule

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
  assign sximm5 = { 11{inst_reg[4]}, inst_reg[4:0] };  //5-bits extended to 16-bits
  assign sximm8 = { 8{inst_reg[7]}, inst_reg[7:0] };   //8-bits extended to 16-bits

  //this is the shifting op
  assign shift = inst_reg[4:3];

  //readnum and writenum are the same, but they depend on nsel
  assign readnum = (nsel == 3'b001) ? inst_reg[10:8]  //this is the same as Rn
                 : (nsel == 3'b010) ? inst_reg[7:5]   //this is the same as Rd
                 : (nsel == 3'b100) ? inst_reg[2:0]   //this is the same as Rm
                 : 3'bxxx;
  assign writenum = readnum;
endmodule

module Controller();
endmodule
