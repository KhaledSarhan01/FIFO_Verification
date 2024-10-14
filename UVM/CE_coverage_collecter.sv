package cvg_pkg;
    import seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    class FIFO_Coverage extends uvm_component;
        `uvm_component_utils(FIFO_Coverage)
        FIFO_seq_item seq_item;
        uvm_analysis_port #(FIFO_seq_item) cvg_aport;
        uvm_tlm_analysis_fifo #(FIFO_seq_item) cvg_FIFO;
        
        //-------------- Covergroup ------------------//
         covergroup F_cvg_grp;
            option.per_instance = 1;
            
            // Inputs 
                RD_EN:coverpoint seq_item.rd_en {
                    bins RD_EN_ON  = {1'b1};
                    bins RD_EN_OFF = {1'b0};
                    option.weight=0;    
                }

                WR_EN:coverpoint seq_item.wr_en {
                    bins WR_EN_ON  = {1'b1};
                    bins WR_EN_OFF = {1'b0};
                    option.weight=0;    
                }

            // Acknowlodge    
                WR_ACK:coverpoint seq_item.wr_ack {
                    bins WR_ACK_YES  = {1'b1};
                    bins WR_ACK_NO = {1'b0};
                    option.weight=0;    
                }

            // FULL Flags
                OVERFLOW:coverpoint seq_item.overflow {
                    bins OVERFLOW_YES  = {1'b1};
                    bins OVERFLOW_NO = {1'b0};
                    option.weight=0;    
                }

                FULL:coverpoint seq_item.full {
                    bins FULL_YES  = {1'b1};
                    bins FULL_NO = {1'b0};
                    option.weight=0;    
                }

                ALMOST_FULL:coverpoint seq_item.almostfull {
                    bins ALMOST_FULL_YES  = {1'b1};
                    bins ALMOST_FULL_NO = {1'b0};
                    option.weight=0;    
                }

            // Empty Flags
                UNDERFLOW:coverpoint seq_item.underflow {
                    bins UNDERFLOW_YES  = {1'b1};
                    bins UNDERFLOW_NO = {1'b0};
                    option.weight=0;    
                }

                EMPTY:coverpoint seq_item.empty {
                    bins EMPTY_YES  = {1'b1};
                    bins EMPTY_NO   = {1'b0};
                    option.weight=0;    
                }

                ALMOST_EMPTY:coverpoint seq_item.almostempty {
                    bins ALMOST_EMPTY_YES  = {1'b1};
                    bins ALMOST_EMPTY_NO = {1'b0};
                    option.weight=0;    
                }
            // Cross Coverage
                RD_EMPTY: cross RD_EN,UNDERFLOW,EMPTY,ALMOST_EMPTY{
                    ignore_bins NOT_EMPTY =  binsof(EMPTY.EMPTY_NO) && binsof(UNDERFLOW.UNDERFLOW_YES)
                                          || binsof(ALMOST_EMPTY.ALMOST_EMPTY_YES) && binsof(EMPTY.EMPTY_YES);
                }
                RD_FULL: cross RD_EN,OVERFLOW,FULL,ALMOST_FULL{
                    ignore_bins NOT_FULL =  binsof(FULL.FULL_NO) && binsof(OVERFLOW.OVERFLOW_YES)
                                          || binsof(ALMOST_FULL.ALMOST_FULL_YES) && binsof(FULL.FULL_YES);
                }
                WR_EMPTY: cross WR_EN,UNDERFLOW,EMPTY,ALMOST_EMPTY{
                    ignore_bins NOT_EMPTY =  binsof(EMPTY.EMPTY_NO) && binsof(UNDERFLOW.UNDERFLOW_YES)
                                          || binsof(ALMOST_EMPTY.ALMOST_EMPTY_YES) && binsof(EMPTY.EMPTY_YES);
                }
                WR_FULL: cross WR_EN,OVERFLOW,FULL,ALMOST_FULL{
                    ignore_bins NOT_FULL =  binsof(FULL.FULL_NO) && binsof(OVERFLOW.OVERFLOW_YES)
                                          || binsof(ALMOST_FULL.ALMOST_FULL_YES) && binsof(FULL.FULL_YES);
                }
                
                WR_EN_ACK: cross WR_EN,WR_ACK;
                RD_EN_ACK: cross RD_EN,WR_ACK;        
        endgroup
          
        //------------ End Covergroup ----------------//
        function new(string name = "FIFO_Coverage" , uvm_component parent = null);
            super.new(name,parent);
            F_cvg_grp = new();
        endfunction
        
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cvg_aport = new("cvg_aport",this);
            cvg_FIFO  = new("cvg_FIFO",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cvg_aport.connect(cvg_FIFO.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cvg_FIFO.get(seq_item);
                F_cvg_grp.sample();
            end
        endtask
    endclass    
endpackage

