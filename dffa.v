module dffa (q, d, clk, resetb, setb);
   output q;
   input  d, clk, resetb, setb;
   reg 	  q;

   // Note that this synthesizes correctly but can simulate incorrectly
   // assert reset -> assert set -> remove reset doesn't switch gate to 1
   always @(posedge clk or negedge resetb or negedge setb) begin
      if (!resetb)      q <= 0;
      else if (!setb)   q <= 1;
      else              q <= d;
   end
endmodule // dffa

module dffa_fixed
   output q;
   input  d, clk, resetb, setb;
   reg 	  q;

   always @(posedge clk or negedge resetb or negedge setb) begin
      if (!resetb)      q <= 0;
      else if (!setb)   q <= 1;
      else              q <= d;
   end

   // synopsys translate_off
   always @(rstn or setn)
     if (rstn && !setn) force q = 1;
     else               release q;
   // synopsys translate_on
endmodule  
