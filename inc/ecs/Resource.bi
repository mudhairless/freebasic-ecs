#ifndef _FB_ECS_RESOURCE_BI__
#define _FB_ECS_RESOURCE_BI__ 1

type ResourceDestructor as sub(byval x as any ptr)

type Resource 
    as string resource_name
    as any ptr resource_data
    as long refs
    as ResourceDestructor resource_destroy
end type

type ResourceListItem
    as Resource ptr _resource
    as ResourceListItem ptr _next
    declare constructor(byval r as Resource ptr)
    declare destructor()
end type

type ResourceList
    as ResourceListItem ptr _list
    as ResourceListItem ptr _last

    declare sub AddResource(byref rn as string, byval rd as any ptr, byval destroy as ResourceDestructor)
    declare function FindResource(byref rn as string) as any ptr
    declare destructor()
end type

#endif