#ifndef _FB_ECS_ENTITYLIST_BI__
#define _FB_ECS_ENTITYLIST_BI__ 1

#include once "ecs/Entity.bi"

type EntityListItem
    as Entity ptr _entity
    as EntityListItem ptr _next
    declare destructor()
    declare constructor(byval e as Entity ptr)
end type

type EntityListSearchFunction as function(byval e as Entity ptr, byval d as any ptr) as boolean

type EntityList
    public:
    declare function FindEntity(byref ename as string) as Entity ptr
    declare function FindAllEntities(byref ename as string) as EntityList ptr
    declare function Search(byval sf as EntityListSearchFunction, byval _data as any ptr) as EntityList ptr
    declare function WithComponent(byref c as string) as EntityList ptr
    declare sub RemoveEntity(byval e as Entity ptr)
    declare sub AddEntity(byval e as Entity ptr)
    declare function count() as uinteger
    declare destructor()

    declare sub ResetIterator()
    declare function IteratorNext() as Entity ptr

    'private:
    as EntityListItem ptr _ptr
    as EntityListItem ptr _list
    as EntityListItem ptr _last
end type

#macro GET_ENTLIST(l)
    (cast(EntityList ptr, l))
#endmacro

#endif