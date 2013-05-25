module lfsra (q3, clk, resetb);
   output q3;
   input  clk, resetb;
   reg 	  q3, q2, q1;

   always @(posedge clk or negedge resetb) begin
      if (!resetb) {q3, q2, q1} <= 3'b111;
      else         {q3, q2, q1} <= {q2, (q1 ^ q3), q3};
   end
endmodule // lfsra

module lfsrb (q3, clk, resetb);
   output q3;
   input  clk, resetb;
   reg 	  q3, q2, q1;

   always @(posedge clk or negedge resetb) begin
      if (!resetb) begin
	 q3 <= 1'b1;
	 q2 <= 1'b1;
	 q1 <= 1'b1;
      end else begin
	 q3 <= q2;
	 q2 <= q1 ^ q3;
	 q1 <= q3;
      end
   end
endmodule
   
