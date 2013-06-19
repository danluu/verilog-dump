module dff1 (
	     output bit_t q,
	     input  bit_t, d, clk, resetb);

   always_ff @(posedge clk, negedge resetb) begin
      if (!resetb) q <= 0;
      else         q <= d;      
   end
endmodule


    
     
