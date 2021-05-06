
SRC_DIR := src
OBJ_DIR := obj
BIN_DIR := bin

EXT_DIR := /usr
WEBSOCKETPP_DIR := websocketpp
JWTCPP_DIR := jwt-cpp

EXE := $(BIN_DIR)/chippy_server
SRC := $(wildcard $(SRC_DIR)/*.cpp)
OBJ := $(SRC:$(SRC_DIR)/%.cpp=$(OBJ_DIR)/%.o)

CPPFLAGS := -Iinclude -I$(EXT_DIR)/include -I$(WEBSOCKETPP_DIR) -I$(JWTCPP_DIR)/include -MMD -MP
CXXFLAGS := -Wall -std=c++11
LDFLAGS  := -Llib -L$(EXT_DIR)/lib -L$(WEBSOCKETPP_DIR)
LDLIBS   := -lm -lboost_thread -lboost_system -lboost_chrono -lpthread -lstdc++ -lcrypto -lsqlite3

.PHONY: all clean

all: $(EXE)

$(EXE): $(OBJ) | $(BIN_DIR)
		$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | $(OBJ_DIR)
		$(CC) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

$(BIN_DIR) $(OBJ_DIR):
		mkdir -p $@

clean:
		@$(RM) -rv $(BIN_DIR) $(OBJ_DIR)

-include $(OBJ:.o=.d)
