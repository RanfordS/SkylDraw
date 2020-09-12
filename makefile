SkylDraw : objs/transform.o objs/vec.o objs/shadertools.o objs/arc.o objs/bezier.o objs/buffergen.o objs/main.o objs/rmath.o objs/lineshader.o objs/init.o objs/fontline.o objs/font.o objs/circle.o rmath.h shadertools.h buffergen.h init.h stb_image.h vec.h transform.h lineshader.h font.h shapes.h core.h bezier.h
	@echo -e '\033[1;36m- Linking SkylDraw -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o SkylDraw objs/transform.o objs/vec.o objs/shadertools.o objs/arc.o objs/bezier.o objs/buffergen.o objs/main.o objs/rmath.o objs/lineshader.o objs/init.o objs/fontline.o objs/font.o objs/circle.o -lm -lGL -lGLU -lGLEW -lglfw -llua5.3
	@echo -e '\033[1;4m- Done -\033[0m'

objs/transform.o : transform.c transform.h vec.h
	@echo -e '\033[1;33m- Building transform.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/transform.o -c transform.c

objs/vec.o : vec.c vec.h
	@echo -e '\033[1;33m- Building vec.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/vec.o -c vec.c

objs/shadertools.o : shadertools.c shadertools.h core.h vec.h
	@echo -e '\033[1;33m- Building shadertools.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/shadertools.o -c shadertools.c

objs/arc.o : arc.c vec.h rmath.h core.h shapes.h
	@echo -e '\033[1;33m- Building arc.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/arc.o -c arc.c

objs/bezier.o : bezier.c vec.h rmath.h core.h shapes.h
	@echo -e '\033[1;33m- Building bezier.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/bezier.o -c bezier.c

objs/buffergen.o : buffergen.c shapes.h rmath.h buffergen.h core.h vec.h
	@echo -e '\033[1;33m- Building buffergen.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/buffergen.o -c buffergen.c

objs/main.o : main.c shapes.h buffergen.h vec.h transform.h lineshader.h font.h rmath.h core.h init.h
	@echo -e '\033[1;33m- Building main.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/main.o -c main.c

objs/rmath.o : rmath.c vec.h core.h rmath.h
	@echo -e '\033[1;33m- Building rmath.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/rmath.o -c rmath.c

objs/lineshader.o : lineshader.c vec.h shadertools.h core.h lineshader.h
	@echo -e '\033[1;33m- Building lineshader.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/lineshader.o -c lineshader.c

objs/init.o : init.c stb_image.h font.h vec.h core.h init.h
	@echo -e '\033[1;33m- Building init.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/init.o -c init.c

objs/fontline.o : fontline.c vec.h rmath.h core.h shapes.h
	@echo -e '\033[1;33m- Building fontline.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/fontline.o -c fontline.c

objs/font.o : font.c stb_image.h init.h font.h shadertools.h core.h vec.h
	@echo -e '\033[1;33m- Building font.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/font.o -c font.c

objs/circle.o : circle.c vec.h rmath.h core.h shapes.h
	@echo -e '\033[1;33m- Building circle.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/circle.o -c circle.c

shapes.h : shapes.lmh
	@echo -e '\033[1;34m- Generating shapes.h -\033[0m'
	@lua luamacro.lua shapes.lmh shapes.h

vec.h : vec.lmh
	@echo -e '\033[1;34m- Generating vec.h -\033[0m'
	@lua luamacro.lua vec.lmh vec.h

vec.c : vec.lmc
	@echo -e '\033[1;34m- Generating vec.c -\033[0m'
	@lua luamacro.lua vec.lmc vec.c

buffergen.c : buffergen.lmc
	@echo -e '\033[1;34m- Generating buffergen.c -\033[0m'
	@lua luamacro.lua buffergen.lmc buffergen.c

buffergen.h : buffergen.lmh
	@echo -e '\033[1;34m- Generating buffergen.h -\033[0m'
	@lua luamacro.lua buffergen.lmh buffergen.h

bezier.c : bezier.lmc
	@echo -e '\033[1;34m- Generating bezier.c -\033[0m'
	@lua luamacro.lua bezier.lmc bezier.c

.PHONY : doc
doc : transform.c vec.c shadertools.c arc.c bezier.c buffergen.c main.c rmath.c lineshader.c init.c fontline.c font.c circle.c rmath.h shadertools.h buffergen.h init.h stb_image.h vec.h transform.h lineshader.h font.h shapes.h core.h bezier.h
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
	@rm -f shapes.lmh vec.lmh vec.lmc buffergen.lmc buffergen.lmh bezier.lmc

.PHONY : cleandoc
cleandoc :
	@echo -e '\033[1;35m- Cleaning documentation -\033[0m'
	@rm -f -r doc//*

.PHONY : clean
clean : cleanmacro cleanobjs
	@echo -e '\033[1;35m- Cleaning output -\033[0m'
	@rm -f SkylDraw

