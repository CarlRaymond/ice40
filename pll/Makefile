# Project setup
PROJ      = pll
BUILD     = ./build
DEVICE    = 1k
FOOTPRINT = tq144

# Files
FILES = pll.v
FILES += ../lib/scaler.v

.PHONY: all clean burn

all:
	# if build folder doesn't exist, create it
	mkdir -p $(BUILD)
	# synthesize using Yosys
	yosys -Q -T -q -p "synth_ice40 -top top -blif $(BUILD)/$(PROJ).blif" $(FILES)
	# Place and route using arachne
	arachne-pnr -d $(DEVICE) -P $(FOOTPRINT) -o $(BUILD)/$(PROJ).asc -p pinmap.pcf $(BUILD)/$(PROJ).blif
	# Convert to bitstream using IcePack
	icepack $(BUILD)/$(PROJ).asc $(BUILD)/$(PROJ).bin

check:
	yosys -p "proc check" $(FILES)

burn: all
	iceprog $(BUILD)/$(PROJ).bin

clean:
	rm build/*