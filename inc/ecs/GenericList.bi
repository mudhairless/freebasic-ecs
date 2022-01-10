#ifndef _FB_ECS_GENERICLIST_BI__
#define _FB_ECS_GENERICLIST_BI__ 1

type GenericListItem
    as any ptr _item
    as GenericListItem ptr _next
end type

type GenericList
    public:
    declare sub ResetIterator()
    declare function IteratorNext() as any ptr
    declare sub AddItem(byval x as any ptr)
    declare sub RemoveItem(byval x as any ptr)
    declare function count() as ulong

    declare constructor()
    declare constructor(byref _copy as GenericList)
    declare destructor()

    private:
        _list as GenericListItem ptr
        _last as GenericListItem ptr
        _ptr as GenericListItem ptr
end type

declare operator + ( byref lhs as GenericList, byref rhs as GenericList ) as GenericList

#endif