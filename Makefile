COMPILER = fbc
COMPILE_OPTS = -i inc -g -w all -exx
LINK_OPTS = -lib

all: lib/libecs.a lib/libecs-components.a examples tests

%.o: %.bas
	$(COMPILER) $(COMPILE_OPTS) -c $< -o $@

tests: tests/TestComponentRegistry.exe tests/TestGenericList.exe

tests/TestComponentRegistry.exe: lib/libecs.a tests/TestComponentRegistry.bas src/ComponentRegistry.o
	$(COMPILER) $(COMPILE_OPTS) -p lib tests/TestComponentRegistry.bas
	tests/TestComponentRegistry

tests/TestGenericList.exe: lib/libecs.a tests/TestGenericList.bas src/GenericList.o
	$(COMPILER) $(COMPILE_OPTS) -p lib tests/TestGenericList.bas
	tests/TestGenericList

examples: examples/simple.exe

examples/simple.exe: lib/libecs.a examples/simple.bas
	$(COMPILER) $(COMPILE_OPTS) -p lib examples/simple.bas

lib/libecs-components.a: src/Components/Transform2D.o
	$(COMPILER) $(LINK_OPTS) -x lib/libecs-components.a src/Components/Transform2D.o

lib/libecs.a: src/Component.o src/ComponentRegistry.o src/Entity.o src/EntityList.o src/Application.o src/Resource.o src/Systems.o src/Events.o src/GenericList.o
	$(COMPILER) $(LINK_OPTS) -x lib/libecs.a src/Component.o src/ComponentRegistry.o src/Entity.o src/EntityList.o src/Application.o src/Resource.o src/Systems.o src/Events.o src/GenericList.o

clean:
	rm src/*.o src/Components/*.o lib/libecs.a lib/libecs-components.a examples/*.exe tests/*.exe

.PHONY: clean
