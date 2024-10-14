package seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh";
        parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;
    class FIFO_seq_item extends uvm_sequence_item;
        `uvm_object_utils(FIFO_seq_item)

    //----------------- Sequence Item Signals ------------------//
        bit [FIFO_WIDTH-1:0] data_in;
        bit rst_n, wr_en, rd_en;

        bit [FIFO_WIDTH-1:0] data_out;
        bit wr_ack;
        bit full, almostfull, overflow;
        bit empty, almostempty, underflow;

        int RD_EN_ON_DIST , WR_EN_ON_DIST;      
    //---------------- Sequence Item Functions ------------------//
        function new(string name = "FIFO_seq_item");
            super.new(name);
            RD_EN_ON_DIST = 30 ; 
            WR_EN_ON_DIST = 70 ;
        endfunction

        function string convert2string();
            return $sformatf("Data_Out = %d , wr_ack = %1b  
                            | Full Flags: full = %1b , almostfull = %1b , overflow = %1b
                            | Empty Flags: empty = %1b , almostempty = %1b , underflow = %1b",
                            data_out,wr_ack,full, almostfull, overflow,empty, almostempty, underflow);
        endfunction 

        function string convert2string_stimulus();
            return $sformatf("%s | rst_n = %1b |data_in = %d | {wr_en,rd_en} = %2b",
                            convert2string(),rst_n,data_in,{wr_en,rd_en});
        endfunction 
    
    //---------------------- Constraints ----------------------//
        constraint reset_const{
            rst_n dist{0:/2 , 1:/ 98};
        }   

        constraint wr_en_const{
            wr_en dist{1:/WR_EN_ON_DIST , 0:/100-WR_EN_ON_DIST};
        } 

        constraint rd_en_const{
            rd_en dist{1:/RD_EN_ON_DIST , 0:/100-RD_EN_ON_DIST};
        }
    endclass 
endpackage