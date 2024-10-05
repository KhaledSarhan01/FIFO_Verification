import shared_pkg::*;

module FIFO_tb(FIFO_if.TEST if_handle);
    FIFO_transaction F_txn = new();
    initial begin
        // Start of Verification
            $display("Start of Verification");
            Initialization();
        // Reset Assert
            Reset_Assert();
        // Simple Randomization
            repeat(1000)begin
                @(negedge if_handle.clk);
                assert(F_txn.randomize());
                Stimulus();
            end
        // End of Verification
            $display("End of Verification");
            F_txn.scoreboard();
            $stop;
    end

    task Reset_Assert();
        if_handle.rst_n = 0;
        @(negedge if_handle.clk);
        if_handle.rst_n = 1;
    endtask

    task Stimulus();
        if_handle.rst_n     = F_txn.rst_n;
        if_handle.data_in   = F_txn.data_in ;
        if_handle.wr_en     = F_txn.wr_en; 
        if_handle.rd_en     = F_txn.rd_en;
    endtask

    task Initialization();
        if_handle.rst_n     = 1;
        if_handle.data_in   = 0 ;
        if_handle.wr_en     = 0; 
        if_handle.rd_en     = 0;
    endtask
endmodule