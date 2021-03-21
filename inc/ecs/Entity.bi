#ifndef _FB_ECS_ENTITY_BI__
#define _FB_ECS_ENTITY_BI__ 1

#include once "ecs/Component.bi"
#include once "ecs/ComponentRegistry.bi"

type Entity extends Object
    public:
    declare destructor()

    declare function AddComponent(byref c_name as const string) as Component ptr
    declare function GetComponent(byref c_name as const string) as Component ptr
    declare sub RemoveComponent(byref c_name as const string)

    declare static sub RegisterComponent(byref c_name as const string, byval c as Component ptr)

    private:
    _components(15) as Component ptr
    static _ComponentRegistry as ComponentRegistry
end type

#endif