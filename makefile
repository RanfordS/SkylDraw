SkylDraw : objs/rmath.o objs/fontline.o objs/shadertools.o objs/bezier.o objs/line.o objs/vec.o objs/transform.o objs/buffergen.o objs/main.o objs/luavec.o objs/circle.o objs/init.o objs/font.o objs/lineshader.o objs/arc.o bezier.h shadertools.h transform.h buffergen.h init.h font.h luavec.h vec.h stb_image.h shapes.h lineshader.h rmath.h core.h
	@echo -e '\033[1;36m- Linking SkylDraw -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o SkylDraw objs/rmath.o objs/fontline.o objs/shadertools.o objs/bezier.o objs/line.o objs/vec.o objs/transform.o objs/buffergen.o objs/main.o objs/luavec.o objs/circle.o objs/init.o objs/font.o objs/lineshader.o objs/arc.o -lm -lGL -lGLU -lGLEW -lglfw -llua5.3
	@echo -e '\033[1;4m- Done -\033[0m'

objs/rmath.o : rmath.c vec.h rmath.h core.h
	@echo -e '\033[1;33m- Building rmath.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/rmath.o -c rmath.c

objs/fontline.o : fontline.c shapes.h rmath.h vec.h core.h
	@echo -e '\033[1;33m- Building fontline.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/fontline.o -c fontline.c

objs/shadertools.o : shadertools.c shadertools.h vec.h core.h
	@echo -e '\033[1;33m- Building shadertools.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/shadertools.o -c shadertools.c

objs/bezier.o : bezier.c shapes.h rmath.h vec.h core.h
	@echo -e '\033[1;33m- Building bezier.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/bezier.o -c bezier.c

objs/line.o : line.c vec.h
	@echo -e '\033[1;33m- Building line.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/line.o -c line.c

objs/vec.o : vec.c vec.h
	@echo -e '\033[1;33m- Building vec.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/vec.o -c vec.c

objs/transform.o : transform.c transform.h vec.h
	@echo -e '\033[1;33m- Building transform.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/transform.o -c transform.c

objs/buffergen.o : buffergen.c vec.h rmath.h shapes.h buffergen.h core.h
	@echo -e '\033[1;33m- Building buffergen.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/buffergen.o -c buffergen.c

objs/main.o : main.c transform.h buffergen.h init.h font.h vec.h shapes.h lineshader.h rmath.h core.h
	@echo -e '\033[1;33m- Building main.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/main.o -c main.c

objs/luavec.o : luavec.c luavec.h vec.h core.h
	@echo -e '\033[1;33m- Building luavec.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/luavec.o -c luavec.c

objs/circle.o : circle.c shapes.h rmath.h vec.h core.h
	@echo -e '\033[1;33m- Building circle.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/circle.o -c circle.c

objs/init.o : init.c font.h vec.h core.h stb_image.h init.h
	@echo -e '\033[1;33m- Building init.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/init.o -c init.c

objs/font.o : font.c font.h shadertools.h vec.h init.h stb_image.h core.h
	@echo -e '\033[1;33m- Building font.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/font.o -c font.c

objs/lineshader.o : lineshader.c shadertools.h lineshader.h vec.h core.h
	@echo -e '\033[1;33m- Building lineshader.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/lineshader.o -c lineshader.c

objs/arc.o : arc.c shapes.h rmath.h vec.h core.h
	@echo -e '\033[1;33m- Building arc.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/arc.o -c arc.c

buffergen.c : buffergen.lmc
	@echo -e '\033[1;34m- Generating buffergen.c -\033[0m'
	@lua luamacro.lua buffergen.lmc buffergen.c

luavec.h : luavec.lmh
	@echo -e '\033[1;34m- Generating luavec.h -\033[0m'
	@lua luamacro.lua luavec.lmh luavec.h

vec.h : vec.lmh
	@echo -e '\033[1;34m- Generating vec.h -\033[0m'
	@lua luamacro.lua vec.lmh vec.h

shapes.h : shapes.lmh
	@echo -e '\033[1;34m- Generating shapes.h -\033[0m'
	@lua luamacro.lua shapes.lmh shapes.h

vec.c : vec.lmc
	@echo -e '\033[1;34m- Generating vec.c -\033[0m'
	@lua luamacro.lua vec.lmc vec.c

luavec.c : luavec.lmc
	@echo -e '\033[1;34m- Generating luavec.c -\033[0m'
	@lua luamacro.lua luavec.lmc luavec.c

buffergen.h : buffergen.lmh
	@echo -e '\033[1;34m- Generating buffergen.h -\033[0m'
	@lua luamacro.lua buffergen.lmh buffergen.h

bezier.c : bezier.lmc
	@echo -e '\033[1;34m- Generating bezier.c -\033[0m'
	@lua luamacro.lua bezier.lmc bezier.c

.PHONY : doc
doc : rmath.c fontline.c shadertools.c bezier.c line.c vec.c transform.c buffergen.c main.c luavec.c circle.c init.c font.c lineshader.c arc.c bezier.h shadertools.h transform.h buffergen.h init.h font.h luavec.h vec.h stb_image.h shapes.h lineshader.h rmath.h core.h
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
	@rm -f buffergen.lmc luavec.lmh vec.lmh shapes.lmh vec.lmc luavec.lmc buffergen.lmh bezier.lmc

.PHONY : cleandoc
cleandoc :
	@echo -e '\033[1;35m- Cleaning documentation -\033[0m'
	@rm -f -r doc//*

.PHONY : clean
clean : cleanmacro cleanobjs
	@echo -e '\033[1;35m- Cleaning output -\033[0m'
	@rm -f SkylDraw

