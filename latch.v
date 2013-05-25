module latch1 (o, a, resetb, en);
   output o;
   input  a, resetb, en;
   reg 	  o;

   always @(a or resetb or en) begin
      if (!resetb) o = 1'b0;
      else if (en) o = a;
   end
endmodule   
