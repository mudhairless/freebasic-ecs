@IF "%fbc%"=="" (
    @echo Please run SET FBC=fbc32 or your preferred compiler first
    @goto :eof
)

@echo Clearing Old Build Files
del src\*.o src\Components\*.o lib\libecs.a lib\libecs-components.a examples\*.exe tests\*.exe

@echo Building Library
%fbc% -i inc -g -w all -exx -c src/Component.bas -o src/Component.o
%fbc% -i inc -g -w all -exx -c src/ComponentRegistry.bas -o src/ComponentRegistry.o
%fbc% -i inc -g -w all -exx -c src/Entity.bas -o src/Entity.o
%fbc% -i inc -g -w all -exx -c src/EntityList.bas -o src/EntityList.o
%fbc% -i inc -g -w all -exx -c src/Application.bas -o src/Application.o
%fbc% -i inc -g -w all -exx -c src/Resource.bas -o src/Resource.o
%fbc% -i inc -g -w all -exx -c src/Systems.bas -o src/Systems.o
%fbc% -i inc -g -w all -exx -c src/Events.bas -o src/Events.o
%fbc% -i inc -g -w all -exx -c src/GenericList.bas -o src/GenericList.o
%fbc% -lib -x lib/libecs.a src/Component.o src/ComponentRegistry.o src/Entity.o src/EntityList.o src/Application.o src/Resource.o src/Systems.o src/Events.o src/GenericList.o
%fbc% -i inc -g -w all -exx -c src/Components/Transform2D.bas -o src/Components/Transform2D.o
%fbc% -i inc -g -w all -exx -c src/Components/BoxCollider2D.bas -o src/Components/BoxCollider2D.o
%fbc% -i inc -g -w all -exx -c src/Components/Sprite.bas -o src/Components/Sprite.o
%fbc% -lib -x lib/libecs-components.a src/Components/Transform2D.o src/Components/BoxCollider2D.o src/Components/Sprite.o

@echo Building examples
%fbc% -i inc -g -w all -exx -p lib examples/simple.bas

@echo Building tests
%fbc% -i inc -g -w all -exx -p lib tests/TestComponentRegistry.bas
%fbc% -i inc -g -w all -exx -p lib tests/TestGenericList.bas
%fbc% -i inc -g -w all -exx -p lib tests/TestEntityList.bas

@echo -----
@echo Build Complete, running tests
@echo -----
@tests\TestComponentRegistry.exe
@tests\TestGenericList.exe
@tests\TestEntityList.exe
@echo -----
