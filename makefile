
# compiler options

LMC   = lua luamacro.lua
CMPLR = gcc
FLAGS = -Wall -Wextra -Og -ggdb
LINKS = -lm -lGL -lGLU -lGLEW -lglfw -llua5.3
OBJDR = objs

# input files

LMCS = vec bezier
LMHS = vec bezier
OBJS = main init font rmath
HDRS = core init font rmath stb_image
TARG = SkylDraw

# extensions

LMCFS = $(addsuffix .lmc, $(LMCS))
LMHFS = $(addsuffix .lmh, $(LMHS))
SRCFS = $(addsuffix .c, $(OBJS) $(LMCS))
HDRFS = $(addsuffix .h, $(HDRS) $(LMHS))
OBJFS = $(addsuffix .o, $(addprefix $(OBJDR)/, $(OBJS) $(LMCS)))

# the magic

$(TARG) : $(OBJFS) $(HDRFS)
	@echo -e '\033[1;36m- Linking -\033[0m'
	@$(CMPLR) $(FLAGS) -o $(TARG) $(OBJFS) $(LINKS)
	@echo -e '\033[1;4m- Done -\033[0m'

$(OBJDR)/%.o : %.c $(HDRFS)
	@echo -e '\033[1;33m- Building $< -\033[0m'
	@$(CMPLR) $(FLAGS) -o $@ -c $<

$(addsuffix .c, $(LMCS)) : $(LMCFS)
	@echo -e '\033[1;34m- Generating $@ -\033[0m'
	@$(LMC) $(subst .c,.lmc,$@) $@

$(addsuffix .h, $(LMHS)) : $(LMHFS)
	@echo -e '\033[1;34m- Generating $@ -\033[0m'
	@$(LMC) $(subst .h,.lmh,$@) $@

# phonys

.PHONY : doc
doc : $(addsuffix .c, $(LMCOBJS)) $(addsuffix .hpp, $(LMCHDRS))
	@echo -e '\033[1;32mDocumenting\033[0m'
	@doxygen doxyfile
	@echo -e '\033[1;4mDone\033[0m'

.PHONY : cleanobjs
cleanobjs :
	@echo -e '\033[1;35mCleaning object files\033[0m'
	@rm -f $(OBJDR)/*

.PHONY : cleanmacro
cleanmacro :
	@echo -e '\033[1;35mCleaning macro files\033[0m'
	@rm -f $(addsuffix .c, $(LMCOBJS)) $(addsuffix .h, $(LMCHDRS))

.PHONY : cleandoc
cleandoc :
	@echo -e '\033[1;35mCleaning documentation\033[0m'
	@rm -f -r doc/*

.PHONY : clean
clean : cleanmacro cleanobjs
	@echo -e '\033[1;35mCleaning output\033[0m'
	@rm -f $(TARG)
