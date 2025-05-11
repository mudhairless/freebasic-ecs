#include once "ecs/common.bi"
#include once "ecs/Application.bi"

dim shared _app_instance as Application ptr = NULL

public static function Application.GetInstance() as Application ptr
    if(_app_instance <> NULL) then return _app_instance
    _app_instance = new Application()
    _app_instance->init()
    return _app_instance
end function

private constructor Application()
    this._loggingLevel = LogLevel.Off
end constructor

public destructor Application()
    delete this.all_resources
    delete this.all_entities
    delete this.component_registry
    this._log(LogLevel.Debug, "Application Destroyed")
end destructor

private sub Application.init()
    this.component_registry = new ComponentRegistry
    this.all_entities = new EntityList
    this.all_resources = new ResourceList
    this.systems = new SystemList
    this.exit_sentinel = FALSE
    this._events.AddEvent("ApplicationExit")
    this.debug_channel = -1
end sub

public property Application.LoggingLevel() as LogLevel
    return this._loggingLevel
end property

public property Application.LoggingLevel(byval ll as LogLevel)

    this._loggingLevel = ll
    if(this._loggingLevel = LogLevel.Off AND this.debug_channel >= 0) then
        close #this.debug_channel
        this.debug_channel = -1
    else
        if(this.debug_channel < 0) then
            this.debug_channel = freefile
            var fn = command(0) & "." & date() & ".log"
            var fileDidOpen = open (fn, for append, as #this.debug_channel)
            if(fileDidOpen <> 0) then
                this._loggingLevel = LogLevel.Off
                print "ERROR opening log file: " & fn & " error: " & fileDidOpen
                system
            end if
        end if
    end if
end property

public sub Application._log(byval ll as LogLevel, byref msg as string)
    if(this._loggingLevel = LogLevel.Off OR this.debug_channel < 0) then
        return
    end if
    var level = ""
    select case ll
        case LogLevel.Info:
            level = "[INFO] "

        case LogLevel.Errors:
            if(this._loggingLevel = LogLevel.Info) then
                return
            end if
            level = "[ERROR] "

        case LogLevel.Debug:
            if(this._loggingLevel = LogLevel.Errors or this._loggingLevel = LogLevel.Info) then
                return
            end if
            level = "[DEBUG] "

    end select

    print #this.debug_channel, time & " " & level & msg
end sub

public property Application.Events() as EventSystem ptr
    return @(this._events)
end property

public function Application.AddEntity(byref _name as string) as Entity ptr
    this._log(LogLevel.Debug, "Adding Entity: " & _name)
    dim as Entity ptr e = new Entity
    e->_name = _name
    e->Events->SetSource(e)
    this.all_entities->AddEntity(e)
    return e
end function

public sub Application.AddResource(byval rn as string, byval r as any ptr, byval destroy as ResourceDestructor)
    this._log(LogLevel.Debug, "Adding Resource: " & rn)
    this.all_resources->AddResource(rn, r, destroy)
end sub

public function Application.GetResource(byref rn as string) as any ptr
    return this.all_resources->FindResource(rn)
end function

public sub Application.runApplication()
    this.exit_sentinel = FALSE
    
    var n = 0
    this._log(LogLevel.Info, "Starting application...")
    
    'run startup systems
    this._log(LogLevel.Info, "Running startup systems...")
    this.systems->ResetStartupIterator()
    var _next = this.systems->StartupIteratorNext()
    while(_next <> NULL)    
            this._log(LogLevel.Debug, "Startup system: " & n)
            _next->_call(0)
            _next = this.systems->StartupIteratorNext()
            n += 1
    wend

    this._log(LogLevel.Info, "Startup systems complete.")

    this.last_time = timer
    this.curTime = this.last_time
    this.deltaTime = 0f
   
   this._log(LogLevel.Info, "Starting main loop...")
    while(this.exit_sentinel = FALSE)
        this.last_time = this.curTime
        this.curTime = timer
        this.deltaTime = this.curTime - this.last_time

        this.systems->ResetIterator()
        _next = this.systems->IteratorNext()
        this._log(LogLevel.Debug, "Running systems")
        n = 0
        while(_next <> NULL)
                if((this.curTime - _next->last_run) > _next->minDelay) then
                    select case _next->_type
                    case SystemType.SystemStartup
                        this._log(LogLevel.Debug, "Running Startup System " & n)
                    case SystemType.SystemOfComponents
                        this._log(LogLevel.Debug, "Running component system( " & n & ") " & _next->neededComponents)
                    case SystemType.SystemOfNamedEntities
                        this._log(LogLevel.Debug, "Running entity system(" & n & ") " & _next->namedEntities)
                    case else
                        this._log(LogLevel.Errors, "Unknown System at " & n)
                    end select
                    
                    _next->_call(this.deltaTime)
                    _next->last_run = this.curTime
                end if
                _next = this.systems->IteratorNext()
                n += 1
        wend
        this._log(LogLevel.Debug, "Main loop complete, " & iif(this.exit_sentinel = 0, "repeating", "exiting"))

        sleep 1,1
    wend
    this._log(LogLevel.Info, "Exiting application, goodbye!")
end sub

public sub Application.exitApplication()
    this._log(LogLevel.Info, "Received Application Exit Request")
    var doExit = this._events.TriggerEvent("ApplicationExit", NULL)
    this.exit_sentinel = iif(doExit <> FALSE, TRUE, FALSE)
end sub