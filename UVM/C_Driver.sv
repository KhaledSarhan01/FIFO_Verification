package dirver_pkg;
    import seq_item_pkg::*;
    import uvm_pkg ::*;
    `include "uvm_macros.svh"

    class FIFO_driver extends uvm_driver #(FIFO_seq_item);

        `uvm_component_utils(FIFO_driver);
        virtual FIFO_if driver_if;
        FIFO_seq_item seq_item;

        function new(string name = "FIFO_driver",uvm_component parent = null);
            super.new(name,parent); 
        endfunction 

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
            seq_item = FIFO_seq_item::type_id::create("seq_item");
            seq_item_port.get_next_item(seq_item);
                //----- Input Signals -----//
                    driver_if.rst_n     = seq_item.rst_n;
                    driver_if.wr_en     = seq_item.wr_en;
                    driver_if.rd_en     = seq_item.rd_en;
                    driver_if.data_in   = seq_item.data_in;
                //------ End Inputs ------//    
                @(negedge driver_if.clk);
            seq_item_port.item_done();
            `uvm_info("Driver Run Phase",seq_item.convert2string_stimulus(),UVM_HIGH); 
            end
        endtask
    endclass 
endpackage


