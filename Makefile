COMPILER = fbc
COMPILE_OPTS = -i inc -g -w all -exx
LINK_OPTS = -lib

all: lib/libecs.a lib/libecs-components.a examples

%.o: %.bas
	$(COMPILER) $(COMPILE_OPTS) -c $< -o $@

examples: examples/simple.exe

examples/simple.exe: lib/libecs.a examples/simple.bas
	$(COMPILER) $(COMPILE_OPTS) -p lib examples/simple.bas

lib/libecs-components.a: src/Components/Transform2D.o
	$(COMPILER) $(LINK_OPTS) -x lib/libecs-components.a src/Components/Transform2D.o

lib/libecs.a: src/Component.o src/ComponentRegistry.o src/Entity.o src/EntityList.o src/Application.o src/Resource.o src/Systems.o src/Events.o
	$(COMPILER) $(LINK_OPTS) -x lib/libecs.a src/Component.o src/ComponentRegistry.o src/Entity.o src/EntityList.o src/Application.o src/Resource.o src/Systems.o src/Events.o

clean:
	rm src/*.o src/Components/*.o lib/libecs.a lib/libecs-components.a examples/*.exe

.PHONY: clean
