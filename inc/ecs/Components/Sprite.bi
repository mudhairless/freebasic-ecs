#ifndef _FB_ECS_SPRITE_BI__
#define _FB_ECS_SPRITE_BI__ 1

#include once "ecs/Components/common.bi"

type Sprite extends Component
    as any ptr image
    as sub(byval as any ptr) free_function

    declare destructor()
end type

#endif