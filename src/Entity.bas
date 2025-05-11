#include once "ecs/common.bi"
#include once "ecs/Entity.bi"
#include once "ecs/Application.bi"


property Entity.Events() as EventSystem ptr
    return @(this._events)
end property

function Entity.AddComponent(byref c_name as string) as Component ptr
    var baseComponent = Application.GetInstance()->component_registry->GetComponent(c_name)
    var existing = this.GetComponent(c_name)
    if(existing <> NULL) then return existing
    if (baseComponent <> NULL) then
        for n as integer = 0 to ubound(baseComponent->_requires)
            if(baseComponent->_requires(n) <> "") then
                this.AddComponent(baseComponent->_requires(n))
            end if
        next n
        this._components.AddComponent(baseComponent)
        
        baseComponent->register(@this)
        return baseComponent
    end if
    return 0
end function

function Entity.HasComponent(byref c_name as string) as boolean
    this._components.ResetIterator()
    var _next = this._components.IteratorNext()
    while(_next <> NULL)
        if(_next->cname = c_name) then
            return TRUE
        end if
        _next = this._components.IteratorNext()
    wend
    return FALSE
end function

function Entity.GetComponent(byref c_name as string) as Component ptr
    this._components.ResetIterator()
    var _next = this._components.IteratorNext()
    while(_next <> NULL)
        if(_next->cname = c_name) then
            return _next
        end if
        _next = this._components.IteratorNext()
    wend
    return NULL
end function

 sub Entity.RemoveComponent(byref c_name as string)
    var exists = this.GetComponent(c_name)
    if(exists <> NULL) then
        exists->deregister(@this)
        this._components.RemoveComponent(c_name)
    end if
 end sub

 destructor Entity()
    
 end destructor


