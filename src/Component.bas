#include once "ecs/Component.bi"

constructor Component()
end constructor

constructor Component (byref cname as const string)
    this.cname = cname
end constructor

function Component.create(byref cname as const string) as Component ptr
    var x = new Component(cname)
    return x
end function

sub Component.register(byval _e as any ptr)
end sub

sub Component.deregister(byval _e as any ptr)
end sub