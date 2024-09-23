interface FIFO_if(clk);
    input bit clk;

    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;

    logic [FIFO_WIDTH-1:0] data_in;
    logic rst_n, wr_en, rd_en;
    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;

    modport DUT (    
    input  data_in,
    input  clk, rst_n, wr_en, rd_en,
    output data_out,
    output wr_ack, overflow,
    output full, empty, almostfull, almostempty, underflow
    );

    modport TEST (  
    output data_in,
    input  clk, 
    output rst_n, wr_en, rd_en,
    input data_out,
    input wr_ack, overflow,
    input full, empty, almostfull, almostempty, underflow
    );

    modport MONITOR (
    input data_in,
    input  clk, 
    input rst_n, wr_en, rd_en,
    input data_out,
    input wr_ack, overflow,
    input full, empty, almostfull, almostempty, underflow
    );
endinterface
