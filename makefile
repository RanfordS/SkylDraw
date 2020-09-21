SkylDraw : objs/circle.o objs/line.o objs/vec.o objs/transform.o objs/shadertools.o objs/rmath.o objs/font.o objs/init.o objs/main.o objs/buffergen.o objs/luavec.o objs/luashapes.o objs/bezier.o objs/lineshader.o objs/fontline.o objs/arc.o font.h init.h luavec.h bezier.h lineshader.h rmath.h vec.h stb_image.h core.h transform.h shapes.h shadertools.h buffergen.h
	@echo -e '\033[1;36m- Linking SkylDraw -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o SkylDraw objs/circle.o objs/line.o objs/vec.o objs/transform.o objs/shadertools.o objs/rmath.o objs/font.o objs/init.o objs/main.o objs/buffergen.o objs/luavec.o objs/luashapes.o objs/bezier.o objs/lineshader.o objs/fontline.o objs/arc.o -lm -lGL -lGLU -lGLEW -lglfw -llua5.3
	@echo -e '\033[1;4m- Done -\033[0m'

objs/circle.o : circle.c rmath.h core.h vec.h shapes.h
	@echo -e '\033[1;33m- Building circle.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/circle.o -c circle.c

objs/line.o : line.c vec.h
	@echo -e '\033[1;33m- Building line.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/line.o -c line.c

objs/vec.o : vec.c vec.h
	@echo -e '\033[1;33m- Building vec.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/vec.o -c vec.c

objs/transform.o : transform.c transform.h vec.h
	@echo -e '\033[1;33m- Building transform.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/transform.o -c transform.c

objs/shadertools.o : shadertools.c vec.h shadertools.h core.h
	@echo -e '\033[1;33m- Building shadertools.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/shadertools.o -c shadertools.c

objs/rmath.o : rmath.c rmath.h vec.h core.h
	@echo -e '\033[1;33m- Building rmath.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/rmath.o -c rmath.c

objs/font.o : font.c font.h core.h shadertools.h stb_image.h vec.h init.h
	@echo -e '\033[1;33m- Building font.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/font.o -c font.c

objs/init.o : init.c font.h init.h stb_image.h vec.h core.h
	@echo -e '\033[1;33m- Building init.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/init.o -c init.c

objs/main.o : main.c font.h init.h luavec.h vec.h rmath.h core.h transform.h shapes.h lineshader.h buffergen.h
	@echo -e '\033[1;33m- Building main.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/main.o -c main.c

objs/buffergen.o : buffergen.c rmath.h core.h shapes.h vec.h buffergen.h
	@echo -e '\033[1;33m- Building buffergen.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/buffergen.o -c buffergen.c

objs/luavec.o : luavec.c luavec.h vec.h core.h
	@echo -e '\033[1;33m- Building luavec.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/luavec.o -c luavec.c

objs/luashapes.o : luashapes.c rmath.h core.h luavec.h vec.h shapes.h
	@echo -e '\033[1;33m- Building luashapes.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/luashapes.o -c luashapes.c

objs/bezier.o : bezier.c rmath.h core.h vec.h shapes.h
	@echo -e '\033[1;33m- Building bezier.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/bezier.o -c bezier.c

objs/lineshader.o : lineshader.c shadertools.h vec.h lineshader.h core.h
	@echo -e '\033[1;33m- Building lineshader.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/lineshader.o -c lineshader.c

objs/fontline.o : fontline.c rmath.h core.h vec.h shapes.h
	@echo -e '\033[1;33m- Building fontline.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/fontline.o -c fontline.c

objs/arc.o : arc.c rmath.h core.h vec.h shapes.h
	@echo -e '\033[1;33m- Building arc.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/arc.o -c arc.c

luavec.c : luavec.lmc
	@echo -e '\033[1;34m- Generating luavec.c -\033[0m'
	@lua luamacro.lua luavec.lmc luavec.c

buffergen.h : buffergen.lmh
	@echo -e '\033[1;34m- Generating buffergen.h -\033[0m'
	@lua luamacro.lua buffergen.lmh buffergen.h

vec.c : vec.lmc
	@echo -e '\033[1;34m- Generating vec.c -\033[0m'
	@lua luamacro.lua vec.lmc vec.c

luashapes.c : luashapes.lmc
	@echo -e '\033[1;34m- Generating luashapes.c -\033[0m'
	@lua luamacro.lua luashapes.lmc luashapes.c

shapes.h : shapes.lmh
	@echo -e '\033[1;34m- Generating shapes.h -\033[0m'
	@lua luamacro.lua shapes.lmh shapes.h

buffergen.c : buffergen.lmc
	@echo -e '\033[1;34m- Generating buffergen.c -\033[0m'
	@lua luamacro.lua buffergen.lmc buffergen.c

vec.h : vec.lmh
	@echo -e '\033[1;34m- Generating vec.h -\033[0m'
	@lua luamacro.lua vec.lmh vec.h

luavec.h : luavec.lmh
	@echo -e '\033[1;34m- Generating luavec.h -\033[0m'
	@lua luamacro.lua luavec.lmh luavec.h

bezier.c : bezier.lmc
	@echo -e '\033[1;34m- Generating bezier.c -\033[0m'
	@lua luamacro.lua bezier.lmc bezier.c

.PHONY : doc
doc : circle.c line.c vec.c transform.c shadertools.c rmath.c font.c init.c main.c buffergen.c luavec.c luashapes.c bezier.c lineshader.c fontline.c arc.c font.h init.h luavec.h bezier.h lineshader.h rmath.h vec.h stb_image.h core.h transform.h shapes.h shadertools.h buffergen.h
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
	@rm -f luavec.lmc buffergen.lmh vec.lmc luashapes.lmc shapes.lmh buffergen.lmc vec.lmh luavec.lmh bezier.lmc

.PHONY : cleandoc
cleandoc :
	@echo -e '\033[1;35m- Cleaning documentation -\033[0m'
	@rm -f -r doc//*

.PHONY : clean
clean : cleanmacro cleanobjs
	@echo -e '\033[1;35m- Cleaning output -\033[0m'
	@rm -f SkylDraw

