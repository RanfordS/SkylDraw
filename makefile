SkylDraw : objs/fontline.o objs/buffergen.o objs/bezier.o objs/vec.o objs/init.o objs/circle.o objs/rmath.o objs/lineshader.o objs/main.o objs/font.o objs/arc.o objs/shadertools.o shapes.h rmath.h core.h stb_image.h font.h init.h buffergen.h bezier.h shadertools.h lineshader.h vec.h
	@echo -e '\033[1;36m- Linking SkylDraw -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o SkylDraw objs/fontline.o objs/buffergen.o objs/bezier.o objs/vec.o objs/init.o objs/circle.o objs/rmath.o objs/lineshader.o objs/main.o objs/font.o objs/arc.o objs/shadertools.o -lm -lGL -lGLU -lGLEW -lglfw -llua5.3
	@echo -e '\033[1;4m- Done -\033[0m'

objs/fontline.o : fontline.c vec.h shapes.h rmath.h core.h
	@echo -e '\033[1;33m- Building fontline.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/fontline.o -c fontline.c

objs/buffergen.o : buffergen.c vec.h buffergen.h core.h rmath.h shapes.h
	@echo -e '\033[1;33m- Building buffergen.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/buffergen.o -c buffergen.c

objs/bezier.o : bezier.c vec.h shapes.h rmath.h core.h
	@echo -e '\033[1;33m- Building bezier.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/bezier.o -c bezier.c

objs/vec.o : vec.c vec.h
	@echo -e '\033[1;33m- Building vec.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/vec.o -c vec.c

objs/init.o : init.c init.h vec.h core.h stb_image.h font.h
	@echo -e '\033[1;33m- Building init.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/init.o -c init.c

objs/circle.o : circle.c vec.h shapes.h rmath.h core.h
	@echo -e '\033[1;33m- Building circle.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/circle.o -c circle.c

objs/rmath.o : rmath.c vec.h rmath.h core.h
	@echo -e '\033[1;33m- Building rmath.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/rmath.o -c rmath.c

objs/lineshader.o : lineshader.c shadertools.h vec.h lineshader.h core.h
	@echo -e '\033[1;33m- Building lineshader.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/lineshader.o -c lineshader.c

objs/main.o : main.c init.h vec.h buffergen.h core.h rmath.h shapes.h lineshader.h font.h
	@echo -e '\033[1;33m- Building main.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/main.o -c main.c

objs/font.o : font.c init.h vec.h core.h stb_image.h shadertools.h font.h
	@echo -e '\033[1;33m- Building font.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/font.o -c font.c

objs/arc.o : arc.c vec.h shapes.h rmath.h core.h
	@echo -e '\033[1;33m- Building arc.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/arc.o -c arc.c

objs/shadertools.o : shadertools.c shadertools.h vec.h core.h
	@echo -e '\033[1;33m- Building shadertools.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/shadertools.o -c shadertools.c

shapes.h : shapes.lmh
	@echo -e '\033[1;34m- Generating shapes.h -\033[0m'
	@lua luamacro.lua shapes.lmh shapes.h

vec.h : vec.lmh
	@echo -e '\033[1;34m- Generating vec.h -\033[0m'
	@lua luamacro.lua vec.lmh vec.h

buffergen.c : buffergen.lmc
	@echo -e '\033[1;34m- Generating buffergen.c -\033[0m'
	@lua luamacro.lua buffergen.lmc buffergen.c

bezier.c : bezier.lmc
	@echo -e '\033[1;34m- Generating bezier.c -\033[0m'
	@lua luamacro.lua bezier.lmc bezier.c

vec.c : vec.lmc
	@echo -e '\033[1;34m- Generating vec.c -\033[0m'
	@lua luamacro.lua vec.lmc vec.c

buffergen.h : buffergen.lmh
	@echo -e '\033[1;34m- Generating buffergen.h -\033[0m'
	@lua luamacro.lua buffergen.lmh buffergen.h

.PHONY : doc
doc : fontline.c buffergen.c bezier.c vec.c init.c circle.c rmath.c lineshader.c main.c font.c arc.c shadertools.c shapes.h rmath.h core.h stb_image.h font.h init.h buffergen.h bezier.h shadertools.h lineshader.h vec.h
	@echo -e '\033[1;32m- Documenting -\033[0m'
	@doxygen doxyfile
	@echo -e '\033[1;4m- Done -\033[0m'

.PHONY : cleanobjs
cleanobjs :
	@echo -e '\033[1;35m- Cleaning object files -\033[0m'
	@rm -f objs/*

.PHONY : cleanmacro
cleanmacro :
	@echo -e '\033[1;35m- Cleaning macro files -\033[0m'
	@rm -f shapes.lmh vec.lmh buffergen.lmc bezier.lmc vec.lmc buffergen.lmh

.PHONY : cleandoc
cleandoc :
	@echo -e '\033[1;35m- Cleaning documentation -\033[0m'
	@rm -f -r doc//*

.PHONY : clean
clean : cleanmacro cleanobjs
	@echo -e '\033[1;35m- Cleaning output -\033[0m'
	@rm -f SkylDraw

