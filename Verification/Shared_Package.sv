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
            l   bit full, empty, almostfull, almostempty, underflow;
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

    class FIFO_scoreboard;
        function new();
            
        endfunction
    endclass

    class FIFO_coverage;
        function new();
            
        endfunction
    endclass
endpackage