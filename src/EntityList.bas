#include once "ecs/common.bi"
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

public sub EntityList.ResetIterator()
    this._ptr = NULL
end sub

public function EntityList.IteratorNext() as Entity ptr
    if(this._ptr = NULL) then  
        this._ptr = this._list
    else
        this._ptr = this._ptr->_next
    end if

    if(this._ptr <> NULL) then
        return this._ptr->_entity
    end if

    return NULL
end function

public sub EntityList.AddEntity(byval e as Entity ptr)
    var eli = new EntityListItem(e)
    eli->_next = NULL
    if(this._last <> NULL) then   
        this._last->_next = eli
        this._last = eli
    else
        this._list = eli
        this._last = eli
    end if
end sub

public function EntityList.FindEntity(byref ename as string) as Entity ptr
    this.ResetIterator()
    var _next = this.IteratorNext()
    while (_next <> NULL)
        if(_next <> NULL) then
            if(_next->_name = ename) then
                return _next
            end if
            _next = this.IteratorNext()
        end if
    wend
    
    return NULL
end function

private function EntityByName(byval e as Entity ptr, byval c as any ptr) as long
    if(e->_name = (*(cast(zstring ptr, c)))) then
        return TRUE
    end if
    return FALSE
end function

public function EntityList.FindAllEntities(byref ename as string) as EntityList ptr
    return this.Search(@EntityByName, strptr(ename))
end function

public sub EntityList.RemoveEntity(byval e as Entity ptr)
    if(this._list <> NULL) then
        dim as EntityListItem ptr _next = this._list
        dim as EntityListItem ptr _last = 0
        do
            if(_next->_entity = e) then
                if(_last = NULL) then ' start of list
                    this._list = _next->_next
                else
                    _last->_next = _next->_next
                end if
                delete _next
                _next = NULL
            else
                _last = _next
                _next = _next->_next
            end if
        loop until _next = NULL
        
    end if
end sub

public function EntityList.Search(byval searchFunction as EntityListSearchFunction, byval _data as any ptr) as EntityList ptr
    var outList = new EntityList
    this.ResetIterator()
    var _next = this.IteratorNext()
    
    do
        if(_next <> NULL) then
            if(searchFunction(_next, _data) <> TRUE) then
                outList->AddEntity(_next)
            end if
            _next = this.IteratorNext()
        end if
    loop until _next = NULL

    return outList
end function

private function EntityWithComponent(byval e as Entity ptr, byval c as any ptr) as long
    var x = e->GetComponent(*(cast(zstring ptr, c)))
    if(x <> NULL) then
        return TRUE
    end if
    return FALSE
end function

public function EntityList.WithComponent(byref c as string) as EntityList ptr
    return this.Search(@EntityWithComponent, strptr(c))
end function

public destructor EntityList()
    var _next = this._list
    while(_next <> NULL)
        var _cur = _next
        _next = _next->_next
        delete _cur
    wend
end destructor