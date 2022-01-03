 #include once "ecs/Entity.bi"

 dim Entity._ComponentRegistry as ComponentRegistry

 property Entity.Events() as EventSystem ptr
    return @(this._events)
 end property

 function Entity.AddComponent(byref c_name as const string) as Component ptr
    var _len = ubound(this._components)
    var baseComponent = Entity._ComponentRegistry.GetComponent(c_name)
    if (baseComponent <> 0) then
        for n as integer = 0 to ubound(baseComponent->_requires)
            if(baseComponent->_requires(n) <> "") then
                this.AddComponent(baseComponent->_requires(n))
            end if
        next n
        for i as integer = 0 to _len
            if(this._components(i) <> 0) then 
                if (this._components(i)->cname = c_name) then
                    return this._components(i)
                end if
            else
                this._components(i) = baseComponent
                this._components(i)->register(@this)
                return baseComponent
            end if
        next i
    end if
    return 0
 end function

 function Entity.GetComponent(byref c_name as const string) as Component ptr
    for i as integer = 0 to ubound(this._components)
        if(this._components(i) <> 0) then
            if (this._components(i)->cname = c_name) then
                return this._components(i)
            end if
        end if
    next
    return 0
 end function

 sub Entity.RemoveComponent(byref c_name as const string)
    for i as integer = 0 to ubound(this._components)
        if(this._components(i) <> 0) then
            if (this._components(i)->cname = c_name) then
                this._components(i)->deregister(@this)
                delete this._components(i)
                this._components(i) = 0
            end if
        end if
    next
 end sub

 destructor Entity()
    for i as integer = 0 to ubound(this._components)
        if(this._components(i) <> 0) then
            delete this._components(i)
        end if
    next i
 end destructor

static sub Entity.RegisterComponent(byref c_name as const string, byval c as Component ptr)
    Entity._ComponentRegistry.RegisterComponent(c_name, c)
end sub

