RTL_LIST   := tool/rtl.f
INCLUDES   := -Irtl/include

VERILATOR  := verilator
VERILATOR_FLAGS := --lint-only -Wall -Wno-fatal

.PHONY: lint clean help

help:
	@echo "Targets:"
	@echo "  make lint    -> Run Verilator lint"
	@echo "  make clean   -> Clean generated files"

lint:
	$(VERILATOR) $(VERILATOR_FLAGS) $(INCLUDES) -f $(RTL_LIST)

clean:
	rm -rf obj_dir