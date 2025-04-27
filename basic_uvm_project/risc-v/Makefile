# //******************************************* 
# // Makefile
# //*******************************************

BUILD_DIR=${TB_ROOT}/build_dir
RUN_DIR=${TB_ROOT}/build_dir

VCS_FLAGS=-sverilog -ntb_opts uvm-1.1 -debug_pp -kdb -debug_access -lca +vcs+lic_wait -full64 -reportstats

UVM_FLAGS=+UVM_VERBOSITY=${UVM_VERBOSITY}  +UVM_TESTNAME=test_base

FLIST=$(TB_ROOT)/tb.flist 

UVM_SEED=+ntb_random_seed_automatic

all_vcs: build_vcs run_vcs

build_vcs: 
	rm -rf ${BUILD_DIR} && \
	mkdir ${BUILD_DIR} && \
	cd ${BUILD_DIR} && \
	vcs ${INCLUDE_DIR} ${VCS_FLAGS} -file ${FLIST} -l build.log

run_vcs: 
	rm -rf ${RUN_DIR} && \
	mkdir ${RUN_DIR} && \
	cd ${RUN_DIR} && \
	${BUILD_DIR}/simv ${UVM_FLAGS} -l vcs.log  $
