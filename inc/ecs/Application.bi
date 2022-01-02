#ifndef _FB_ECS_APPLICATION_BI__
#define _FB_ECS_APPLICATION_BI__ 1

#include once "ecs/EntityList.bi"
#include once "ecs/Resource.bi"

type Application
    public:
    declare constructor()
    declare destructor()
    declare sub AddResource(byval rn as string, byval r as any ptr, byval destroy as ResourceDestructor)
    declare function GetResource(byref rn as string) as any ptr
    declare function AddEntity() as Entity ptr
    as EntityList ptr all_entities

    private:
    as ResourceList ptr all_resources

end type

#define GET_RESOURCE (e, t) (cast(t ptr, (e).GetResource(#t)))

#endif