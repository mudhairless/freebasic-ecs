#ifndef _FB_ECS_APPLICATION_BI__
#define _FB_ECS_APPLICATION_BI__ 1

#include once "ecs/EntityList.bi"
#include once "ecs/Resource.bi"
#include once "ecs/Systems.bi"

type Application
    public:
    declare constructor()
    declare destructor()

    declare sub AddResource(byval rn as string, byval r as any ptr, byval destroy as ResourceDestructor)
    declare function GetResource(byref rn as string) as any ptr
    declare function AddEntity(byref _name as string) as Entity ptr

    declare sub runApplication()
    declare sub exitApplication()

    as SystemList ptr systems

    as EntityList ptr all_entities

    private:
    as double last_time
    as double curTime
    as double deltaTime
    as long exit_sentinel
    as ResourceList ptr all_resources

end type

#macro GET_RESOURCE (e, t) 
(cast(t ptr, (e).GetResource(#t)))
#endmacro 

#macro GET_APP (x) 
(cast( Application ptr, x))
#endmacro

#endif