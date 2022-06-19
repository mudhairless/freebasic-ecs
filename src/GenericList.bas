#include once "ecs/common.bi"
#include once "ecs/GenericList.bi"

public sub GenericList.ResetIterator()
    this._ptr = NULL
end sub

public function GenericList.IteratorNext() as any ptr
    if(this._ptr = NULL) then  
        this._ptr = this._list
    else
        this._ptr = this._ptr->_next
    end if

    if(this._ptr <> NULL) then
        return this._ptr->_item
    end if

    return NULL
end function

public sub GenericList.AddItem(byval x as any ptr)
    assert(x)
    var gli = new GenericListItem
    gli->_item = x
    gli->_next = NULL
    if(this._last <> NULL) then   
        this._last->_next = gli
        this._last = gli
    else
        this._list = gli
        this._last = gli
    end if
end sub

public sub GenericList.RemoveItem(byval x as any ptr)
    assert(x)
    if(this._list <> 0) then
        dim as GenericListItem ptr _next = this._list
        dim as GenericListItem ptr _last = NULL
        do
            if(_next->_item = x) then
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

public function GenericList.count() as ulong
    dim as ulong item_count = 0
    this.ResetIterator()
    var next_item = this.IteratorNext()
    while(next_item <> NULL)
        item_count += 1
        next_item = this.IteratorNext()
    wend
    return item_count
end function

public constructor GenericList()
end constructor

public constructor GenericList(byref _copy as GenericList)
    _copy.ResetIterator()
    var _next = _copy.IteratorNext()
    while(_next <> NULL)
        this.AddItem(_next)
        _next = _copy.IteratorNext()
    wend
end constructor

public destructor GenericList()
    var _next = this._list
    while(_next <> NULL)
        var _cur = _next
        _next = _next->_next
        delete _cur
    wend
end destructor

operator + ( byref lhs as GenericList, byref rhs as GenericList ) as GenericList
    dim as GenericList retval

    lhs.ResetIterator()
    var _next = lhs.IteratorNext()
    while(_next <> NULL)
        retval.AddItem(_next)
        _next = lhs.IteratorNext()
    wend

    rhs.ResetIterator()
    _next = rhs.IteratorNext()
    while(_next <> NULL)
        retval.AddItem(_next)
        _next = rhs.IteratorNext()
    wend
    return retval
end operator