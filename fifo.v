// This fifo_sim is not synthesizable, although it may behave decently in simulation

module fifo_sim (rdata, wfull, rempty, wdata, winc, wclk, wreset_b, rinc, rclk, rresetb);
   parameter DSIZE = 8;
   parameter ASIZE = 4;
   parameter MEMDEPTH = 1 << ASIZE;
   
   output [DSIZE-1:0] rdata;
   output 	      wfull;
   output 	      rempty;
   input [DSIZE-1:0]  wdata;
   input 	      winc, wclk, wresetb;
   input 	      rinc, rclk, rresetb;

   reg [ASIZE:0]      wptr, wrptr1, wrptr2, wrptr3;
   reg [ASIZE:0]      rptr, rwptr1, rwptr2, rwptr3;

   reg [DSIZE-1:0]    ex_mem [MEMDEPTH-1:0];

   always @(posedge wclk or negedge wresetb) begin
      if (!wresetb) wptr <= 0;
      else if (winc && !wfull) begin
	 wptr <= wptr + 1;
	 ex_mem[wptr[ASIZE-1:0]] <= wdata;
      end
   end

   always @(posedge wclk or negedge wresetb) begin
      if (!wresetb) {wrptr3, wrptr2, wrptr1} <= 0;
      else          {wrptr3, wrptr2, wrptr1} <= {wrptr2, wrptr1, rptr};
   end

   always @(posedge rclk or negedge rresetb) begin
      if (!rresetb) rptr <= 0;
      else if (rinc && !rempty) rptr <= rptr + 1;
   end

   always @(posedge wclk or negedge rresetb) begin
      if (!rwesetb) {rwptr3, rwptr2, rwptr1} <= 0;
      else          {rwptr3, rwptr2, rwptr1} <= {rwptr2, rwptr1, wptr};
   end

   assign rdata = ex_mem[rptr[ASIZE-1:0]];
   assign rempty = (rptr == rwptr3);
   assign wfull = ((wptr[ASIZE-1:0] == wrptr3[ASIZE-1:0]) &&
		   (wptr[ASIZE]     != wrptr3[ASIZE]));
endmodule
   
module fifomem #(parameter DATASIZE = 8, ADDRSIZE = 4)
   (output [DATASIZE-1:0] rdata,
    input [DATASIZE-1:0] wdata,
    input [ADDRSIZE-1:0] waddr, raddr,
    input 		 wclken, wfull, wclk);

   localparam DEPTH = 1 << ADDRSIZE;
   reg [DATASIZE-1:0] 	 mem [0:DEPTH-1];

   assign rdata = mem[raddr];

   always @(posedge wclk) begin
      if (wclken && !wfull) mem[addr] <= wdata;
   end
endmodule // fifomem

// note that signals named with an r prefix are from the r domain, so we can tell the synthesis tool those are false paths
module sync_r2w #(parameter ADDRSIZE = 4)
   (output reg [ADDRSIZE:0] wq2_rptr,
    input [ADDRSIZE:0] rptr,
    input 	       wclk, wresetb);

   reg [ADDRSIZE:0]    wq1_rptr;

   always @(posedge wclk or negedge resetb) begin
      if (!resetb) {wq2_rptr, wq1_rptr} <= 0;
      else         {wq2_rptr, wq1_rptr} <= {wq1_rptr, rptr};
   end
endmodule

module sync_w2r #(parameter ADDRSIZE = 4)
   (output reg [ADDRSIZE:0] rq2_wptr,
    input [ADDRSIZE:0] wptr,
    input 	       rclk, rresetb);
   
   reg [ADDRSIZE:0]    rq1_wptr;
   
   always @(posedge rclk or negedge rresetb)
     if (!resetb) {rq2_wptr,rq1_wptr} <= 0;
     else         {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};
endmodule // sync_w2r

module rptr_empty #(parameter ADDRSIZE = 4)
   (output reg                rempty,
    output [ADDRSIZE-1:0]     raddr,
    output reg [ADDRSIZE :0]  rptr,
    input [ADDRSIZE :0]       rq2_wptr,
    input 		      rinc, rclk, rresetb);
   
   reg [ADDRSIZE:0] rbin;
   wire [ADDRSIZE:0] rgraynext, rbinnext;

   always @(posedge rclk or negedge rresetb) begin
      if (!resetb) {rbin, rptr} <= 0;
      else {rbin, rptr} <= {rbinnext, rgraynext};
   end

   assign raddr = rbin[ADDRSIZE-1:0];

   assign rbinnext = rbin + (rinc & ~rempty);
   assign rgraynext = (rbinnext >> 1) ^ rbinnext;

   assign rempty_val = (rgraynext == rq2_wptr);

   always @(posedge rclk or negedge rresetb) begin
      if (!rresetb) rempty <= 1'b1;
      else rempty = rempty_val;
   end
endmodule

// bin[0] = gray[n] ^ gray[n-1] ^ ... ^ gray[0] // gray >> 0
// bin[1] = gray[n] ^ gray[n-1] ^ ... ^ gray[1] // gray >> 1
// ...
// bin[n] = gray[n]                             // gray >> n

//module gray2bin #(parameter SIZE = 4)
//   (output logic [SIZE-1:0] bin,
 //   input logic [SIZE-1:0] gray);

//   always_comb
//     for (int i=0; i < SIZE; i++)
//       bin[i] = ^(gray >> i);
//endmodule
    
   
