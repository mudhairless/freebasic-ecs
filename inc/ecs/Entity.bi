#ifndef _FB_ECS_ENTITY_BI__
#define _FB_ECS_ENTITY_BI__ 1

#include once "ecs/Component.bi"
#include once "ecs/ComponentRegistry.bi"
#include once "ecs/Events.bi"

type Entity extends Object
    public:
    declare destructor()

    declare function AddComponent(byref c_name as string) as Component ptr
    declare function HasComponent(byref c_name as string) as boolean
    declare function GetComponent(byref c_name as string) as Component ptr
    declare sub RemoveComponent(byref c_name as string)

    declare property Events() as EventSystem ptr

    _name as string
    refs as long
    
    private:
    _events as EventSystem
    _components as ComponentList
end type

#macro GET_COMPONENT (e, t) 
(cast(t ptr, (e)->GetComponent(#t)))
#endmacro
#macro ADD_COMPONENT (e, t) 
(cast(t ptr, (e)->AddComponent(#t)))
#endmacro
#macro REM_COMPONENT (e, t) 
((e)->RemoveComponent(#t))
#endmacro

#endif