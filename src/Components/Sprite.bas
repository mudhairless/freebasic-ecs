#include once "ecs/Entity.bi"
#include once "ecs/Component.bi"
#include once "ecs/Components/Sprite.bi"
#include once "ecs/Application.bi"

private function ecs_sprite_component_create() as Component ptr
    var x = new Sprite()
    x->cname = "Sprite"
    x->_requires(0) = "Transform2D"
    return x
end function

public destructor Sprite()
    if (this.free_function) then
        this.free_function(this.image)
    end if
end destructor

private sub Sprite_global_register() constructor
    Application.GetInstance()->component_registry->RegisterComponent("Sprite", @ecs_sprite_component_create)
end sub