#include once "ecs/ecs.bi"
#include once "fbgfx.bi"

using FB

type Location extends Component
    as single x, y
end type

type Drawable extends Component
    as long r
end type

type PaintColor
    as long _color
end type

function location_component_create() as Component ptr
    var ret = new Location
    ret->cname = "Location"
    return ret
end function

function drawable_component_create() as Component ptr
    var ret = new Drawable
    ret->cname = "Drawable"
    return ret
end function

sub sys_setup(byval _ud as any ptr, byval _entities as any ptr, byval deltaTime as single)
    var app = Application.GetInstance()
    var player = app->AddEntity("Player")

    var ploc = ADD_COMPONENT(player, Location)
    ploc->x = 160
    ploc->y = 120

    var pdraw = ADD_COMPONENT(player, Drawable)
    pdraw->r = 10

    var pc = new PaintColor
    pc->_color = &hFFFF00
    app->AddResource("PaintColor", pc, 0)
    
    sleep 1,1
    screenres 640, 480, 32
end sub

sub drawable_system(byval _ud as any ptr, byval _entities as any ptr, byval deltaTime as single)
    var app = Application.GetInstance()
    var pc = GET_RESOURCE(app, PaintColor) 'shortcut when the resource name matches the type name

    screenlock
    cls
    var entities = GET_ENTLIST(_entities)
    entities->ResetIterator()
    var _entity = entities->IteratorNext()
    while(_entity <> 0)
        var _drawable = GET_COMPONENT(_entity, Drawable)
        var _loc = GET_COMPONENT(_entity, Location)
        if(_loc <> 0 and _drawable <> 0) then
            circle (clng(_loc->x), clng(_loc->y)), _drawable->r, pc->_color
            paint (clng(_loc->x), clng(_loc->y)), pc->_color, pc->_color
        end if
        _entity = entities->IteratorNext()
    wend
    screenunlock
end sub

sub input_handler(byval _ud as any ptr, byval _entities as any ptr, byval deltaTime as single)
    var app = Application.GetInstance()
    var entities = GET_ENTLIST(_entities)
    entities->ResetIterator()
    var _entity = entities->IteratorNext()
    while(_entity <> 0)
        var _drawable = GET_COMPONENT(_entity, Drawable)
        var _loc = GET_COMPONENT(_entity, Location)
        if(_loc <> 0 and _drawable <> 0) then
            If MultiKey(SC_LEFT ) And _loc->x >   0 Then _loc->x = _loc->x - (150 * deltaTime)
            If MultiKey(SC_RIGHT) And _loc->x < 640 Then _loc-> x = _loc->x + (150 * deltaTime)
            If MultiKey(SC_UP   ) And _loc->y >   0 Then _loc->y = _loc->y - (150 * deltaTime)
            If MultiKey(SC_DOWN ) And _loc->y < 480 Then _loc->y = _loc->y + (150 * deltaTime)
            If MultiKey(SC_ESCAPE) then app->exitApplication()
            If MultiKey(SC_X) then 
                var pc = GET_RESOURCE(app, PaintColor)
                pc->_color = &hFF0000
            end if
            If MultiKey(SC_C) then 
                var pc = GET_RESOURCE(app, PaintColor)
                pc->_color = &h0000FF
            end if
            If MultiKey(SC_Z) then 
                var pc = GET_RESOURCE(app, PaintColor)
                pc->_color = &hFFFF00
            end if
        end if
        _entity = entities->IteratorNext()
    wend
end sub

var app = Application.GetInstance()
app->loggingLevel = LogLevel.Debug

app->component_registry->RegisterComponent("Location", @location_component_create)
app->component_registry->RegisterComponent("Drawable", @drawable_component_create)

app->systems->AddStartupSystem(@sys_setup, 0)
app->systems->AddComponentSystem("Drawable", @drawable_system, 0)
app->systems->AddEntitySystem("Player", @input_handler, 0)

app->runApplication()
