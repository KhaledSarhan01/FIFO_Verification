vlib work
vlog -f sourcefile_uvm.txt +cover -covercells +define+ASSERTIONS
vsim -voptargs=+acc work.top -cover -classdebug -uvmcontrol=all
coverage save coverage_db.ucdb -onexit
add wave /top/if_handle/*
run -all
