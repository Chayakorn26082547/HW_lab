`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 01/16/2025 01:45:27 AM
// Design Name: StackCircuit
// Module Name: RAMUnit
// Project Name: StackCircuit
// Target Devices: Basys3
// Tool Versions: 2023.2
// Description: Handle storing Data in the RAM.
//              This module implements a synchronous RAM with 256 locations.
//              On a rising edge of Clk, if RamEnable is asserted:
//                - If WriteEnable is high, DataIn is written to the memory
//                  at the given Address and the new value is output immediately.
//                - Otherwise, the data stored at Address is output.
//////////////////////////////////////////////////////////////////////////////////

module RAMUnit (
    input  wire       Clk,
    input  wire       Reset,
    input  wire       WriteEnable,
    input  wire       RamEnable,
    input  wire [7:0] Address,
    input  wire [7:0] DataIn,
    output wire [7:0] DataOut
);
  // Declare the memory: 256 words of 8 bits each.
  reg [7:0] mem[255:0];
  
  // A register to hold the data output.
  reg [7:0] dataOutReg;
  
  // Connect the internal register to the module output.
  assign DataOut = dataOutReg;
  
  // Synchronous process for memory read and write.
  // Using "write-first" behavior: when writing, the new DataIn is output.
  always @(posedge Clk) begin
    if (Reset) begin
      // On reset, clear the output register.
      dataOutReg <= 8'd0;
    end else if (RamEnable) begin
      if (WriteEnable) begin
        // Write operation: store DataIn into memory and output the new value.
        mem[Address]   <= DataIn;
        dataOutReg     <= DataIn;
      end else begin
        // Read operation: output the stored value at Address.
        dataOutReg     <= mem[Address];
      end
    end
  end

`ifdef COCOTB_SIM
  initial begin
    $dumpfile("waveform.vcd");  // Name of the dump file
    $dumpvars(0, RAMUnit);        // Dump all variables for the top module
  end
`endif

endmodule
