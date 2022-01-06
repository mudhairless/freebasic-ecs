#ifndef _FB_ECS_COMPONENT_BI__
#define _FB_ECS_COMPONENT_BI__ 1

type Component extends Object
    public:
        cname as string
        _requires(10) as string
        declare constructor ()
        declare constructor (byref cname as const string)
        
        declare virtual sub register(byval _entity as any ptr)
        declare virtual sub deregister(byval _entity as any ptr)
end type

type ComponentListItem
    _component as Component ptr
    _next as ComponentListItem ptr

    declare destructor()
end type

type ComponentList
    declare sub RemoveComponent(byref cname as string)
    declare sub AddComponent(byval c as Component ptr)
    declare sub ResetIterator()
    declare function IteratorNext() as Component ptr
    declare destructor()
    private:
    _list as ComponentListItem ptr
    _last as ComponentListItem ptr
    _ptr as ComponentListItem ptr
end type

#endif