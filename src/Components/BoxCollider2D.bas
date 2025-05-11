#include once "ecs/Entity.bi"
#include once "ecs/Component.bi"
#include once "ecs/Components/BoxCollider2D.bi"
#include once "ecs/Application.bi"

private function ecs_box2dcollider_component_create() as Component ptr
    var x = new BoxCollider2D()
    x->cname = "BoxCollider2D"
    x->_requires(0) = "Transform2D"
    return x
end function

private sub BoxCollider2D_global_register() constructor
    Application.GetInstance()->component_registry->RegisterComponent("BoxCollider2D", @ecs_box2dcollider_component_create)
end sub

