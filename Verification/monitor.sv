import shared_pkg::*;

module FIFO_MONITOR(FIFO_if.MONITOR if_handle);
    FIFO_transaction F_txn;
    FIFO_scoreboard F_score;
    FIFO_coverage   F_cvg;
    initial begin
        F_txn = new();
        F_cvg = new();
        F_score = new();
        forever begin
            @(negedge if_handle.clk);
            SAMPLE_DATA();
            // Coverage
                fork
                    F_cvg.sample_data(F_txn);        
                join
            // Checking
                fork
                    F_score.check_data(F_txn);
                join
        end
    end

    task SAMPLE_DATA();
        F_txn.rst_n     = if_handle.rst_n;
        F_txn.data_in   = if_handle.data_in;
        F_txn.wr_en     = if_handle.wr_en; 
        F_txn.rd_en     = if_handle.rd_en;
        F_txn.data_out  = if_handle.data_out;
        F_txn.wr_ack    = if_handle.wr_ack; 
        F_txn.overflow  = if_handle.overflow;
        F_txn.full      = if_handle.full; 
        F_txn.empty     = if_handle.empty;
        F_txn.almostfull  = if_handle.almostfull; 
        F_txn.almostempty = if_handle.almostempty; 
        F_txn.underflow   = if_handle.underflow;
    endtask
endmodule