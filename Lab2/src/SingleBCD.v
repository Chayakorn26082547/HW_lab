`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 01/01/2025 02:14:43 AM
// Design Name: BCD_Counter
// Module Name: SingleBCD
// Project Name: BCD_Counter
// Target Devices: Basys3
// Tool Versions: 2023.2
// Description: A single BCD counter module for 1 digit in a 4 digit BCD counter
//////////////////////////////////////////////////////////////////////////////////


module SingleBCD (
    input  wire       Trigger,
    input  wire       Clk,
    input  wire       Reset,
    input  wire       Cin,
    output wire [3:0] DataOut,
    output wire       Cout
);
  // Add your code here
  reg [3:0] dataOut = 4'b0000;
  assign DataOut = dataOut;
  reg cout = 1'b0;
  assign Cout = cout;
  //Assert Cout when DataOut is 9 and Trigger is high or Cin is high
  

  //Counter logic
  always @(posedge Clk)           
      begin                                        
          if(Reset) begin
            dataOut <= 4'b0000;
            cout <= 1'b0;
          end else if(Trigger || Cin) begin
            if (dataOut == 4'b1001) begin
              //Wrap around to 0 When DataOut is 9
              dataOut <= 4'b0000;
              cout <= 1'b1;
            end else begin
              //Increment counter
              dataOut <= dataOut + 1;
              cout <= 1'b0;
            end
          end                                 
      end                                          
  
  // End of your code
endmodule
