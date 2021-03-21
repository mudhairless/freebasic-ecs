#include once "ecs/Component.bi"

function Component.create(byref cname as const string) as Component ptr
    var x = new Component()
    x->cname = cname
    return x
end function