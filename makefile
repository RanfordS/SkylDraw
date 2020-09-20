SkylDraw : objs/fontline.o objs/luashapes.o objs/vec.o objs/font.o objs/main.o objs/shadertools.o objs/circle.o objs/luavec.o objs/bezier.o objs/init.o objs/rmath.o objs/arc.o objs/lineshader.o objs/line.o objs/transform.o objs/buffergen.o rmath.h shadertools.h transform.h lineshader.h bezier.h core.h init.h luavec.h stb_image.h vec.h shapes.h buffergen.h font.h
	@echo -e '\033[1;36m- Linking SkylDraw -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o SkylDraw objs/fontline.o objs/luashapes.o objs/vec.o objs/font.o objs/main.o objs/shadertools.o objs/circle.o objs/luavec.o objs/bezier.o objs/init.o objs/rmath.o objs/arc.o objs/lineshader.o objs/line.o objs/transform.o objs/buffergen.o -lm -lGL -lGLU -lGLEW -lglfw -llua5.3
	@echo -e '\033[1;4m- Done -\033[0m'

objs/fontline.o : fontline.c shapes.h vec.h core.h rmath.h
	@echo -e '\033[1;33m- Building fontline.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/fontline.o -c fontline.c

objs/luashapes.o : luashapes.c shapes.h luavec.h vec.h rmath.h core.h
	@echo -e '\033[1;33m- Building luashapes.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/luashapes.o -c luashapes.c

objs/vec.o : vec.c vec.h
	@echo -e '\033[1;33m- Building vec.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/vec.o -c vec.c

objs/font.o : font.c core.h init.h stb_image.h vec.h font.h shadertools.h
	@echo -e '\033[1;33m- Building font.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/font.o -c font.c

objs/main.o : main.c shapes.h transform.h lineshader.h font.h core.h buffergen.h luavec.h init.h rmath.h vec.h
	@echo -e '\033[1;33m- Building main.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/main.o -c main.c

objs/shadertools.o : shadertools.c core.h shadertools.h vec.h
	@echo -e '\033[1;33m- Building shadertools.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/shadertools.o -c shadertools.c

objs/circle.o : circle.c shapes.h vec.h core.h rmath.h
	@echo -e '\033[1;33m- Building circle.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/circle.o -c circle.c

objs/luavec.o : luavec.c core.h vec.h luavec.h
	@echo -e '\033[1;33m- Building luavec.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/luavec.o -c luavec.c

objs/bezier.o : bezier.c shapes.h vec.h core.h rmath.h
	@echo -e '\033[1;33m- Building bezier.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/bezier.o -c bezier.c

objs/init.o : init.c core.h init.h stb_image.h vec.h font.h
	@echo -e '\033[1;33m- Building init.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/init.o -c init.c

objs/rmath.o : rmath.c core.h vec.h rmath.h
	@echo -e '\033[1;33m- Building rmath.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/rmath.o -c rmath.c

objs/arc.o : arc.c shapes.h vec.h core.h rmath.h
	@echo -e '\033[1;33m- Building arc.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/arc.o -c arc.c

objs/lineshader.o : lineshader.c core.h lineshader.h shadertools.h vec.h
	@echo -e '\033[1;33m- Building lineshader.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/lineshader.o -c lineshader.c

objs/line.o : line.c vec.h
	@echo -e '\033[1;33m- Building line.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/line.o -c line.c

objs/transform.o : transform.c vec.h transform.h
	@echo -e '\033[1;33m- Building transform.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/transform.o -c transform.c

objs/buffergen.o : buffergen.c shapes.h buffergen.h vec.h rmath.h core.h
	@echo -e '\033[1;33m- Building buffergen.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/buffergen.o -c buffergen.c

buffergen.c : buffergen.lmc
	@echo -e '\033[1;34m- Generating buffergen.c -\033[0m'
	@lua luamacro.lua buffergen.lmc buffergen.c

luashapes.c : luashapes.lmc
	@echo -e '\033[1;34m- Generating luashapes.c -\033[0m'
	@lua luamacro.lua luashapes.lmc luashapes.c

shapes.h : shapes.lmh
	@echo -e '\033[1;34m- Generating shapes.h -\033[0m'
	@lua luamacro.lua shapes.lmh shapes.h

buffergen.h : buffergen.lmh
	@echo -e '\033[1;34m- Generating buffergen.h -\033[0m'
	@lua luamacro.lua buffergen.lmh buffergen.h

vec.c : vec.lmc
	@echo -e '\033[1;34m- Generating vec.c -\033[0m'
	@lua luamacro.lua vec.lmc vec.c

luavec.c : luavec.lmc
	@echo -e '\033[1;34m- Generating luavec.c -\033[0m'
	@lua luamacro.lua luavec.lmc luavec.c

bezier.c : bezier.lmc
	@echo -e '\033[1;34m- Generating bezier.c -\033[0m'
	@lua luamacro.lua bezier.lmc bezier.c

vec.h : vec.lmh
	@echo -e '\033[1;34m- Generating vec.h -\033[0m'
	@lua luamacro.lua vec.lmh vec.h

luavec.h : luavec.lmh
	@echo -e '\033[1;34m- Generating luavec.h -\033[0m'
	@lua luamacro.lua luavec.lmh luavec.h

.PHONY : doc
doc : fontline.c luashapes.c vec.c font.c main.c shadertools.c circle.c luavec.c bezier.c init.c rmath.c arc.c lineshader.c line.c transform.c buffergen.c rmath.h shadertools.h transform.h lineshader.h bezier.h core.h init.h luavec.h stb_image.h vec.h shapes.h buffergen.h font.h
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
	@rm -f buffergen.lmc luashapes.lmc shapes.lmh buffergen.lmh vec.lmc luavec.lmc bezier.lmc vec.lmh luavec.lmh

.PHONY : cleandoc
cleandoc :
	@echo -e '\033[1;35m- Cleaning documentation -\033[0m'
	@rm -f -r doc//*

.PHONY : clean
clean : cleanmacro cleanobjs
	@echo -e '\033[1;35m- Cleaning output -\033[0m'
	@rm -f SkylDraw

