COMPILER = fbc
COMPILE_OPTS = -i inc -g -w all
LINK_OPTS = -lib

all: lib/libecs.a lib/libecs-components.a

%.o: %.bas
	$(COMPILER) $(COMPILE_OPTS) -c $< -o $@

lib/libecs-components.a: src/Components/Transform2D.o
	$(COMPILER) $(LINK_OPTS) -x lib/libecs-components.a src/Components/Transform2D.o

lib/libecs.a: src/Component.o src/ComponentRegistry.o src/Entity.o src/EntityList.o src/Application.o src/Resource.o
	$(COMPILER) $(LINK_OPTS) -x lib/libecs.a src/Component.o src/ComponentRegistry.o src/Entity.o src/EntityList.o src/Application.o src/Resource.o

clean:
	rm src/*.o src/Components/*.o lib/libecs.a lib/libecs-components.a

.PHONY: clean
