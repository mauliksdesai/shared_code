# //******************************************* 
# // Makefile
# //*******************************************

BUILD_DIR=${TB_ROOT}/output_dir0
RUN_DIR=${TB_ROOT}/output_dir0

VCS_FLAGS=-sverilog -ntb_opts uvm-1.1 -debug_pp -kdb -debug_access -lca +vcs+lic_wait -full64 -reportstats

UVM_FLAGS=+UVM_VERBOSITY=${UVM_VERBOSITY}  +UVM_TESTNAME=test_base +uvm_set_report_default_hier=0

FLIST=$(TB_ROOT)/tb.flist 

UVM_SEED=+ntb_random_seed_automatic

all_vcs: build_vcs run_vcs

build_vcs: 
	cd ${BUILD_DIR} && \
	vcs ${INCLUDE_DIR} ${VCS_FLAGS} -file ${FLIST} -l build.log

run_vcs: 
	cd ${RUN_DIR} && \
	${BUILD_DIR}/simv ${UVM_FLAGS} -l vcs.log  $
