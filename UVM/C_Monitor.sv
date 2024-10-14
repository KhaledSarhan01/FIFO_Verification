package monitor_pkg;
    import uvm_pkg::*;
    import seq_item_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_monitor extends uvm_monitor;
        `uvm_component_utils(FIFO_monitor);
        
            virtual FIFO_if monitor_if;
            FIFO_seq_item seq_item;
            uvm_analysis_port #(FIFO_seq_item) monitor_aport;

        function new(string name = "FIFO_monitor",uvm_component parent = null);
            super.new(name,parent);
        endfunction 

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            monitor_aport = new("monitor_aport",this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                seq_item = FIFO_seq_item::type_id::create("seq_item",this);
                @(negedge monitor_if.clk);
                // Signals to Watch //
                seq_item.rst_n      = monitor_if.rst_n; 
                seq_item.data_in    = monitor_if.data_in;
                seq_item.wr_en      = monitor_if.wr_en;
                seq_item.rd_en      = monitor_if.rd_en;
                
                seq_item.data_out       = monitor_if.data_out;
                seq_item.wr_ack         = monitor_if.wr_ack;
                seq_item.full           = monitor_if.full;
                seq_item.almostfull     = monitor_if.almostfull;
                seq_item.overflow       = monitor_if.overflow;
                seq_item.empty          = monitor_if.empty;
                seq_item.almostempty    = monitor_if.almostempty;  
                seq_item.underflow      = monitor_if.underflow;
     
                // Siganls to Watch //
                monitor_aport.write(seq_item);
                `uvm_info("run_phase",seq_item.convert2string(),UVM_HIGH);
            end
        endtask
    endclass //FIFO_monitor extends uvm_monitor
endpackage

