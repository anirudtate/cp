# Makefile for competitive programming

# Compiler and flags
CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -O2
DEBUG_FLAGS = -DLOCAL -g

# File names and paths (with custom file support)
FILE ?= solution
SRC = $(FILE).cpp
EXE = $(basename $(FILE))_out
PCH_DIR = .pch
PCH = $(PCH_DIR)/stdc++.h.gch
PCH_INCLUDE_DIR = $(shell dirname "$(BITS_PATH)")

# Find the bits/stdc++.h path (simplified and more reliable)
BITS_PATH := $(shell echo '#include <bits/stdc++.h>' | $(CXX) -x c++ -E - 2>&1 | grep bits/stdc++.h | head -n1 | cut -d'"' -f2)

# Alternative paths if not found
ifeq ($(BITS_PATH),)
BITS_PATH := $(shell find /usr/include/c++/ -name "stdc++.h" 2>/dev/null | head -n1)
endif

ifeq ($(BITS_PATH),)
$(warning Could not find bits/stdc++.h header file)
$(warning Continuing without precompiled headers...)
PCH =
else
$(info Found bits/stdc++.h at $(BITS_PATH))
endif

# Create PCH directory if needed
$(shell mkdir -p $(PCH_DIR))

# Default target (modified to work without PCH if not found)
all: $(if $(PCH),$(PCH)) $(EXE)

# Precompile bits/stdc++.h (only if found)
$(PCH): 
	@if [ -n "$(BITS_PATH)" ]; then \
		$(CXX) $(CXXFLAGS) $(DEBUG_FLAGS) -x c++-header "$(BITS_PATH)" -o $(PCH); \
	fi

# Compile the solution (with or without PCH)
$(EXE): $(SRC) $(if $(PCH),$(PCH))
	@if [ -f "$(PCH)" ]; then \
		$(CXX) $(CXXFLAGS) $(DEBUG_FLAGS) -I$(PCH_DIR) -include stdc++.h $(SRC) -o $(EXE); \
	else \
		$(CXX) $(CXXFLAGS) $(DEBUG_FLAGS) $(SRC) -o $(EXE); \
	fi

# Run the solution
run: $(EXE)
	./$(EXE)

# Clean build artifacts
clean:
	rm -rf $(EXE) $(PCH_DIR)

# Benchmark compilation times
benchmark:
	@echo "Testing compilation with precompiled headers:"
	@/bin/bash -c "time (make clean && make all)" || exit 0
	@echo "\nTesting compilation without precompiled headers:"
	@/bin/bash -c "time $(CXX) $(CXXFLAGS) $(DEBUG_FLAGS) $(SRC) -o $(EXE)_no_pch"

# Make sure these targets are executed even if files with the same name exist
.PHONY: all run clean benchmark
