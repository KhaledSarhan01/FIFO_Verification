module FIFO_SVA (FIFO_if.DUT if_handle);
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    localparam max_fifo_addr = $clog2(FIFO_DEPTH);
    
//------------ Combintional Assertions ------------//
	always_comb begin
	if (!if_handle.rst_n) begin
		RST_COUNT: assert final (if_handle.count == 0)
			else $error("Assertion RST_COUNT failed!");
		RST_RDPTR: assert final (if_handle.rd_ptr == 0)
			else $error("Assertion RST_RDPTR failed!");
		RST_WRPTR: assert final (if_handle.wr_ptr == 0)
			else $error("Assertion RST_WRPTR failed!");	
	end	

	if (if_handle.count == FIFO_DEPTH) begin
		FULL_ASSERT: assert final (if_handle.full)
			else $error("Assertion FULL_ASSERT failed!");
	end

	if (if_handle.count == 0) begin
		EMPTY_ASSERT: assert final (if_handle.empty)
			else $error("Assertion EMPTY_ASSERT failed!");
	end

	if (if_handle.count == FIFO_DEPTH - 2) begin
		ALMOSTFULL_ASSERT: assert final (if_handle.almostfull)
			else $error("Assertion ALMOSTFULL_ASSERT failed!");
	end

	if (if_handle.count == 1) begin
		ALMOSTEMPTY_ASSERT: assert final (if_handle.almostempty)
			else $error("Assertion ALMOSTEMPTY_ASSERT failed!");
	end
	end

//------------ Sequential Assertions ------------// 
	UNDERFLOW_ASSERT: assert property (@(posedge if_handle.clk) disable iff(!if_handle.rst_n) 
                                        (if_handle.empty && if_handle.rd_en) |-> ##1 if_handle.underflow)
		else $error("Assertion UNDERFLOW_ASSERT failed!");

	OVERFLOW_ASSERT: assert property (@(posedge if_handle.clk) disable iff(!if_handle.rst_n) 
                                        (if_handle.full && if_handle.wr_en) |-> ##1 if_handle.overflow)
		else $error("Assertion OVERFLOW_ASSERT failed!");

	WRACK_ASSERT: assert property (@(posedge if_handle.clk) disable iff(!if_handle.rst_n) 
                                        (if_handle.wr_en && !if_handle.full) |-> ##1 if_handle.wr_ack)
		else $error("Assertion WRACK_ASSERT failed!");

	RDPTR_ASSERT: assert property (@(posedge if_handle.clk) disable iff(!if_handle.rst_n) 
                                        (if_handle.rd_en && if_handle.count != 0) |-> ##1 (if_handle.rd_ptr + 1))
		else $error("Assertion RDPTR_ASSERT failed!");	

	WRPTR_ASSERT: assert property (@(posedge if_handle.clk) disable iff(!if_handle.rst_n) 
                                        (if_handle.wr_en && if_handle.count < FIFO_DEPTH) |-> ##1 (if_handle.wr_ptr+1))
		else $error("Assertion WRPTR_ASSERT failed!");

	COUNT_UP_ASSERT: assert property (@(posedge if_handle.clk) disable iff(!if_handle.rst_n) 
                                        (({if_handle.wr_en,if_handle.rd_en} == 2'b10) && !if_handle.full) |-> ##1 (if_handle.count == $past(if_handle.count)+1))
		else $error("Assertion COUNT_UP_ASSERT failed!");

	COUNT_DOWN_ASSERT: assert property (@(posedge if_handle.clk) disable iff(!if_handle.rst_n) 
                                        (({if_handle.wr_en, if_handle.rd_en} == 2'b01) && !if_handle.empty) |-> ##1 (if_handle.count == $past(if_handle.count)-1))
		else $error("Assertion COUNT_DOWN_ASSERT failed!");	
endmodule