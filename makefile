SkylDraw : objs/circle.o objs/init.o objs/vec.o objs/bezier.o objs/lineshader.o objs/shadertools.o objs/fontline.o objs/transform.o objs/rmath.o objs/font.o objs/luavec.o objs/arc.o objs/line.o objs/buffergen.o objs/main.o vec.h bezier.h core.h buffergen.h transform.h shapes.h rmath.h init.h shadertools.h stb_image.h lineshader.h font.h
	@echo -e '\033[1;36m- Linking SkylDraw -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o SkylDraw objs/circle.o objs/init.o objs/vec.o objs/bezier.o objs/lineshader.o objs/shadertools.o objs/fontline.o objs/transform.o objs/rmath.o objs/font.o objs/luavec.o objs/arc.o objs/line.o objs/buffergen.o objs/main.o -lm -lGL -lGLU -lGLEW -lglfw -llua5.3
	@echo -e '\033[1;4m- Done -\033[0m'

objs/circle.o : circle.c vec.h shapes.h core.h rmath.h
	@echo -e '\033[1;33m- Building circle.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/circle.o -c circle.c

objs/init.o : init.c font.h core.h init.h stb_image.h vec.h
	@echo -e '\033[1;33m- Building init.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/init.o -c init.c

objs/vec.o : vec.c vec.h
	@echo -e '\033[1;33m- Building vec.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/vec.o -c vec.c

objs/bezier.o : bezier.c vec.h shapes.h core.h rmath.h
	@echo -e '\033[1;33m- Building bezier.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/bezier.o -c bezier.c

objs/lineshader.o : lineshader.c vec.h shadertools.h core.h lineshader.h
	@echo -e '\033[1;33m- Building lineshader.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/lineshader.o -c lineshader.c

objs/shadertools.o : shadertools.c shadertools.h core.h vec.h
	@echo -e '\033[1;33m- Building shadertools.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/shadertools.o -c shadertools.c

objs/fontline.o : fontline.c vec.h shapes.h core.h rmath.h
	@echo -e '\033[1;33m- Building fontline.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/fontline.o -c fontline.c

objs/transform.o : transform.c transform.h vec.h
	@echo -e '\033[1;33m- Building transform.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/transform.o -c transform.c

objs/rmath.o : rmath.c rmath.h core.h vec.h
	@echo -e '\033[1;33m- Building rmath.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/rmath.o -c rmath.c

objs/font.o : font.c vec.h core.h init.h shadertools.h stb_image.h font.h
	@echo -e '\033[1;33m- Building font.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/font.o -c font.c

objs/luavec.o : luavec.c core.h vec.h
	@echo -e '\033[1;33m- Building luavec.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/luavec.o -c luavec.c

objs/arc.o : arc.c vec.h shapes.h core.h rmath.h
	@echo -e '\033[1;33m- Building arc.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/arc.o -c arc.c

objs/line.o : line.c vec.h
	@echo -e '\033[1;33m- Building line.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/line.o -c line.c

objs/buffergen.o : buffergen.c vec.h core.h buffergen.h shapes.h rmath.h
	@echo -e '\033[1;33m- Building buffergen.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/buffergen.o -c buffergen.c

objs/main.o : main.c vec.h core.h buffergen.h transform.h shapes.h rmath.h init.h lineshader.h font.h
	@echo -e '\033[1;33m- Building main.c -\033[0m'
	@gcc -Wall -Wextra -Og -ggdb -o objs/main.o -c main.c

buffergen.c : buffergen.lmc
	@echo -e '\033[1;34m- Generating buffergen.c -\033[0m'
	@lua luamacro.lua buffergen.lmc buffergen.c

buffergen.h : buffergen.lmh
	@echo -e '\033[1;34m- Generating buffergen.h -\033[0m'
	@lua luamacro.lua buffergen.lmh buffergen.h

bezier.c : bezier.lmc
	@echo -e '\033[1;34m- Generating bezier.c -\033[0m'
	@lua luamacro.lua bezier.lmc bezier.c

vec.c : vec.lmc
	@echo -e '\033[1;34m- Generating vec.c -\033[0m'
	@lua luamacro.lua vec.lmc vec.c

luavec.c : luavec.lmc
	@echo -e '\033[1;34m- Generating luavec.c -\033[0m'
	@lua luamacro.lua luavec.lmc luavec.c

vec.h : vec.lmh
	@echo -e '\033[1;34m- Generating vec.h -\033[0m'
	@lua luamacro.lua vec.lmh vec.h

shapes.h : shapes.lmh
	@echo -e '\033[1;34m- Generating shapes.h -\033[0m'
	@lua luamacro.lua shapes.lmh shapes.h

.PHONY : doc
doc : circle.c init.c vec.c bezier.c lineshader.c shadertools.c fontline.c transform.c rmath.c font.c luavec.c arc.c line.c buffergen.c main.c vec.h bezier.h core.h buffergen.h transform.h shapes.h rmath.h init.h shadertools.h stb_image.h lineshader.h font.h
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
	@rm -f buffergen.lmc buffergen.lmh bezier.lmc vec.lmc luavec.lmc vec.lmh shapes.lmh

.PHONY : cleandoc
cleandoc :
	@echo -e '\033[1;35m- Cleaning documentation -\033[0m'
	@rm -f -r doc//*

.PHONY : clean
clean : cleanmacro cleanobjs
	@echo -e '\033[1;35m- Cleaning output -\033[0m'
	@rm -f SkylDraw

