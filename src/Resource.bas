#include once "ecs/common.bi"
#include once "ecs/Resource.bi"

constructor ResourceListItem(byval r as Resource ptr)
    this._resource = r
    r->refs += 1
end constructor

destructor ResourceListItem()
    this._resource->refs -= 1
    if(this._resource->refs = 0) then
        if(this._resource->resource_destroy <> 0) then
            this._resource->resource_destroy(this._resource->resource_data)
        end if
    end if
end destructor

destructor ResourceList()
    var _next = this._list
    do
        var _cur = _next
        _next = _next->_next
        delete _cur
    loop until _next = NULL
end destructor

sub ResourceList.AddResource(byref rn as string, byval rd as any ptr, byval destroy as ResourceDestructor)
    var x = new Resource
    x->resource_name = rn
    x->resource_data = rd
    x->resource_destroy = destroy

    var li = new ResourceListItem(x)
    if(this._last = NULL) then ' start of list
        this._list = li
        this._last = li
    else
        this._last->_next = li
        this._last = li
    end if
end sub

function ResourceList.FindResource(byref rn as string) as any ptr
    var _next = this._list
    do
        var _cur = _next
        if(_cur->_resource->resource_name = rn) then
            return _cur->_resource->resource_data
        end if
        _next = _next->_next
    loop until _next = NULL
    return NULL
end function

