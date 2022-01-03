#ifndef _FB_ECS_SYSTEMS_BI__
#define _FB_ECS_SYSTEMS_BI__ 1

#include once "ecs/EntityList.bi"

type SystemFunction as sub(byval _app as any ptr, byval _ud as any ptr, byval _data as any ptr, byval deltaTime as single)

enum SystemType explicit
    SystemWithSearchFunction
    SystemOfComponents
    SystemOfNamedEntities
    SystemStartup
end enum

type SystemWrapper
    as SystemType _type
    as EntityListSearchFunction search_function
    as string neededComponents
    as string namedEntities
    as any ptr _user_data
    as long runsPerSecond
    as single minDelay
    as double last_run
    as SystemFunction _func

    declare sub _call(byval app as any ptr, byval deltaTime as single)
end type

type SystemListItem
    as SystemWrapper ptr _system
    as SystemListItem ptr _next
    declare destructor()
end type

type SystemList
    public:
    declare sub AddStartupSystem(byval f as SystemFunction, byval ud as any ptr)
    declare sub AddComponentSystem(byref cname as string, byval f as SystemFunction, byval ud as any ptr, byval rps as long = 60)
    declare sub AddEntitySystem(byref ename as string, byval f as SystemFunction, byval ud as any ptr, byval rps as long = 60)
    declare sub AddSystem(byval search_f as EntityListSearchFunction, byval f as SystemFunction, byval ud as any ptr, byval rps as long = 60)

    
    as SystemListItem ptr _list
    as SystemListItem ptr _last
    as SystemListItem ptr _s_list
    as SystemListItem ptr _s_last
end type

#endif