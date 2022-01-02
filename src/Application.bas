#include once "ecs/Application.bi"

public constructor Application()
    this.all_entities = new EntityList
    this.all_resources = new ResourceList
end constructor

public destructor Application()
    delete this.all_resources
    delete this.all_entities
end destructor

public function Application.AddEntity(byref _name as string) as Entity ptr
    dim as Entity ptr e = new Entity
    e->_name = _name
    this.all_entities->AddEntity(e)
    return e
end function

public sub Application.AddResource(byval rn as string, byval r as any ptr, byval destroy as ResourceDestructor)
    this.all_resources->AddResource(rn, r, destroy)
end sub

public function Application.GetResource(byref rn as string) as any ptr
    return this.all_resources->FindResource(rn)
end function