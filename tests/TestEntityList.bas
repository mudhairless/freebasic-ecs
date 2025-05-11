#include once "ecs/common.bi"
#include once "ecs/Application.bi"
#include once "ecs/Component.bi"
#include once "ecs/Entity.bi"
#include once "ecs/EntityList.bi"
#inclib "ecs"

' Define our Components
type ComponentA extends Component
    as integer a
end type

function componenta_create() as Component ptr
    var ret = new ComponentA
    ret->cname = "ComponentA"
    return ret
end function

type ComponentB extends Component
    as integer b
end type

function componentb_create() as Component ptr
    var ret = new ComponentB
    ret->cname = "ComponentB"
    return ret
end function

type ComponentC extends Component
    as integer c
end type

function componentc_create() as Component ptr
    var ret = new ComponentC
    ret->cname = "ComponentC"
    return ret
end function

sub print_entity_list(byval list as EntityList ptr)
    list->ResetIterator()
    var _next = list->IteratorNext()
    while (_next <> NULL)
        ? _next->_name & " ";
        _next = list->IteratorNext()
    wend
    ?
end sub

' Register our Components
var app = Application.GetInstance()
app->component_registry->RegisterComponent("ComponentA", @componenta_create)
app->component_registry->RegisterComponent("ComponentB", @componentb_create)
app->component_registry->RegisterComponent("ComponentC", @componentc_create)

var hasError = 0
' Setup our Entity List
var list = new EntityList

var entityA = new Entity
entityA->_name = "EntityA"
entityA->AddComponent("ComponentA")
list->AddEntity(entityA)

if (list->count() <> 1) then
    ? "List should just be A"
    print_entity_list(list)
    hasError = 1
    ?
end if

var entityB = new Entity
entityB->_name = "EntityB"
entityB->AddComponent("ComponentA")
entityB->AddComponent("ComponentB")
list->AddEntity(entityB)

if (list->count() <> 2) then
    ? "List should be A and B"
    print_entity_list(list)
    hasError = 2
    ?
end if

var entityC = new Entity
entityC->_name = "EntityC"
entityC->AddComponent("ComponentA")
entityC->AddComponent("ComponentB")
entityC->AddComponent("ComponentC")
list->AddEntity(entityC)

if (list->count() <> 3) then
    ? "List should be A, B, C"
    print_entity_list(list)
    hasError = 3
    ?
end if

' Search the list for just items that have an A
var searchListA = list->WithComponent("ComponentA")
var count = searchListA->count()

if (count <> 3) then
    ? "countA: " & count
    ? "Entities with A List:"
    print_entity_list(searchListA)
    hasError = 4
    ?
end if

' Search for items with A and B
var searchListB = list->WithComponent("ComponentA|ComponentB")
count = searchListB->count()

if (searchListB->count() <> 2) then
    ? "countB: " & count
    ? "Entities with A and B List:"
    print_entity_list(searchListB)
    hasError = 5
    ?
end if

' Search for items with just a B
var searchListC = list->WithComponent("ComponentB")
count = searchListC->count()

if (count <> 2) then
    ? "countC: " & count
    ? "Entities with B List:"
    print_entity_list(searchListC)
    hasError = 6
    ?
end if

' Search for items with just a C
var searchListD = list->WithComponent("ComponentC")
count = searchListD->count()

if (count <> 1) then
    ? "countD: " & count
    ? "Entities with C List:"
    print_entity_list(searchListD)
    hasError = 7
    ?
end if

' Search for items with A and B and C
var searchListE = list->WithComponent("ComponentA|ComponentB|ComponentC")
count = searchListE->count()

if (searchListE->count() <> 1) then
    ? "countE: " & count
    ? "Entities with A and B and C List:"
    print_entity_list(searchListE)
    hasError = 8
    ?
end if

if(hasError = 0) then
    print "*** TestEntityList all tests passed ***"
else
    print "*** TestEntityList test failure " & hasError & " ***"
end if