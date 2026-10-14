CC       ?= gcc
FLEX     ?= flex
BISON    ?= bison
CFLAGS   ?= -std=gnu11 -Wall -Wextra -O2
BIN      := bin
BUILD    := build
PROGRAMS := practical01 practical02 practical03 practical04 practical05 practical06 practical07 practical08 practical09 practical10 value_added_icg

.PHONY: all clean test
all: $(addprefix $(BIN)/,$(PROGRAMS))

$(BIN) $(BUILD):
	mkdir -p $@

$(BIN)/practical01: practical01_lex_intro/lexer.l | $(BIN) $(BUILD)
	$(FLEX) -o $(BUILD)/p01.c $<
	$(CC) $(CFLAGS) $(BUILD)/p01.c -o $@

$(BIN)/practical02: practical02_counts/lexer.l | $(BIN) $(BUILD)
	$(FLEX) -o $(BUILD)/p02.c $<
	$(CC) $(CFLAGS) $(BUILD)/p02.c -o $@

$(BIN)/practical03: practical03_a_words_exponents/lexer.l | $(BIN) $(BUILD)
	$(FLEX) -o $(BUILD)/p03.c $<
	$(CC) $(CFLAGS) $(BUILD)/p03.c -o $@

$(BIN)/practical04: practical04_yacc_intro/lexer.l practical04_yacc_intro/parser.y | $(BIN) $(BUILD)
	mkdir -p $(BUILD)/p04
	$(BISON) -d -o $(BUILD)/p04/parser.tab.c practical04_yacc_intro/parser.y
	$(FLEX) -o $(BUILD)/p04/lexer.c practical04_yacc_intro/lexer.l
	$(CC) $(CFLAGS) -I$(BUILD)/p04 $(BUILD)/p04/parser.tab.c $(BUILD)/p04/lexer.c -o $@

$(BIN)/practical05: practical05_case_conversion/lexer.l | $(BIN) $(BUILD)
	$(FLEX) -o $(BUILD)/p05.c $<
	$(CC) $(CFLAGS) $(BUILD)/p05.c -o $@

$(BIN)/practical06: practical06_decimal_hex/lexer.l | $(BIN) $(BUILD)
	$(FLEX) -o $(BUILD)/p06.c $<
	$(CC) $(CFLAGS) $(BUILD)/p06.c -o $@

$(BIN)/practical07: practical07_lines_ending_com/lexer.l | $(BIN) $(BUILD)
	$(FLEX) -o $(BUILD)/p07.c $<
	$(CC) $(CFLAGS) $(BUILD)/p07.c -o $@

$(BIN)/practical08: practical08_postfix_eval/lexer.l practical08_postfix_eval/parser.y | $(BIN) $(BUILD)
	mkdir -p $(BUILD)/p08
	$(BISON) -d -o $(BUILD)/p08/parser.tab.c practical08_postfix_eval/parser.y
	$(FLEX) -o $(BUILD)/p08/lexer.c practical08_postfix_eval/lexer.l
	$(CC) $(CFLAGS) -I$(BUILD)/p08 $(BUILD)/p08/parser.tab.c $(BUILD)/p08/lexer.c -o $@

$(BIN)/practical09: practical09_desk_calculator/lexer.l practical09_desk_calculator/parser.y | $(BIN) $(BUILD)
	mkdir -p $(BUILD)/p09
	$(BISON) -d -o $(BUILD)/p09/parser.tab.c practical09_desk_calculator/parser.y
	$(FLEX) -o $(BUILD)/p09/lexer.c practical09_desk_calculator/lexer.l
	$(CC) $(CFLAGS) -I$(BUILD)/p09 $(BUILD)/p09/parser.tab.c $(BUILD)/p09/lexer.c -o $@

$(BIN)/practical10: practical10_for_parser/lexer.l practical10_for_parser/parser.y | $(BIN) $(BUILD)
	mkdir -p $(BUILD)/p10
	$(BISON) -d -o $(BUILD)/p10/parser.tab.c practical10_for_parser/parser.y
	$(FLEX) -o $(BUILD)/p10/lexer.c practical10_for_parser/lexer.l
	$(CC) $(CFLAGS) -I$(BUILD)/p10 $(BUILD)/p10/parser.tab.c $(BUILD)/p10/lexer.c -o $@

$(BIN)/value_added_icg: value_added_icg/lexer.l value_added_icg/parser.y | $(BIN) $(BUILD)
	mkdir -p $(BUILD)/icg
	$(BISON) -d -o $(BUILD)/icg/parser.tab.c value_added_icg/parser.y
	$(FLEX) -o $(BUILD)/icg/lexer.c value_added_icg/lexer.l
	$(CC) $(CFLAGS) -I$(BUILD)/icg $(BUILD)/icg/parser.tab.c $(BUILD)/icg/lexer.c -o $@

test: all
	bash tests/run-tests.sh

clean:
	rm -rf $(BIN) $(BUILD)
