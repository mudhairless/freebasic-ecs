#ifndef _FB_ECS_COMPONENT_REGISTRY_BI__
#define _FB_ECS_COMPONENT_REGISTRY_BI__ 1

#include once "ecs/Component.bi"

type KeyPair_SC
    public:
    as string _cname
    as Component ptr _component
end type

type ComponentRegistry
    public:
    declare sub RegisterComponent(byref cname as const string, byval comp as Component ptr)
    declare function GetComponent(byref cname as const string) as Component ptr

    private:
    redim _components(20) as KeyPair_SC
end type

#endif