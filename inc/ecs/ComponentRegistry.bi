#ifndef _FB_ECS_COMPONENT_REGISTRY_BI__
#define _FB_ECS_COMPONENT_REGISTRY_BI__ 1

#include once "ecs/Component.bi"

type ComponentCreationFunction as function() as Component ptr

type ComponentRegistryListItem
    public:
    as string cname
    as ComponentCreationFunction _component
    as ComponentRegistryListItem ptr _next
    
    declare destructor()
end type

type ComponentRegistry
    public:
    declare sub RegisterComponent(byref cname as string, byval comp as ComponentCreationFunction)
    declare function GetComponent(byref cname as string) as Component ptr

    declare sub ResetIterator()
    declare function IteratorNext() as ComponentRegistryListItem ptr

    declare destructor()

    private:
    _list as ComponentRegistryListItem ptr
    _last as ComponentRegistryListItem ptr
    _ptr  as ComponentRegistryListItem ptr
end type

#endif