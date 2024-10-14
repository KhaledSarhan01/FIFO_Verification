package env_pkg;   
    import cvg_pkg::*;
    import agent_pkg::*;
    import scoreboard_pkg::*;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    class FIFO_env extends uvm_env;
        `uvm_component_utils(FIFO_env)
        
        FIFO_Coverage FIFO_cover;
        FIFO_Agent agent;
        FIFO_Scoreboard scoreboard;
        
        function new(string name = "FIFO_env" , uvm_component parent = null);
            super.new(name,parent);
        endfunction
        
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            FIFO_cover  = FIFO_Coverage    ::type_id::create("FIFO_cover",this);
            agent       = FIFO_Agent       ::type_id::create("agent",this);
            scoreboard  = FIFO_Scoreboard  ::type_id::create("scoreboard",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agent.agent_aport.connect(FIFO_cover.cvg_aport);
            agent.agent_aport.connect(scoreboard.sb_aport);
        endfunction
       
    endclass    
    
endpackage

