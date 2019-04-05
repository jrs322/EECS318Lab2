//Josh Schlichting
//EECS 318

//Log adder eqn:
//          Sum = a xor b xor c
//          c0 = cin
//          P = A + B, G = A*B, Ci = G + P*Cin


module log_adder(sum, carryout, add_A, add_B, add_cin);
  input[15:0] add_A, add_B;
  input add_cin;
  output[15:0] sum;
  output carryout;
  wire [15:0] P0, G0, P1, G1, P2, G2, P3, G3, P4, G4;
  wire[15:0] co;

  generate
    genvar i;
    //stage 0
    for (i = 0; i < 16; i = i + 1) begin
      assign P0[i] = add_A[i] ^ add_B[i];
      assign G0[i]  = add_A[i] & add_B[i];
    end

    //stage 1
    genvar j;
    assign P1[0] = P0[0];
    assign G1[0] = P0[0];
    for (j = 1; j < 16; j = j + 1) begin
      assign P1[j] = P0[j] & P0[j-1];
      assign G1[j] = (P0[j] & G0[j-1]) | G0[j];
    end

    //stage 2
    genvar k;
    assign P2[1:0] = P1[1:0];
    assign G2[1:0] = G1[1:0];
    for (k = 2; k < 16; k = k + 1) begin
      assign P2[k] = P1[k] & P1[k-2];
      assign G2[k] = (P1[k] & G1[k-2]) | G1[k];
    end

    //stage 3
    genvar l;
    assign P3[3:0] = P2[3:0];
    assign G3[3:0] = G2[3:0];
    for (l = 4; l < 16; l = l+1) begin
      assign P3[l] = P2[l] & P2[l-4];
      assign G3[l] = (P2[l] & G2[l-4]) | G2[l];
    end

    //stage 4
    genvar m;
    assign P4[7:0] = P3[7:0];
    assign G4[7:0] = G3[7:0];
    for (m = 8; m < 16; m = m + 1) begin
      assign P4[m] = P3[m] & P3[m-8];
      assign G4[m] = (P3[m] & G3[m-8]) | G3[m];
    end

    genvar o;
    for (o = 0; o < 16; o = o + 1) begin
      assign co[o] = ((P4[o] & add_cin) | G4[o]);
    end

    assign carryout = co[15];
    assign sum[0] = add_cin ^ P0[0];
    genvar n;
    for (n = 1; n < 16; n = n + 1)
      begin
        assign sum[n] = P0[n] ^ co[n-1];
      end
    endgenerate


  initial begin
    $monitor("%d %d %d %b %b %b %d %b", $time, add_A, add_B, add_cin, carryout, sum, {carryout, sum}, add_cin);
  end


endmodule
