package seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh";
     
    class FIFO_seq_item extends uvm_sequence_item;
        `uvm_object_utils(FIFO_seq_item)

    //----------------- Sequence Item Signals ------------------//
       
    
    //---------------- Sequence Item Functions ------------------//
        function new(string name = "FIFO_seq_item");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("");
        endfunction 

        function string convert2string_stimulus();
            return $sformatf("%s ",convert2string());
        endfunction 
    
    //---------------------- Constraints ----------------------//
    
    endclass 
endpackage