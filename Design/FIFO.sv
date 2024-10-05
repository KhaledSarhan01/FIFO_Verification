////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_if.DUT if_handle);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;

wire [FIFO_WIDTH-1:0] data_in;
assign data_in = if_handle.data_in;

wire clk, rst_n, wr_en, rd_en;
assign clk 	 = if_handle.clk;
assign rst_n = if_handle.rst_n;
assign wr_en = if_handle.wr_en;
assign rd_en = if_handle.rd_en;

reg [FIFO_WIDTH-1:0] data_out;
assign if_handle.data_out = data_out;

reg wr_ack, overflow;
assign if_handle.wr_ack = wr_ack;
assign if_handle.overflow = overflow;

wire full, empty, almostfull, almostempty, underflow;
assign if_handle.full = full;
assign if_handle.empty = empty;
assign if_handle.almostfull = almostfull;
assign if_handle.almostempty = almostempty;
assign if_handle.underflow = underflow;

localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		wr_ptr <= 0;
	end
	else if (wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= data_in;
		wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		wr_ack <= 0; 
		if (full & wr_en)
			overflow <= 1;
		else
			overflow <= 0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		rd_ptr <= 0;
	end
	else if (rd_en && count != 0) begin
		data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({wr_en, rd_en} == 2'b10) && !full) 
			count <= count + 1;
		else if ( ({wr_en, rd_en} == 2'b01) && !empty)
			count <= count - 1;
	end
end

assign full = (count == FIFO_DEPTH)? 1 : 0;
assign empty = (count == 0)? 1 : 0;
assign underflow = (empty && rd_en)? 1 : 0; 
assign almostfull = (count == FIFO_DEPTH-2)? 1 : 0; 
assign almostempty = (count == 1)? 1 : 0;

`ifdef ASSERTIONS
//------------ Combintional Assertions ------------//
	always_comb begin
	if (!rst_n) begin
		RST_COUNT: assert final (count == 0)
			else $error("Assertion RST_COUNT failed!");
		RST_RDPTR: assert final (rd_ptr == 0)
			else $error("Assertion RST_RDPTR failed!");
		RST_WRPTR: assert final (wr_ptr == 0)
			else $error("Assertion RST_WRPTR failed!");	
	end	

	if (count == FIFO_DEPTH) begin
		FULL_ASSERT: assert (full)
			else $error("Assertion FULL_ASSERT failed!");
	end

	if (count == 0) begin
		EMPTY_ASSERT: assert (empty)
			else $error("Assertion EMPTY_ASSERT failed!");
	end

	if (count == FIFO_DEPTH - 2) begin
		ALMOSTFULL_ASSERT: assert (almostfull)
			else $error("Assertion ALMOSTFULL_ASSERT failed!");
	end

	if (count == 1) begin
		ALMOSTEMPTY_ASSERT: assert (almostempty)
			else $error("Assertion ALMOSTEMPTY_ASSERT failed!");
	end
	end

//------------ Sequential Assertions ------------// 
	UNDERFLOW_ASSERT: assert property (@(posedge clk) disable iff(!rst_n) (empty && rd_en) |=> underflow)
		else $error("Assertion UNDERFLOW_ASSERT failed!");

	OVERFLOW_ASSERT: assert property (@(posedge clk) disable iff(!rst_n) (full && wr_en) |=> overflow)
		else $error("Assertion OVERFLOW_ASSERT failed!");

	WRACK_ASSERT: assert property (@(posedge clk) disable iff(!rst_n) (wr_en) |=> wr_ack)
		else $error("Assertion WRACK_ASSERT failed!");

	RDPTR_ASSERT: assert property (@(posedge clk) disable iff(!rst_n) (rd_en && count != 0) |=> (rd_ptr + 1))
		else $error("Assertion RDPTR_ASSERT failed!");	

	WRPTR_ASSERT: assert property (@(posedge clk) disable iff(!rst_n) (wr_en && count < FIFO_DEPTH) |=> (wr_ptr+1))
		else $error("Assertion WRPTR_ASSERT failed!");

	COUNT_UP_ASSERT: assert property (@(posedge clk) disable iff(!rst_n) (({wr_en, rd_en} == 2'b10) && !full) |=> (count+1))
		else $error("Assertion COUNT_UP_ASSERT failed!");

	COUNT_DOWN_ASSERT: assert property (@(posedge clk) disable iff(!rst_n) (({wr_en, rd_en} == 2'b01) && !empty) |=> (count-1))
		else $error("Assertion COUNT_DOWN_ASSERT failed!");	
`endif
endmodule