#include once "ecs/Entity.bi"
#include once "ecs/Components/Transform2D.bi"

'#include once "ecs/Application.bi"
'private sub Transform2D_global_register() constructor
'    Application.GetInstance()->RegisterComponent("Transform2D", new Transform2D())
'end sub

public constructor Transform2D()
    Base("Transform2D")
end constructor

public function ecs_transform2d_component_create() as Component ptr
    var x = new Transform2D()
    return cast(Component ptr, x)
end function