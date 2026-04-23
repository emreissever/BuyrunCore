RTL_LIST   := tool/rtl.f
INCLUDES   := +incdir+rtl/include
VLOG_INCS  := +incdir+rtl/include

VERILATOR  := verilator
VERILATOR_FLAGS := --lint-only -Wall -Wno-fatal

VLIB  := vlib
VMAP  := vmap
VLOG  := vlog
VSIM  := vsim

WORK_LIB := sim/work
TOP_TB   := tb_rv32i_core

.PHONY: help lint sim run clean

help:
	@echo "Targets:"
	@echo "  make lint    -> Run Verilator lint"
	@echo "  make sim     -> Compile RTL + TB with ModelSim"
	@echo "  make run     -> Run ModelSim simulation in command line"
	@echo "  make clean   -> Clean generated files"

lint:
	$(VERILATOR) $(VERILATOR_FLAGS) -Irtl/include -f $(RTL_LIST)

sim:
	mkdir -p sim
	$(VLIB) $(WORK_LIB)
	cd sim && $(VMAP) work work
	$(VLOG) $(VLOG_INCS) -work $(WORK_LIB) -f $(RTL_LIST) tb/$(TOP_TB).v

run: sim
	cd sim && $(VSIM) -c -voptargs=+acc work.$(TOP_TB) -do "run -all; quit"

clean:
	rm -rf obj_dir sim transcript vsim.wlf modelsim.ini