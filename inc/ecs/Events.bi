#ifndef _FB_ECS_EVENTS_BI__
#define _FB_ECS_EVENTS_BI__ 1

type EventHandlerMethod as function(byval _app as any ptr, byval _source_ent as any ptr, byval _event_data as any ptr) as long

type EventHandler 
    public:
    declare constructor(byref evn as string)
    declare property EventName() as string
    
    declare function trigger(byval _app as any ptr, byval src as any ptr, byval _event_data as any ptr) as long

    declare function addListener(byval f as EventHandlerMethod) as long
    declare sub removeListener(byval f as EventHandlerMethod)
    declare sub removeAllListeners()

    private:
    _EventName as string
    _listeners(15) as EventHandlerMethod
end type

type EventHandlerListItem
    _handler as EventHandler ptr 
    _next as EventHandlerListItem ptr
end type

type EventSystem
    public:
    declare function GetEventHandler(byref ev_name as string) as EventHandler ptr
    declare sub AddEvent(byref ev_name as string)
    declare function AddListener(byref ev_name as string, byval f as EventHandlerMethod) as long
    declare sub RemoveListener(byref ev_name as string, byval f as EventHandlerMethod)
    declare sub RemoveAllListeners(byref ev_name as string)
    declare function TriggerEvent(byref ev_name as string, byval ev_data as any ptr) as long
    declare function TriggerEvent(byref ev_name as string, byval src as any ptr, byval ev_data as any ptr) as long
    declare sub SetApplication(byval a as any ptr)
    declare sub SetSource(byval s as any ptr)
    private:
    _list as EventHandlerListItem ptr
    _last as EventHandlerListItem ptr
    _app as any ptr
    _src as any ptr
end type

#endif