' This is a loose port of the breakout clone example from Bevy
' https://github.com/bevyengine/bevy/blob/latest/examples/games/breakout.rs
' Status: incomplete

#include once "ecs/ecs.bi"
#include once "ecs/Components/Transform2D.bi"
#include once "ecs/Components/BoxCollider2D.bi"
#include once "ecs/Components/Sprite.bi"
#include once "fbgfx.bi"
using fb

const BRICK_WIDTH = 100f
const BRICK_HEIGHT = 30f
const BRICK_COLOR = RGB(128, 128, 255)

const WALL_THICKNESS = 10f
const WALL_COLOR = RGB(200, 200, 200)

function create_wall_entity(byval x as single, byval y as single) as Entity ptr
    var wall = new Entity
    wall->_name = "Wall"

    var transform = cast(Transform2D ptr, wall->AddComponent("Transform2D"))
    transform->x = x
    transform->y = y

    var collider = cast(Collider2D ptr, wall->AddComponent("Collider2D"))
    collider->width = WALL_THICKNESS
    collider->height = WALL_THICKNESS

    var sprite = cast(Sprite ptr, wall->AddComponent("Sprite"))
    sprite->image = imagecreate(WALL_THICKNESS, WALL_THICKNESS, WALL_COLOR)
    sprite->free_function = @imagedestroy

    return wall
end function

function create_brick_entity(byval x as single, byval y as single) as Entity ptr
    var brick = new Entity
    brick->_name = "Brick"
    
    var transform = cast(Transform2D ptr, brick->AddCopmonent("Transform2D"))
    transform->x = x
    transform->y = y

    var collider = cast(Collider2D ptr, brick->AddComponent("Collider2D"))
    collider->width = BRICK_COLOR
    collider->height = BRICK_HEIGHT

    var sprite = cast(Sprite ptr, brick->AddComponent("Sprite"))
    sprite->image = imagecreate(BRICK_WIDTH, BRICK_HEIGHT, BRICK_COLOR)
    sprite->free_function = @imagedestroy

    return brick
end function

sub sys_setup(byval _ud as any ptr, byval _entities as any ptr, byval deltaTime as single)
    var app = Application.GetInstance()

    sleep 1,1
    screenres 640, 480, 32
end sub

var app = Application.GetInstance()
app->LoggingLevel = LogLevel.Info


app->systems->AddStartupSystem(@sys_setup, NULL)


app->runApplication()