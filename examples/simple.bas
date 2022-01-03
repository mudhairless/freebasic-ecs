#include once "ecs/ecs.bi"
#include once "fbgfx.bi"

using FB

type Location extends Component
    as single x, y
end type

type Drawable extends Component
    as long r
end type

Entity.RegisterComponent("Location", new Location())
Entity.RegisterComponent("Drawable", new Drawable())

sub sys_setup(byval _app as any ptr, byval _ud as any ptr, byval _data as any ptr, byval deltaTime as single)
    screenres 640, 480, 32
    
end sub

sub drawable_system(byval _app as any ptr, byval _ud as any ptr, byval _data as any ptr, byval deltaTime as single)
    
    screenlock
    cls
    var _next = (cast(EntityList ptr, _data))->_list
    if(_next <> 0) then
        do
            var _cur = _next
            if(_cur <> 0) then
                var _entity = _cur->_entity
                var _drawable = GET_COMPONENT(_entity, Drawable)
                var _loc = GET_COMPONENT(_entity, Location)
                if(_loc <> 0 and _drawable <> 0) then
                    circle (clng(_loc->x), clng(_loc->y)), _drawable->r, &hFFFFFF
                    paint (clng(_loc->x), clng(_loc->y)), &hFFFFFF, &hFFFFFF
                end if
                _next = _cur->_next
            end if
        loop until _next = 0
    end if
    screenunlock
end sub

sub input_handler(byval _app as any ptr, byval _ud as any ptr, byval _data as any ptr, byval deltaTime as single)
    
    var _next = (cast(EntityList ptr, _data))->_list
    
    if(_next <> 0) then
        do
            var _cur = _next
            if(_cur <> 0) then
                var _entity = _cur->_entity
                var _drawable = GET_COMPONENT(_entity, Drawable)
                var _loc = GET_COMPONENT(_entity, Location)
                if(_loc <> 0 and _drawable <> 0) then
                    If MultiKey(SC_LEFT ) And _loc->x >   0 Then _loc->x = _loc->x - (50 * deltaTime)
                    If MultiKey(SC_RIGHT) And _loc->x < 640 Then _loc-> x = _loc->x + (50 * deltaTime)
                    If MultiKey(SC_UP   ) And _loc->y >   0 Then _loc->y = _loc->y - (50 * deltaTime)
                    If MultiKey(SC_DOWN ) And _loc->y < 480 Then _loc->y = _loc->y + (50 * deltaTime)
                    If MultiKey(SC_ESCAPE) then GET_APP(_app)->exitApplication()
                end if
                _next = _cur->_next
            end if
        loop until _next = 0
    end if
    'While Inkey <> "": Wend
end sub


var app = new Application()

var player = app->AddEntity("Player")

var ploc = ADD_COMPONENT(player, Location)
ploc->x = 160
ploc->y = 120

var pdraw = ADD_COMPONENT(player, Drawable)
pdraw->r = 10

app->systems->AddStartupSystem(@sys_setup, 0)
app->systems->AddComponentSystem("Drawable", @drawable_system, 0)
app->systems->AddEntitySystem("Player", @input_handler, 0)

app->runApplication()