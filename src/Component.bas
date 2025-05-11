#include once "ecs/common.bi"
#include once "ecs/Component.bi"

constructor Component()
end constructor

constructor Component (byref cname as const string)
    this.cname = cname
end constructor

destructor Component()
end destructor

sub Component.register(byval _e as any ptr)
end sub

sub Component.deregister(byval _e as any ptr)
end sub

destructor ComponentListItem()
    delete this._component
end destructor

sub ComponentList.RemoveComponent(byref cname as string)
    var _next = this._list
    dim as ComponentListItem ptr _last = NULL
    while (_next <> NULL)
        if(_next->_component->cname = cname) then
            if(_last = NULL) then
                this._list = _next->_next
                if(this._last->_component->cname = cname) then
                    this._last = _next->_next
                end if
            else
                _last->_next = _next->_next
            end if
            delete _next
            return
        end if
        _last = _next
        _next = _next->_next
    wend
end sub

sub ComponentList.AddComponent(byval c as Component ptr)
    if(this._last <> NULL) then
        var x = new ComponentListItem
        x->_component = c
        this._last->_next = x
        this._last = x
    else
        var x = new ComponentListItem
        x->_component = c
        this._list = x
        this._last = x
    end if
end sub

sub ComponentList.ResetIterator()  
    this._ptr = NULL
end sub

function ComponentList.IteratorNext() as Component ptr
    if(this._ptr = NULL) then  
        this._ptr = this._list
    else
        this._ptr = this._ptr->_next
    end if

    if(this._ptr <> NULL) then
        return this._ptr->_component
    end if

    return NULL
end function

destructor ComponentList()
end destructor