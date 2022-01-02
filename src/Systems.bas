#include once "ecs/Systems.bi"
#include once "ecs/Application.bi"

sub SystemWrapper._call(byval app as any ptr, byval deltaTime as single)
    select case this._type
    case SystemType.SystemStartup:
        this._func(app, this._user_data, 0, 0)

    case SystemType.SystemWithSearchFunction:
        var f_data = (cast(Application ptr, app))->all_entities->Search(this._data.search_function, this._user_data)
        this._func(app, this._user_data, f_data, deltaTime)

    case SystemType.SystemOfComponents:
        var f_data = (cast(Application ptr, app))->all_entities->WithComponent(*this._data.neededComponents)
        this._func(app, this._user_data, f_data, deltaTime)

    case SystemType.SystemOfNamedEntities:
        var f_data = (cast(Application ptr, app))->all_entities->FindAllEntities(*this._data.namedEntities)
        this._func(app, this._user_data, f_data, deltaTime)

    end select
end sub

destructor SystemListItem()
    if(this._system <> 0) then
        delete this._system
    end if
end destructor

sub SystemList.AddStartupSystem(byval f as SystemFunction, byval ud as any ptr)
    var eli = new SystemListItem
    eli->_system = new SystemWrapper
    eli->_system->_type = SystemType.SystemStartup
    eli->_system->_user_data = ud
    eli->_system->_func = f
    eli->_next = 0
    if(this._s_last <> 0) then   
        this._s_last->_next = eli
        this._s_last = eli
    else
        this._s_list = eli
        this._s_last = eli
    end if
end sub

sub SystemList.AddComponentSystem(byref cname as string, byval f as SystemFunction, byval ud as any ptr, byval rps as long = 60)
    var eli = new SystemListItem
    eli->_system = new SystemWrapper
    eli->_system->_type = SystemType.SystemOfComponents
    eli->_system->_user_data = ud
    eli->_system->_func = f
    eli->_system->_data.neededComponents = strptr(cname)
    eli->_system->runsPerSecond = rps
    eli->_system->minDelay = 1/rps
    eli->_next = 0
    if(this._last <> 0) then   
        this._last->_next = eli
        this._last = eli
    else
        this._list = eli
        this._last = eli
    end if
end sub

sub SystemList.AddEntitySystem(byref ename as string, byval f as SystemFunction, byval ud as any ptr, byval rps as long = 60)
    var eli = new SystemListItem
    eli->_system = new SystemWrapper
    eli->_system->_type = SystemType.SystemOfNamedEntities
    eli->_system->_user_data = ud
    eli->_system->_func = f
    eli->_system->_data.namedEntities = strptr(ename)
    eli->_system->runsPerSecond = rps
    eli->_system->minDelay = 1/rps
    eli->_next = 0
    if(this._last <> 0) then   
        this._last->_next = eli
        this._last = eli
    else
        this._list = eli
        this._last = eli
    end if
end sub

sub SystemList.AddSystem(byval search_f as EntityListSearchFunction, byval f as SystemFunction, byval ud as any ptr, byval rps as long = 60)
    var eli = new SystemListItem
    eli->_system = new SystemWrapper
    eli->_system->_type = SystemType.SystemWithSearchFunction
    eli->_system->_user_data = ud
    eli->_system->_func = f
    eli->_system->_data.search_function = search_f
    eli->_system->runsPerSecond = rps
    eli->_system->minDelay = 1/rps
    eli->_next = 0
    if(this._last <> 0) then   
        this._last->_next = eli
        this._last = eli
    else
        this._list = eli
        this._last = eli
    end if
end sub