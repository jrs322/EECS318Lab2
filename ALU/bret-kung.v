//Josh Schlichting
//EECS 318

//Log adder eqn:
//          Sum = a xor b xor c
//          c0 = cin
//          P = A + B, G = A*B, Ci = G + P*Cin


module kung_adder(sum, carry_out, A, B, cin);
  input[15:0] A, B;
  input cin;
  output[15:0] sum;
  output carry_out;
  wire [15:0] P, G, sum, co;
  assign co[0] = 0;
  generate
    genvar i;
    //stage 0
    for (i = 0; i < 16; i = i + 1) begin
      assign P[i] = A[i] ^ B[i];
      assign G[i]  = A[i] & B[i];
    end
    assign sum[0] = P[0] ^ cin;
    for (i = 1; i <16; i = i + 1) begin
      assign sum[i] = P[i] ^ co[i-1];
      assign co[i] = (G[i] & B[i]) | (P[i-1] & co[i-1]);
    end
    endgenerate
    assign carry_out = co[15];
  initial begin
    $monitor("%d %d %b %b %d %d",$time, {carry_out,sum}, sum, carry_out, A, B );
  end


endmodule
