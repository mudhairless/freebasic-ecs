#include once "ecs/common.bi"
#include once "ecs/Systems.bi"
#include once "ecs/Application.bi"

sub SystemWrapper._call(byval deltaTime as single)
    select case this._type
        case SystemType.SystemStartup:
            this._func(this._user_data, NULL, NULL)

        case SystemType.SystemWithSearchFunction:
            var f_data = Application.GetInstance()->all_entities->Search(this.search_function, this._user_data)
            this._func(this._user_data, f_data, deltaTime)

        case SystemType.SystemOfComponents:
            var f_data = Application.GetInstance()->all_entities->WithComponent(this.neededComponents)
            this._func(this._user_data, f_data, deltaTime)

        case SystemType.SystemOfNamedEntities:
            var f_data = Application.GetInstance()->all_entities->FindAllEntities(this.namedEntities)
            this._func(this._user_data, f_data, deltaTime)

    end select
end sub

public sub SystemList.ResetStartupIterator()
    this._ptr = NULL
end sub

public function SystemList.StartupIteratorNext() as SystemWrapper ptr
    if(this._ptr = NULL) then  
        this._ptr = this._s_list
    else
        this._ptr = this._ptr->_next
    end if

    if(this._ptr <> NULL) then
        return this._ptr->_system
    end if

    return 0
end function

public sub SystemList.ResetIterator()
    this._ptr = NULL
end sub

public function SystemList.IteratorNext() as SystemWrapper ptr
    if(this._ptr = NULL) then  
        this._ptr = this._list
    else
        this._ptr = this._ptr->_next
    end if

    if(this._ptr <> NULL) then
        return this._ptr->_system
    end if

    return 0
end function

destructor SystemListItem()
    if(this._system <> NULL) then
        delete this._system
    end if
end destructor

sub SystemList.AddStartupSystem(byval f as SystemFunction, byval ud as any ptr = NULL)
    var eli = new SystemListItem
    eli->_system = new SystemWrapper
    eli->_system->_type = SystemType.SystemStartup
    eli->_system->_user_data = ud
    eli->_system->_func = f
    eli->_next = NULL
    if(this._s_last <> NULL) then   
        this._s_last->_next = eli
        this._s_last = eli
    else
        this._s_list = eli
        this._s_last = eli
    end if
end sub

sub SystemList.AddComponentSystem(byref cname as string, byval f as SystemFunction, byval ud as any ptr = NULL, byval rps as long = 60)
    var eli = new SystemListItem
    eli->_system = new SystemWrapper
    eli->_system->_type = SystemType.SystemOfComponents
    eli->_system->_user_data = ud
    eli->_system->_func = f
    eli->_system->neededComponents = cname
    eli->_system->runsPerSecond = rps
    eli->_system->minDelay = 1/rps
    eli->_next = NULL
    if(this._last <> NULL) then   
        this._last->_next = eli
        this._last = eli
    else
        this._list = eli
        this._last = eli
    end if
    
end sub

sub SystemList.AddEntitySystem(byref ename as string, byval f as SystemFunction, byval ud as any ptr = NULL, byval rps as long = 60)
    var eli = new SystemListItem
    eli->_system = new SystemWrapper
    eli->_system->_type = SystemType.SystemOfNamedEntities
    eli->_system->_user_data = ud
    eli->_system->_func = f
    eli->_system->namedEntities = ename
    eli->_system->runsPerSecond = rps
    eli->_system->minDelay = 1/rps
    eli->_next = NULL
    if(this._last <> NULL) then   
        this._last->_next = eli
        this._last = eli
    else
        this._list = eli
        this._last = eli
    end if
    
end sub

sub SystemList.AddSystem(byval search_f as EntityListSearchFunction, byval f as SystemFunction, byval ud as any ptr = NULL, byval rps as long = 60)
    var eli = new SystemListItem
    eli->_system = new SystemWrapper
    eli->_system->_type = SystemType.SystemWithSearchFunction
    eli->_system->_user_data = ud
    eli->_system->_func = f
    eli->_system->search_function = search_f
    eli->_system->runsPerSecond = rps
    eli->_system->minDelay = 1/rps
    eli->_next = NULL
    if(this._last <> NULL) then   
        this._last->_next = eli
        this._last = eli
    else
        this._list = eli
        this._last = eli
    end if
end sub
