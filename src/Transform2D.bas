#include once "ecs/Entity.bi"
#include once "ecs/Components/Transform2D.bi"

private sub Transform2D_global_register() constructor
    Entity.RegisterComponent("Transform2D", new Transform2D())
end sub