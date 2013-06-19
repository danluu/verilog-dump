// example of mixing combinational and sequential logic

module mixa (q, a, b, clk, resetb);
   output q;
   input  a, b, clk, resetb;
   reg 	  q;

   always @(posedge clk or negedge resetb) begin
      if (!resetb) q <= 1'b0;
      else         q <= a ^ b;
   end
endmodule // mixa

module mixb (q, a, b, clk, resetb);
   output q;
   input  a, b, clk, resetb;
   reg 	  q, y;

   always @(a or b) begin
      y = a ^ b;      
   end
     
   always @(clk or negedge resetb) begin
      if (!resetb) q <= 1'b0;
      else         q <= y;      
   end
endmodule
