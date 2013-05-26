// Note: fsm1a and fsm1 have the following problems
// 1. Can have glitches on the output
// 2. Combinational logic on outputs may steal needed cycle time
// partitioning so that we have no combinational logic on the outputs make synthesis/timing easier
// counter-argument is that moving logic from output may create redundant logic

module fsm1a (ds, rd, go, ws, clk, resetb);
   output ds, rd;
   input  go, ws, clk, resetb;

   parameter [1:0] IDLE = 2'b00,
     READ = 2'b01,
     DLY = 2'b10,
     DONE = 2'b11;
   
   reg [1:0] state, next;

   always @(posedge clk or negedge resetb) begin
      if (!resetb) state <= IDLE;
      else         state <= next;
   end

   always @(state or go or ws) begin
      next = 2'bx;
      case (state)
	IDLE: 
	  if (go) next = READ;
	  else    next = IDLE;
	READ:
	  next = DLY;
	DLY:
	  if (ws) next = READ;
	  else    next = DONE;
	DONE:
	  next = IDLE;
      endcase
   end // always @ (state or go or ws)

   assign rd = (state == READ || state == DLY);
   assign ds = (state == DONE);
endmodule

module fsm1 (ds, rd, go, ws, clk, resetb);
   output ds, rd;
   input  go, ws, clk, resetb;

   parameter [1:0] IDLE = 2'b00,
     READ = 2'b01,
     DLY = 2'b10,
     DONE = 2'b11;
   
   reg [1:0] state, next;

   always @(posedge clk or negedge resetb) begin
      if (!resetb) state <= IDLE;
      else         state <= next;
   end

   always @(state or go or ws) begin
      next = 2'bx;
      ds = 1'b0;
      rd = 1'b0;
      case (state)
	IDLE: 
	  if (go) next = READ;
	  else    next = IDLE;
	READ:
	  rd = 1'b1;
	  next = DLY;
	DLY:
	  rd = 1'b1;
	  if (ws) next = READ;
	  else    next = DONE;
	DONE:
	  ds = 1'b1;
	  next = IDLE;
      endcase
   end // always @ (state or go or ws)

   assign rd = (state == READ || state == DLY);
   assign ds = (state == DONE);
endmodule

module fsm1b (ds, rd, go, ws, clk, resetb);
   output ds, rd;
   input  go, ws, clk, resetb;
   reg 	  ds, rd;
   
   parameter [1:0] IDLE = 2'b00,
     READ = 2'b01,
     DLY = 2'b10,
     DONE = 2'b11;

   always @(posedge clk or negedge resetb) begin
      if (!resetb) state <= IDLE;
      else         state <= next;
   end

   always @(state or go or ws) begin
      next = 2'bx;
      case (state)
	IDLE: 
v	  if (go) next = READ;
	  else    next = IDLE;
	READ:
	  next = DLY;
	DLY:
	  if (ws) next = READ;
	  else    next = DONE;
	DONE:
	  next = IDLE;
      endcase
   end // always @ (state or go or ws)

   always @(posedge clk or negedge resetb) begin
      if (!resetb) begin
	 ds <= 1'b0;
	 rd <= 1'b0;
      end else begin
	 ds <= 1'b0;
	 rd <= 1'b0;
	 case (state)
	   IDLE: if (go) rd <= 1'b1;
	   READ:         rd <= 1'b1;
	   DLY:  if (ws) rd <= 1'b1;
	        else     ds <= 1'b1;
	   
      end
   end
endmodule

// encode the output as part of the state
// use extra bits to differentiate between states where output is not identical
module fsm1b_encoded (ds, rd, go, ws, clk, resetb);
   output ds, rd;
   input  go, ws, clk, resetb;

   parameter [2:0] IDLE = 3'b0_00,
     READ = 3'b0_01,
     DLY  = 3'b1_01,
     DONE = 3'b0_10;

   reg [2:0] state, next;

   always @(posedge clk or negedge resetb) begin
      if (!resetb) state <= IDLE;
      else         state <= next;
   end

   always @(state or go or ws) begin
      next = 3'bx;
      case (state)
	IDLE: 
	  if (go) next = READ;
	  else next = IDLE;
	READ:
	  next = DLY;
	DLY:
	  if (ws) next = READ;
	  else next = DONE;
	DONE:
	  next = IDLE;
      endcase
   end // always @ (state or go or ws)

   assign {ds, rd} = state[1:0]
endmodule


  
