del src\*.o src\Components\*.o lib\libecs.a lib\libecs-components.a examples\*.exe tests\*.exe
@echo Build Files Removed, break to finish or any key to run build
@pause
fbc -i inc -g -w all -exx -c src/Component.bas -o src/Component.o
fbc -i inc -g -w all -exx -c src/ComponentRegistry.bas -o src/ComponentRegistry.o
fbc -i inc -g -w all -exx -c src/Entity.bas -o src/Entity.o
fbc -i inc -g -w all -exx -c src/EntityList.bas -o src/EntityList.o
fbc -i inc -g -w all -exx -c src/Application.bas -o src/Application.o
fbc -i inc -g -w all -exx -c src/Resource.bas -o src/Resource.o
fbc -i inc -g -w all -exx -c src/Systems.bas -o src/Systems.o
fbc -i inc -g -w all -exx -c src/Events.bas -o src/Events.o
fbc -lib -x lib/libecs.a src/Component.o src/ComponentRegistry.o src/Entity.o src/EntityList.o src/Application.o src/Resource.o src/Systems.o src/Events.o
fbc -i inc -g -w all -exx -c src/Components/Transform2D.bas -o src/Components/Transform2D.o
fbc -lib -x lib/libecs-components.a src/Components/Transform2D.o
fbc -i inc -g -w all -exx -p lib examples/simple.bas
fbc -i inc -g -w all -exx -p lib tests/TestComponentRegistry.bas
@echo -----
@echo Build Complete, running tests
@echo -----
@tests\TestComponentRegistry.exe
@echo -----
@pause