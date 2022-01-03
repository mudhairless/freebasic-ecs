#include once "ecs/Application.bi"

public constructor Application()
    this.all_entities = new EntityList
    this.all_resources = new ResourceList
    this.systems = new SystemList
    this.exit_sentinel = 0
    this._events.SetApplication(@this)
    this._events.AddEvent("ApplicationExit")
end constructor

public destructor Application()
    delete this.all_resources
    delete this.all_entities
end destructor

public property Application.Events() as EventSystem ptr
    return @(this._events)
end property

public function Application.AddEntity(byref _name as string) as Entity ptr
    dim as Entity ptr e = new Entity
    e->_name = _name
    e->Events->SetApplication(@this)
    e->Events->SetSource(e)
    this.all_entities->AddEntity(e)
    return e
end function

public sub Application.AddResource(byval rn as string, byval r as any ptr, byval destroy as ResourceDestructor)
    this.all_resources->AddResource(rn, r, destroy)
end sub

public function Application.GetResource(byref rn as string) as any ptr
    return this.all_resources->FindResource(rn)
end function

public sub Application.runApplication()
    this.exit_sentinel = 0
    
    'run startup systems
    var _next = this.systems->_s_list
    if(_next <> 0) then
        do
            var _cur = _next
            _cur->_system->_call(@this, 0)
            _next = _cur->_next
        loop until _next = 0
    end if

    this.last_time = timer
    this.curTime = this.last_time
    this.deltaTime = 0f
    
   
    do while this.exit_sentinel = 0
        this.last_time = this.curTime
        this.curTime = timer
        this.deltaTime = this.curTime - this.last_time

        _next = this.systems->_list

        if(_next <> 0) then
            do
                var _cur = _next
                if((this.curTime - _cur->_system->last_run) > _cur->_system->minDelay) then

                    _cur->_system->_call(@this, this.deltaTime)
                    _cur->_system->last_run = this.curTime
                
                end if
                _next = _cur->_next
            loop until _next = 0
        end if
        sleep 1,1
    loop
end sub

public sub Application.exitApplication()
    var doExit = this._events.TriggerEvent("ApplicationExit", 0)
    this.exit_sentinel = iif(doExit <> 0, 1, 0)
end sub