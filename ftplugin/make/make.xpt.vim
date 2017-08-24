XPTemplate priority=lang

let s:f = g:XPTfuncs()

XPTvar $TRUE          1
XPTvar $FALSE         0
XPTvar $NULL          NULL
XPTvar $UNDEFINED     NULL

XPTvar $VOID_LINE  # void
XPTvar $CURSOR_PH      # cursor

XPTvar $CS    #

XPTinclude
      \ _common/common
      \ _comment/singleSign


" ========================= Function and Variables =============================


" ================================= Snippets ===================================

XPT addprefix " $(addprefix ...)
$(addprefix `prefix^, `elemList^)


XPT addsuffix " $(addsuffix ...)
$(addsuffix `suffix^, `elemList^)


XPT filterout " $(filter-out ...)
$(filter-out `toRemove^, `elemList^)


XPT patsubst " $(patsubst ...)
$(patsubst `sourcePattern^%.c^,  `destPattern^%.o^, `list^)


XPT shell " $(shell ...)
$(shell `command^)


XPT subst " $(subst ...)
$(subst `sourceString^, `destString^, `string^)


XPT wildcard " $(wildcard ...)
$(wildcard `globpattern^)


XPT ifneq " ifneq ... else ... endif
ifneq (`what^, `with^)
    `job^
``else...`
{{^else
    `cursor^
`}}^endif


XPT ifeq " ifneq ... else ... endif
XSET job=$CS job
ifeq (`what^, `with^)
    `job^
``else...`
{{^else
    `cursor^
`}}^endif

XPT vars-gmake " special gnu make variables
# $(@F), $(@D), $@  # name of directory,file,of the target  during rule execution
# $<, $\^           # name of first/all prereqisite in rule
# $+                # name of all prerequisites but with duplicates removed
# $?                # name of all prereqisite newer than target, for archive only new mebers
# $|                # name of all order only depencies
# $*                # name of steam(%) matches in rule e.g.
#                   #    for target 'dir/a.foo.b' and the steam 'a.%.b' result is 'dir/foo'.

XPT vars-bmake " special bsd make variables
# bsd make is pmake doc here https://www.freebsd.org/doc/en/books/pmake/index.html
# cwd != pwd        # cwd will hold execution of shell command (pwd) in this case
# ${.TARGET}, $@    # name of  the target  during rule execution
# $(@F), $(@D), $@  # old form name of directory,file,of the target  during rule execution
# ${@:T}, ${@:H}    # same as above :T is last componant of name :H is first component of name
# ${VAR:Mpattern}   # select word matching  pattern (shell wildcard work) from VAR
# ${VAR:Npattern}   # select word not matching  pattern (shell wildcard work) from VAR
# ${VAR:tA}         # attempt to convert VAR to realpath, if don't work lave it alone
# ${VAR:S/old/new/} # subsitue VAR old to new, accepted flags 1, only first replace, g all occurences
# ${VAR:C/old/new/} # subsitue VAR old to new using extended regexp
# $<, $\^           # name of first/all prereqisite in rule
# $+                # name of all prerequisites but with duplicates removed
# $?                # name of all prereqisite newer than target, for archive only new mebers
# $|                # name of all order only depencies
# $*                # name of steam(%) matches in rule e.g.
#                   #    for target 'dir/a.foo.b' and the steam 'a.%.b' result is 'dir/foo'.
XPT basevar " CC ... CFLAG ..
`lang^C^C := `compiler^gcc^
`lang^C^FLAGS := `switches^-Wall -Wextra^


XPT bsd0make
PROG=vg_mem_parse
SRCS=parse-mem-maps.c
MAN=
CFLAGS=-g
.include <bsd.prog.mk>

XPT bsd1make
CC = gcc
CFLAGS = -Wall -Wextra -std=c99
LDFLAGS = -lutil

TARGET := ipc-main
all: $(TARGET)

.SUFFIXES: .c .o
.c.o:
        $(CC) $(CFLAGS) -c $< -o $@

$(TARGET): ipc-main.o
        $(CC) $(LDFLAGS) $(>) -o $@

clean:
        -rm -rf *.o $(TARGET)

XPT gmake0 " tryvial makefile to do it's stuff
.PHONY: all clean
targets:=

CXX_srcs:=$(wildcard *.cpp)
CXX_targets+=$(CXX_srcs:.cpp=)
CXX_objects:=$(CXX_srcs:.cpp=.o)

targets+=$(CXX_targets)

all: $(targets)

CXX_FLAGS:=-Wall -Wextra -pedantic -ggdb
CXX_LDFLAGS:=-Wall -Wextra -pedantic -ggdb

$(CXX_objects): %.o : %.cpp
	$(CXX) -c $(CXX_FLAGS) $< -o $@

$(CXX_targets): % : $(patsubst %,%.o,%)
	$(CXX) $(CXX_LDFLAGS)  -o $@ $<

clean:
	-rm $(targets) $(CXX_objects)

XPT help-variables " some notes on gnu makefile magic variables
# $@                         The file name of the target.
# $<                         The name of the first pre requisite
# $?                         The names of all the prerequisites that are newer than the target,
# $\^  $+                   The names of all the prerequisites, $\^ ommits dupplicate prerequisites $+ preserves the order
# $*                         The name of steam which implicit rule matches( e.g foo bar: %: $* ; $* is either foo or bar)
# $(@D) $(?D) $(\^D) $(+D)
# $(@F) $(?F) $(\^F) $(+F)  The directory part and the file-within-directory part of $@ $< $? $\^ $+
#
# $(val:pattern=replacement)               eg.  $(val:.cpp=.o)
#    Replace all occuences of patter to replacement in variable
#    Equvalent of $(patsubst %.cpp,%.o,$(val))

# $(eval) functions is called twice so $ needs to be escaped in $$
# $(sort) will make list of strings unique (and sorted by the way if you care :)


XPT shell-dbg " Makefile shell debuging
# shell redirectron hack, to explain why building
# OLD_SHELL := $(SHELL)
# SHELL = $(warning Building $@$(if $<, (from $<))$(if $?, ($? newer)))$(OLD_SHELL)

XPT debug-print " simple debug rule for more advanced use DDD
print-%:
    @echo $* = $($*)

XPT printvars  " rule to print all variables declared so far
.PHONY: printvars
printvars:
    @$(foreach V,$(sort $(.VARIABLES)),                   \
        $(if $(filter-out environment% default automatic, \
        $(origin $V)),$(warning $V=$($V) ($(value $V)))))
# declare last or in file printvars.make and then make -f Makefile -f printvars.make printvars

XPT mscMake " msc geneate template
# mscgen makefile template

MSCGEN=$(shell which mscgen)

TYPE:=png
TARGET:=`cursor^

all: $(TARGET).$(TYPE)

$(TARGET).$(TYPE):  $(TARGET).msc
    $(MSCGEN) -T $(TYPE)  -i    $< -o $@

clean:
    -rm $(TARGET).$(TYPE)
