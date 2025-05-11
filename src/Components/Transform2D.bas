#include once "ecs/Entity.bi"
#include once "ecs/Component.bi"
#include once "ecs/Components/Transform2D.bi"
#include once "ecs/Application.bi"

private function ecs_transform2d_component_create() as Component ptr
    var x = new Transform2D()
    x->cname = "Transform2D"
    return x
end function

private sub Transform2D_global_register() constructor
    Application.GetInstance()->component_registry->RegisterComponent("Transform2D", @ecs_transform2d_component_create)
end sub

