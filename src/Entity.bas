#include once "ecs/Entity.bi"
#include once "ecs/Application.bi"

 public sub Entity.ResetIterator()
    this._ptr = 0
end sub

public function Entity.IteratorNext() as Component ptr
    if(this._ptr = 0) then  
        this._ptr = this._list
    else
        this._ptr = this._ptr->_next
    end if

    if(this._ptr <> 0) then
        return this._ptr->_component
    end if

    return 0
end function

 property Entity.Events() as EventSystem ptr
    return @(this._events)
 end property

 function Entity.AddComponent(byref c_name as string) as Component ptr
    var baseComponent = Application.GetInstance()->component_registry->GetComponent(c_name)
    var existing = this.GetComponent(c_name)
    if(existing <> 0) then return existing
    if (baseComponent <> 0) then
        for n as integer = 0 to ubound(baseComponent->_requires)
            if(baseComponent->_requires(n) <> "") then
                this.AddComponent(baseComponent->_requires(n))
            end if
        next n
        if(this._last <> 0) then
            var x = new ComponentListItem
            x->_component = baseComponent
            this._last->_next = x
            this._last = x
        else
            var x = new ComponentListItem
            x->_component = baseComponent
            this._list = x
            this._last = x
        end if
        baseComponent->register(@this)
        return baseComponent
    end if
    return 0
 end function

 function Entity.GetComponent(byref c_name as string) as Component ptr
    this.ResetIterator()
    var _next = this.IteratorNext()
    while(_next <> 0)
        if(_next->cname = c_name) then
            return _next
        end if
        _next = this.IteratorNext()
    wend
    return 0
 end function

 sub Entity.RemoveComponent(byref c_name as string)
    var exists = this.GetComponent(c_name)
    if(exists <> 0) then
        this._ptr = 0
        exists->deregister(@this)
        var _next = this._list
        dim as ComponentListItem ptr _last = 0
        while (_next <> 0)
            if(_next->_component = exists) then
                if(_last = 0) then
                    this._list = _next->_next
                    if(this._last->_component = exists) then
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
    end if
 end sub

 destructor Entity()
    this.ResetIterator()
    var _next = this.IteratorNext()
    while(_next <> 0)
        delete _next
        _next = this.IteratorNext()
    wend
 end destructor


