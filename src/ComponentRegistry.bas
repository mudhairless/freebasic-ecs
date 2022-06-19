#include once "ecs/common.bi"
#include once "ecs/ComponentRegistry.bi"
#include once "ecs/Application.bi"

public destructor ComponentRegistryListItem()
    
end destructor

public destructor ComponentRegistry()
    Application.GetInstance()->_log(LogLevel.Debug, "Destroying Component Registry")
    if(this._list <> NULL) then
        this._last = NULL
        this._ptr = NULL
        var _next = this._list
        while(_next <> NULL)
            var cur = _next
            _next = cur->_next
            delete cur
        wend
    end if
end destructor

public sub ComponentRegistry.ResetIterator()
    this._ptr = NULL
end sub

public function ComponentRegistry.IteratorNext() as ComponentRegistryListItem ptr
    if(this._ptr = NULL) then  
        this._ptr = this._list
    else
        this._ptr = this._ptr->_next
    end if

    if(this._ptr <> NULL) then
        return this._ptr
    end if

    return NULL
end function

function ComponentRegistry.GetComponent(byref cname as string) as Component ptr
    this.ResetIterator()
    var _next = this.IteratorNext()
    while(_next <> NULL)
        if(_next->cname = cname) then
            Application.GetInstance()->_log(LogLevel.Debug, "Found instance of " & cname & " component")
            return _next->_component()
        end if
        _next = this.IteratorNext()
    wend
    Application.GetInstance()->_log(LogLevel.Debug, "Could not find instance of " & cname & " component")
    return 0
end function

sub ComponentRegistry.RegisterComponent(byref cname as string, byval c as ComponentCreationFunction)
    
    var existing = this.GetComponent(cname)
    if(existing = NULL) then
        Application.GetInstance()->_log(LogLevel.Debug, "Registering instance of " & cname & " component")
        if(this._last <> NULL) then
            Application.GetInstance()->_log(LogLevel.Debug, "Registry exists, adding component")
            var x = new ComponentRegistryListItem
            x->cname = cname
            x->_component = c
            this._last->_next = x
            this._last = x
        else
            Application.GetInstance()->_log(LogLevel.Debug, "Creating Component Registry")
            var x = new ComponentRegistryListItem
            x->cname = cname
            x->_component = c
            this._list = x
            this._last = x
        end if
    end if
end sub