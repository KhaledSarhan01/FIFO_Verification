package agent_pkg;
    import dirver_pkg::*;
    import sequencer_pkg::*;
    import monitor_pkg::*;
    import config_pkg::*;
    import seq_item_pkg::*;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_Agent extends uvm_agent;
        `uvm_component_utils(FIFO_Agent);
    
        FIFO_driver driver;
        FIFO_sequencer sequencer;
        FIFO_monitor monitor;
    
        FIFO_config_obj agent_config;
        uvm_analysis_port #(FIFO_seq_item) agent_aport;
    
        function new(string name = "FIFO_Agent", uvm_component parent = null);
            super.new(name,parent);
        endfunction 
    
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            driver      = FIFO_driver::type_id::create("driver",this);
            sequencer   = FIFO_sequencer::type_id::create("sequencer",this);
            monitor     = FIFO_monitor::type_id::create("monitor",this);
            agent_aport = new("agent_aport",this);
            
            if (!(uvm_config_db #(FIFO_config_obj)::get(this,"","test_FIFO_obj",agent_config))) begin
                    `uvm_fatal("Build Phase","Agent : Unable to get the Virtual Interface")
            end
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            driver.driver_if   = agent_config.FIFO_config_vif;
            monitor.monitor_if = agent_config.FIFO_config_vif;
            driver.seq_item_port.connect(sequencer.seq_item_export);
            monitor.monitor_aport.connect(agent_aport);
        endfunction

    endclass //FIFO_Agent extends uvm_agnet
endpackage

