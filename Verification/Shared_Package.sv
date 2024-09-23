/*
    vsim -voptargs=+acc work.top -cover
    coverage save coverage_db.ucdb -onexit
    run -all
*/
package shared_pkg;
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;

    class FIFO_transaction;
        // Signals
            // Inputs
                rand bit rst_n;
                rand bit [FIFO_WIDTH-1:0] data_in;
                rand bit wr_en, rd_en;
            // Outputs
                bit [FIFO_WIDTH-1:0] data_out;
                bit wr_ack, overflow;
                bit full, empty, almostfull, almostempty, underflow;
            // Variables
                int RD_EN_ON_DIST , WR_EN_ON_DIST;

        // Constraints
            constraint reset_const{
                rst_n dist{0:/2 , 1:/ 98};
            }   

            constraint wr_en_const{
                wr_en dist{1:/WR_EN_ON_DIST , 0:/100-WR_EN_ON_DIST};
            } 

            constraint rd_en_const{
                rd_en dist{1:/RD_EN_ON_DIST , 0:/100-RD_EN_ON_DIST};
            }

        // Functions
            // Constructor    
                function new(int RD_EN_ON_DIST_i = 30 , WR_EN_ON_DIST_i = 70);
                    // Inputs
                        rst_n   = 1'b1;
                        data_in = 0;
                        wr_en   = 1'b0;
                        rd_en   = 1'b0;
                    // Outputs
                        data_out = 1'b0;
                        wr_ack   = 1'b0;
                        overflow = 1'b0;
                        full     = 1'b0;
                        empty    = 1'b1;
                        almostfull  = 1'b0; 
                        almostempty = 1'b0;
                        underflow   = 1'b0;
                    // Variables
                        RD_EN_ON_DIST = RD_EN_ON_DIST_i;
                        WR_EN_ON_DIST = WR_EN_ON_DIST_i;
                endfunction 
    endclass 

    class FIFO_coverage;
            FIFO_transaction F_cvg_txn;
            
        // Coverage Groups
        covergroup F_cvg_grp;
            // Inputs 
                RD_EN:coverpoint F_cvg_txn.rd_en {
                    bins RD_EN_ON  = {1'b1};
                    bins RD_EN_OFF = {1'b0};
                    option.weight=0;    
                }

                WR_EN:coverpoint F_cvg_txn.wr_en {
                    bins WR_EN_ON  = {1'b1};
                    bins WR_EN_OFF = {1'b0};
                    option.weight=0;    
                }

            // Acknowlodge    
                WR_ACK:coverpoint F_cvg_txn.wr_ack {
                    bins WR_ACK_YES  = {1'b1};
                    bins WR_ACK_NO = {1'b0};
                    option.weight=0;    
                }

            // FULL Flags
                OVERFLOW:coverpoint F_cvg_txn.overflow {
                    bins OVERFLOW_YES  = {1'b1};
                    bins OVERFLOW_NO = {1'b0};
                    option.weight=0;    
                }

                FULL:coverpoint F_cvg_txn.full {
                    bins FULL_YES  = {1'b1};
                    bins FULL_NO = {1'b0};
                    option.weight=0;    
                }

                ALMOST_FULL:coverpoint F_cvg_txn.almostfull {
                    bins ALMOST_FULL_YES  = {1'b1};
                    bins ALMOST_FULL_NO = {1'b0};
                    option.weight=0;    
                }

            // Empty Flags
                UNDERFLOW:coverpoint F_cvg_txn.underflow {
                    bins UNDERFLOW_YES  = {1'b1};
                    bins UNDERFLOW_NO = {1'b0};
                    option.weight=0;    
                }

                EMPTY:coverpoint F_cvg_txn.empty {
                    bins EMPTY_YES  = {1'b1};
                    bins EMPTY_NO   = {1'b0};
                    option.weight=0;    
                }

                ALMOST_EMPTY:coverpoint F_cvg_txn.almostempty {
                    bins ALMOST_EMPTY_YES  = {1'b1};
                    bins ALMOST_EMPTY_NO = {1'b0};
                    option.weight=0;    
                }
            // Cross Coverage
                RD_EMPTY: cross RD_EN,UNDERFLOW,EMPTY,ALMOST_EMPTY;
                RD_FULL: cross RD_EN,OVERFLOW,FULL,ALMOST_FULL;
                RD_EN_ACK: cross RD_EN,WR_ACK;
                WR_EMPTY: cross WR_EN,UNDERFLOW,EMPTY,ALMOST_EMPTY;
                WR_FULL: cross WR_EN,OVERFLOW,FULL,ALMOST_FULL;
                WR_EN_ACK: cross WR_EN,WR_ACK;        
        endgroup

        // Functions    
        function void sample_data(FIFO_transaction F_txn);
            F_cvg_txn = F_cvg_txn;
        endfunction
        
    endclass

    class FIFO_scoreboard;
        function new();
            
        endfunction
    endclass
endpackage