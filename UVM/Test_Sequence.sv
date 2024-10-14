package test_sequence_pkg;
    import seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class reset_sequence extends uvm_sequence #(FIFO_seq_item);
        `uvm_object_utils(reset_sequence);
        FIFO_seq_item seq_item;

        function new(string name = "reset_sequence");
            super.new(name);
        endfunction 
        
        task body();
            seq_item = FIFO_seq_item::type_id::create("seq_item");
            // First Clock
            start_item(seq_item);
                seq_item.rst_n     = 1;
                seq_item.data_in   = 0 ;
                seq_item.wr_en     = 0; 
                seq_item.rd_en     = 0;
                seq_item.rst_n = 0;
            finish_item(seq_item);
            // Second Clock
            start_item(seq_item);
                seq_item.rst_n = 0;
            finish_item(seq_item);
        endtask
    endclass

    class main_sequence extends uvm_sequence #(FIFO_seq_item);
        `uvm_object_utils(main_sequence);
        FIFO_seq_item seq_item;
        
        function new(string name = "main_sequence");
            super.new(name);
        endfunction 
        
        task body();
            seq_item = FIFO_seq_item::type_id::create("seq_item");
            repeat(1000) begin
                start_item(seq_item);
                assert(seq_item.randomize());
                finish_item(seq_item);
            end
        endtask
    endclass
endpackage