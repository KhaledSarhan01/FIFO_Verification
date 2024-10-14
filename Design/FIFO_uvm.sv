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

reg wr_ack, overflow,underflow;
assign if_handle.wr_ack = wr_ack;
assign if_handle.overflow = overflow;

wire full, empty, almostfull, almostempty;
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
		overflow <= 0; 	// Bug: No Value during Reset 
		wr_ack <= 0; 	// Bug: No Value during Reset
		for (int i = 0; i < FIFO_DEPTH ; i++ ) begin 
			mem[i] = 0; // Bug: No Values during Reset
		end
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
		data_out <= 0; // BUG: No Value during Reset
		underflow <= 0;
	end
	else if (rd_en && count != 0) begin
		data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end else begin	// BUG : Squential Output "Underflow" is Created
		if (empty && rd_en) begin
			underflow <= 1;
		end else begin
			underflow <= 0;
		end
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
//assign underflow = (empty && rd_en)? 1 : 0; //BUG : the Output is Squential 
assign almostfull = (count == FIFO_DEPTH-2)? 1 : 0; 
assign almostempty = (count == 1)? 1 : 0;
endmodule