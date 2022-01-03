#include once "ecs/Events.bi"

constructor EventHandler(byref evn as string)
    this._EventName = evn
end constructor

property EventHandler.EventName() as string
    return this._EventName
end property
    
function EventHandler.trigger(byval _app as any ptr, byval src as any ptr, byval _event_data as any ptr) as long
    for a as long = 0 to ubound(this._listeners)
        if(this._listeners(a) <> 0) then
            var ret = (this._listeners(a)) (_app, src, _event_data)
            if(ret = 0) then
                return 0
            end if
        end if
    next a
    return 1
end function

function EventHandler.addListener(byval f as EventHandlerMethod) as long
    for a as long = 0 to ubound(this._listeners)
        if(this._listeners(a) = 0) then 
            this._listeners(a) = f
            return 1
        end if
    next a
    return 0
end function

sub EventHandler.removeListener(byval f as EventHandlerMethod)
    for a as long = 0 to ubound(this._listeners)
        if(this._listeners(a) = f) then 
            this._listeners(a) = 0
        end if
    next a
end sub

function EventSystem.GetEventHandler(byref ev_name as string) as EventHandler ptr
    var _next = this._list
    do
        var _cur = _next
        if(_cur <> 0) then
            _next = _next->_next
            if(_cur->_handler->EventName = ev_name) then
                return _cur->_handler
            end if
        end if
    loop until _next = 0
    return 0
end function

sub EventSystem.AddEvent(byref ev_name as string)
    var h = this.GetEventHandler(ev_name)
    if(h = 0) then
        var eli = new EventHandlerListItem
        eli->_handler = new EventHandler(ev_name)
        eli->_next = 0
        if(this._last <> 0) then   
            this._last->_next = eli
            this._last = eli
        else
            this._list = eli
            this._last = eli
        end if
    end if
end sub

function EventSystem.TriggerEvent(byref ev_name as string, byval src as any ptr, byval ev_data as any ptr) as long
    var handler = this.GetEventHandler(ev_name)
    if(handler <> 0) then
        return handler->trigger(this._app, src, ev_data)
    end if
    return 1
end function

sub EventSystem.SetApplication(byval a as any ptr)
    this._app = a
end sub