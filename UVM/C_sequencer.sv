package sequencer_pkg;
    import seq_item_pkg::*;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_sequencer extends uvm_sequencer #(FIFO_seq_item);
        `uvm_component_utils(FIFO_sequencer);
        function new(string name = "FIFO_sequencer", uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()
    endclass //FIFO_sequencer extends uvm_sequencer #(shiftreg_seq_item)
endpackage

