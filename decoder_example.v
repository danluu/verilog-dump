module decoder_example(ce0, ce1, cs, en, addr);
   output ce0, ce1, cs;
   input  en, addr;
   input [31:30] addr;
   reg 	  ce0, ce1, cs;

   // note: a casex here could cause a problem
   // e.g., if en = x, we'll match one of the cases
   // also, if high bit of address is X, we'll match into one of the ce cases
   always @ (addr or en) begin
      {ce0, ce1, cs} = 3'b0;
      casez ({addr, en})
	3'b101: ce0 = 1'b1;
	3'b111: ce1 = 1'b1;
	3'b0?1: cs = 1'b1;
      endcase
   end
endmodule
