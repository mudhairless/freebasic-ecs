#include once "ecs/common.bi"
#include once "ecs/Events.bi"
#include once "ecs/Application.bi"

constructor EventHandler(byref evn as string)
    this._EventName = evn
end constructor

property EventHandler.EventName() as string
    return this._EventName
end property
    
function EventHandler.trigger(byval src as any ptr, byval _event_data as any ptr) as boolean
    for a as long = 0 to ubound(this._listeners)
        if(this._listeners(a) <> NULL) then
            var ret = (this._listeners(a)) (src, _event_data)
            if(ret = FALSE) then
                return FALSE
            end if
        end if
    next a
    return TRUE
end function

function EventHandler.addListener(byval f as EventHandlerMethod) as boolean
    for a as long = 0 to ubound(this._listeners)
        if(this._listeners(a) = FALSE) then 
            this._listeners(a) = f
            return TRUE
        end if
    next a
    return FALSE
end function

sub EventHandler.removeListener(byval f as EventHandlerMethod)
    for a as long = 0 to ubound(this._listeners)
        if(this._listeners(a) = f) then 
            this._listeners(a) = NULL
        end if
    next a
end sub

sub EventHandler.removeAllListeners()
    for a as long = 0 to ubound(this._listeners)
        this._listeners(a) = NULL
    next a
end sub

function EventSystem.GetEventHandler(byref ev_name as string) as EventHandler ptr
    var _next = this._list
    do
        var _cur = _next
        if(_cur <> NULL) then
            _next = _next->_next
            if(_cur->_handler->EventName = ev_name) then
                return _cur->_handler
            end if
        end if
    loop until _next = NULL
    return NULL
end function

sub EventSystem.AddEvent(byref ev_name as string)
    var h = this.GetEventHandler(ev_name)
    if(h = NULL) then
        var app = Application.GetInstance()
        app->_log(LogLevel.Debug, "Registering Event: " & ev_name)
        var eli = new EventHandlerListItem
        eli->_handler = new EventHandler(ev_name)
        eli->_next = NULL
        if(this._last <> NULL) then   
            this._last->_next = eli
            this._last = eli
        else
            this._list = eli
            this._last = eli
        end if
    end if
end sub

function EventSystem.TriggerEvent(byref ev_name as string, byval ev_data as any ptr) as boolean
    var app = Application.GetInstance()
    var handler = this.GetEventHandler(ev_name)
    if(handler <> NULL) then
        app->_log(LogLevel.Debug, "Triggering Event: " & ev_name)
        return handler->trigger(this._src, ev_data)
    end if
    app->_log(LogLevel.Errors, "Event: " & ev_name & " triggered but not setup")
    return TRUE
end function

function EventSystem.TriggerEvent(byref ev_name as string, byval src as any ptr, byval ev_data as any ptr) as boolean
    var app = Application.GetInstance()
    var handler = this.GetEventHandler(ev_name)
    if(handler <> NULL) then
        app->_log(LogLevel.Debug, "Triggering Event: " & ev_name)
        return handler->trigger(src, ev_data)
    end if
    app->_log(LogLevel.Errors, "Event: " & ev_name & " triggered but not setup")
    return TRUE
end function

sub EventSystem.SetSource(byval s as any ptr)
    this._src = s
end sub

function EventSystem.AddListener(byref ev_name as string, byval f as EventHandlerMethod) as boolean
    var app = Application.GetInstance()
    var handler = this.GetEventHandler(ev_name)
    if(handler <> NULL) then
        app->_log(LogLevel.Debug, "Event: " & ev_name & " registered listener")
        return handler->addListener(f)
    end if
    app->_log(LogLevel.Errors, "Event: " & ev_name & " is not setup but listener added for it")
    return FALSE
end function

sub EventSystem.RemoveListener(byref ev_name as string, byval f as EventHandlerMethod)
    var app = Application.GetInstance()
    var handler = this.GetEventHandler(ev_name)
    if(handler <> NULL) then
        app->_log(LogLevel.Debug, "Removed listener from " & ev_name)
        handler->removeListener(f)
    end if
end sub

sub EventSystem.RemoveAllListeners(byref ev_name as string)
    var app = Application.GetInstance()
    var handler = this.GetEventHandler(ev_name)
    if(handler <> NULL) then
        app->_log(LogLevel.Debug, "Removed all listeners for " & ev_name)
        handler->removeAllListeners()
    end if
end sub

