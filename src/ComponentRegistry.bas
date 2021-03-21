#include once "ecs/ComponentRegistry.bi"

function ComponentRegistry.GetComponent(byref cname as const string) as Component ptr
    for i as integer = 0 to len(this._components)
        if(this._components(i)._cname = cname) then
            return this._components(i)._component->create(cname)
        end if
    next i
    return 0
end function

sub ComponentRegistry.RegisterComponent(byref cname as const string, byval c as Component ptr)
    var added = 0
    for i as integer = 0 to len(this._components)
        if(this._components(i)._cname = cname) then
            this._components(i)._component = c
            added = 1
            exit for
        end if
        if(this._components(i)._component = 0) then
            this._components(i)._cname = cname
            this._components(i)._component = c
            added = 1
            exit for
        end if
    next i

    if(added = 0) then
        ' we need to resize the array in this case
        var newL = ubound(this._components)
        redim preserve this._components(0 to newL + 10)
        this._components(newL)._cname = cname
        this._components(newL)._component = c
    end if
end sub