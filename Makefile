MAKEFLAGS += s

TESTS ?= ./tests
BUILD ?= ./generated
SOURCE ?= ./source
EXECUTABLE ?= $(BUILD)/run

MAIN_TEMPLATE_FILES := $(shell find $(SOURCE)/main -name *.y -or -name *.l)
MAIN_GENERATED_FILES := $(MAIN_TEMPLATE_FILES:%=$(BUILD)/%.c)
MAIN_SOURCE_FILES := $(shell find $(SOURCE)/main -name *.c)
MAIN_OBJECT_FILES := $(MAIN_SOURCE_FILES:%=$(BUILD)/%.o) $(MAIN_GENERATED_FILES:%=%.o)

.PHONY: all before_generating_object_files before_generating_files clean

all: $(EXECUTABLE)
	echo "==> Configuring permissions..."
	chmod +x $(EXECUTABLE)

$(EXECUTABLE): $(MAIN_OBJECT_FILES)
	echo "==> Bulding the executable..."
	$(CC) $^ -lm -o $@

$(MAIN_OBJECT_FILES): $(MAIN_GENERATED_FILES) $(MAIN_SOURCE_FILES) before_generating_object_files

before_generating_object_files:
	echo "==> Generating object files..."

$(MAIN_GENERATED_FILES): before_generating_files

before_generating_files:
	echo "==> Generating source files from templates..."

$(BUILD)/%.y.c.o: $(BUILD)/%.y.c
	mkdir -p $(dir $@)
	$(CC) -I$(SOURCE) -c $< -o $@

$(BUILD)/%.l.c.o: $(BUILD)/%.l.c
	mkdir -p $(dir $@)
	$(CC) -I$(SOURCE) -c $< -o $@

$(BUILD)/%.c.o: %.c
	mkdir -p $(dir $@)
	$(CC) -I$(SOURCE) -c $< -o $@

$(BUILD)/%.y.c: %.y
	mkdir -p $(dir $@)
	# debug: -vtd
	# no debug: -d
	# -d is the same as --defines=y.tab.h
	$(YACC) --defines=$(BUILD)/$<.definitions.h -vt $< -o $@

$(BUILD)/%.l.c: %.l
	mkdir -p $(dir $@)
	# -s - supress default action ECHO
	$(LEX) -o $@ $<

clean:
	echo "==> Cleaning the build directory..."
	$(RM) -rf $(BUILD)
