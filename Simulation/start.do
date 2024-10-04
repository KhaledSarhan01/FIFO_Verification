vlib work
vlog -f sourcefile.txt +cover -covercells +define+ASSERTIONS
vsim -voptargs=+acc work.top -cover
coverage save coverage_db.ucdb -onexit
add wave /top/if_handle/*
run -all
