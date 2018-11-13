//Josh Schlichting EECS318
// 16 bit ALU module

module alu (C, ovrflow, co, A, B, alu_cmd);
    input[15:0] A, B;
    input[4:0] alu_cmd;
    output [15:0] C;
    output ovrflow, co;
    wire ovrflow, cin;
    reg[15:0] adder_in1, adder_in2, temp, temp_1, C;
    reg[3:0] shift_amt;
    assign cin = 0;
    always @ ( adder_in1 or adder_in2 or cin) begin
      kung_adder adder_mod(temp, carry_out, adder_in1, adder_in2, cin);
    end
    //
    always @ (alu_cmd) begin
      if(alu_cmd[n-1:n-2] == 2'b00); // arithmatic
      begin
        adder_in1 = A;
        adder_in2 = B;
        case (alu_cmd[n-3:0])
          3'b000 : begin //signed addition
            adder_in1 <= A;
            adder_in2 <= B;
            #10 C = temp;
            co = carry_out;
            if [(adder_in1[15] == adder_in2[15]) && (temp[15] != adder_in1)]
              assign ovrflow = 1;
            else
              assign ovrflow = 0;
          end
          3'b001 : begin //unsigned addition
            adder_in1 <= A;
            adder_in2 <= B;
            #10 C = temp;
            co = carry_out;
          end
          3'b010 : begin // signed subtraction
            if (B[15] == 1) begin
              assign cin = 1;
              adder_in1 <= A;
              adder_in2 <= ~B;
              #10 C = temp;
              co = carry_out;
            end
            //
            else begin
              assign cin = 1;
              adder_in1 <= A;
              adder_in2 <= ~B;
              #10 C = temp;
              co = carry_out;
            end
            if [(adder_in1[15] == adder_in2[15]) && (temp[15] != adder_in1)]
              assign ovrflow = 1;
            else
              assign ovrflow = 0;
            //
          end
          3'b011 : begin // unsigned subtraction

          end
          3'b100 : begin // signed increment or A
            assign cin = 1;
            adder_in1 <= A;
            adder_in2 <= 0;
            #10 C = temp;
            co = carry_out;
          end
          3'b101 : begin // signed decrement of A
            adder_in1 <= A;
            adder_in2 <= 16'b1111111111111111;
            if (adder_in1[15] == adder_in2[15] && temp[15] != adder_in1[15]) begin
              assign ovrflow = 1;
            end
            else
              assign ovrflow = 0;
          end

      end
      else if(alu_cmd[n-1:n-2] == 2'b01) //logic
      begin
        case (alu_cmd[n-3:0])
          3'b000 : begin //and
            assign C = A & B;
          end
          3'b001 : begin //or
            assign C = A | B;
          end
          3'b010 : begin //xor
            assign C = A ^ B;
          end
          3'b100 : begin //not A
            C = ~A;
          end

      end
      else if(alu_cmd[n-1:n-2] == 2'b10) // shift
      begin
        case (alu_cmd[n-3:0])
          3'b000 : begin // logic right shift A by amount of B
            temp = A;
            generate
              genvar i;
              for (i = 0; i < shift_amt; i = i + 1) begin
                temp >> 1;
              end
            endgenerate
            C = temp;
          end
          3'b001 : begin // logic shift left A by amount of begin
            temp = A;
            generate
              genvar i;
              for (i = 0; i < shift_amt; i = i + 1) begin
                temp << 1;
              end
            endgenerate
            C = temp;
          end
          3'b010 : begin // arithmetic left shift A by amount of B
            temp = A;
            generate
              genvar i;
              for (i = 0; i < shift_amt; i = i + 1) begin
                temp_1 = {temp[0], temp[15:1]};
                temp = temp_1;
              end
            endgenerate
            C = temp;
          end
          3'b011 : begin // arithmetic right shift A by amount of B
            temp = A;
            generate
              genvar i;
              for (i = 0; i < shift_amt; i = i + 1) begin
                temp_1 = {temp[0], temp[15:1]};
                temp = temp_1;
              end
            endgenerate
            C = temp;
          end
      end
      else begin // conditional
        case (alu_cmd[n-3:0])
          3'b000 : begin // if A <= B then C(15:0) = <0...0001>
            adder_in1 = A;
            adder_in2 = ~B;
            cin = 1;
            #10 if (temp == 0 || temp[15] = 1)
              C = 16'b0000000000000001;
            else
              C = temp;
          end
          3'b001 : begin // if A < B then C(15:0) = <0...0001>
            adder_in1 = A;
            adder_in2 = ~B;
            cin = 1;
            #10 if (temp[15] = 1)
              C = 16'b0000000000000001;
            else
              C = temp;
          end
          3'b010 : begin //  if A >= B then C(15:0) = <0...0001>
            adder_in1 = A;
            adder_in2 = ~B;
            cin = 1;
            #10 if (temp[15] = 0 || temp = 0;)
              C = 16'b0000000000000001;
            else
              C = temp;
          end
          end
          3'b011 : begin // if A > B then C(15:0) = <0...0001>
            adder_in1 = A;
            adder_in2 = ~B;
            cin = 1;
            #10 if (temp[15] = 0)
              C = 16'b0000000000000001;
            else
              C = temp;
          end
          3'b100 : begin // if A = B C = 0000...001
            temp = A ^ B;

            if (temp == 16'b0000000000000000) begin
              temp = 16'b0000000000000001;
              C = temp;
            end
            else begin
              assign C = 16'b0000000000000000;
            end
          end
          3'b101 : begin // if A != B then C = 0
            temp = A ^ B;
            if (temp == 16'b1111111111111111) begin
              temp = 16'b0000000000000000;
              C = temp;
            end
            else begin
              temp = 16'b0000000000000001;
              assign C = temp;
            end
          end
      end
    end

    end
endmodule



// End Condition OPerators
