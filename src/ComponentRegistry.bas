#include once "ecs/ComponentRegistry.bi"
#include once "ecs/Application.bi"

public destructor ComponentListItem()
    delete this._component
end destructor

public destructor ComponentRegistry()
    Application.GetInstance()->_log(LogLevel.Debug, "Destroying Component Registry")
    if(this._list <> 0) then
        this._last = 0
        this._ptr = 0
        var _next = this._list
        while(_next <> 0)
            var cur = _next
            _next = cur->_next
            delete cur
        wend
    end if
end destructor

public sub ComponentRegistry.ResetIterator()
    this._ptr = 0
end sub

public function ComponentRegistry.IteratorNext() as Component ptr
    if(this._ptr = 0) then  
        this._ptr = this._list
    else
        this._ptr = this._ptr->_next
    end if

    if(this._ptr <> 0) then
        return this._ptr->_component
    end if

    return 0
end function

function ComponentRegistry.GetComponent(byref cname as string) as Component ptr
    this.ResetIterator()
    var _next = this.IteratorNext()
    while(_next <> 0)
        if(_next->cname = cname) then
            Application.GetInstance()->_log(LogLevel.Debug, "Found instance of " & cname & " component")
            return _next->create(cname)
        end if
        _next = this.IteratorNext()
    wend
    Application.GetInstance()->_log(LogLevel.Debug, "Could not find instance of " & cname & " component")
    return 0
end function

sub ComponentRegistry.RegisterComponent(byref cname as string, byval c as Component ptr)
    
    var existing = this.GetComponent(cname)
    if(existing = 0) then
        if(c->cname <> cname) then
            c->cname = cname
        end if
        Application.GetInstance()->_log(LogLevel.Debug, "Registering instance of " & cname & " component")
        if(this._last <> 0) then
            Application.GetInstance()->_log(LogLevel.Debug, "List exists, adding component")
            var x = new ComponentListItem
            x->_component = c
            this._last->_next = x
            this._last = x
        else
            Application.GetInstance()->_log(LogLevel.Debug, "New Component list")
            var x = new ComponentListItem
            x->_component = c
            this._list = x
            this._last = x
        end if
    end if

    this.ResetIterator()
    var _next = this.IteratorNext()
    while(_next <> 0)
        Application.GetInstance()->_log(LogLevel.Debug, "Registered Component: " & _next->cname)
        _next = this.IteratorNext()
    wend
end sub