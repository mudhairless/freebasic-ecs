#ifndef _FB_ECS_COMPONENT_REGISTRY_BI__
#define _FB_ECS_COMPONENT_REGISTRY_BI__ 1

#include once "ecs/Component.bi"

type ComponentListItem
    public:
    as Component ptr _component
    as ComponentListItem ptr _next
    
    declare destructor()
end type

type ComponentRegistry
    public:
    declare sub RegisterComponent(byref cname as string, byval comp as Component ptr)
    declare function GetComponent(byref cname as string) as Component ptr

    declare sub ResetIterator()
    declare function IteratorNext() as Component ptr

    declare destructor()

    private:
    _list as ComponentListItem ptr
    _last as ComponentListItem ptr
    _ptr  as ComponentListItem ptr
end type

#endif