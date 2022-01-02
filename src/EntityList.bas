#include once "ecs/EntityList.bi"

public constructor EntityListItem(byval e as Entity ptr)
    this._entity = e
    this._entity->refs += 1
end constructor

public destructor EntityListItem()
    this._entity->refs -= 1
    if(this._entity->refs = 0) then
        delete this._entity
    end if
end destructor

public sub EntityList.AddEntity(byval e as Entity ptr)
    
    var eli = new EntityListItem(e)
    eli->_next = 0
    if(this._last <> 0) then   
        this._last->_next = eli
    else
        this._list = eli
        this._last = eli
    end if
end sub

public sub EntityList.RemoveEntity(byval e as Entity ptr)
    if(this._list <> 0) then
        
        dim as EntityListItem ptr _next = this._list
        dim as EntityListItem ptr _last = 0
        do
            if(_next->_entity = e) then
                if(_last = 0) then ' start of list
                    this._list = _next->_next
                else
                    _last->_next = _next->_next
                end if
                delete _next
                _next = 0
            else
                _last = _next
                _next = _next->_next
            end if
        loop until _next = 0
        
    end if
end sub

public function EntityList.Search(byval searchFunction as EntityListSearchFunction, byval _data as any ptr) as EntityList ptr
    var outList = new EntityList
    var _next = this._list
    do
        var _cur = _next
        _next = _next->_next
        if(searchFunction(_cur->_entity, _data) <> 0) then
            outList->AddEntity(_cur->_entity)
        end if
    loop until _next = 0
    return outList
end function

private function EntityWithComponent(byval e as Entity ptr, byval c as any ptr) as long
    var x = e->GetComponent(*(cast(zstring ptr, c)))
    if(x <> 0) then
        return 1
    end if
    return 0
end function

public function EntityList.WithComponent(byref c as string) as EntityList ptr
    return this.Search(@EntityWithComponent, strptr(c))
end function

public destructor EntityList()
    var _next = this._list
    do
        var _cur = _next
        _next = _next->_next
        delete _cur
    loop until _next = 0
end destructor