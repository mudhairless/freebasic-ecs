#ifndef _FB_ECS_TRANSFORM_BI__
#define _FB_ECS_TRANSFORM_BI__ 1

#include once "ecs/Component.bi"

type Transform2D extends Component
    as single x, y

    declare constructor()
    declare function create(byref cname as const string) as Component ptr override
end type

#endif