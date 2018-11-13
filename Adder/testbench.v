//Testbench for brent kung adder

module Testbench ();
  reg[15:0] A, B;
  reg cin;
  wire[15:0] sum;
  wire co; 
  kung_adder a(sum,co, A, B, cin);

  initial begin
    A = 0;
    B = 0;
    cin = 0;
    #100 A = 16'b0001011101110000;//6500
    #100 B = 16'b0110000110101000;//25000
    #300 A = 16'b1101011011011000;//55000
    #300 B = 16'b0000000000011001;//25
    #500 A = 16'b0111111111111111;
    #500 B = 16'b0111111111111111;
    #700 A = 16'b1111111111111111;
    #700 B = 16'b1111111111111111;

  end


endmodule //Testbench for brent kung adder
