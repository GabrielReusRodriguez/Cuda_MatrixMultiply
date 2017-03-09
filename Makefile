BIN_FOLDER = ./bin
SRC_FOLDER = ./src

NVCC=nvcc
NVCC_FLAGS=
SOURCES_FILES= $(SRC_FOLDER)/MatrixMultiply.cu $(SRC_FOLDER)/FileLib.cpp $(SRC_FOLDER)/MemoryLib.cpp  $(SRC_FOLDER)/MatrixLib.cpp
EXECUTABLE_FILE=$(BIN_FOLDER)/MatrixMultiply.out

all:
	$(NVCC)  $(NVCC_FLAGS) $(SOURCES_FILES) -o $(EXECUTABLE_FILE)

debug:
	$(NVCC)  $(NVCC_FLAGS) -g $(SOURCES_FILES) -o $(EXECUTABLE_FILE)
