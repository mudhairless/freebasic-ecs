#ifndef _FB_ECS_APPLICATION_BI__
#define _FB_ECS_APPLICATION_BI__ 1

#include once "ecs/EntityList.bi"
#include once "ecs/Resource.bi"
#include once "ecs/Systems.bi"
#include once "ecs/Events.bi"
#include once "ecs/ComponentRegistry.bi"

enum LogLevel
    Off
    Info
    Errors
    Debug
end enum

type Application
    public:
    
    declare destructor()

    declare static function GetInstance() as Application ptr

    declare sub AddResource(byval rn as string, byval r as any ptr, byval destroy as ResourceDestructor)
    declare function GetResource(byref rn as string) as any ptr
    declare function AddEntity(byref _name as string) as Entity ptr

    declare sub runApplication()
    declare sub exitApplication()

    declare property Events() as EventSystem ptr

    declare property LoggingLevel() as LogLevel
    declare property LoggingLevel(byval ll as LogLevel)
    declare sub _log(byval ll as LogLevel, byref msg as string)

    as SystemList ptr systems
    as EntityList ptr all_entities
    as ComponentRegistry ptr component_registry

    private:
    declare constructor()
    declare sub init()
    as double last_time
    as double curTime
    as double deltaTime
    as long exit_sentinel
    as EventSystem _events
    
    as ResourceList ptr all_resources
    as long debug_channel
    as LogLevel _loggingLevel

end type

#macro GET_RESOURCE (e, t) 
(cast(t ptr, (e)->GetResource(#t)))
#endmacro 

#macro GET_APP (x) 
(cast( Application ptr, x))
#endmacro

#endif