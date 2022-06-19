#include once "ecs/common.bi"
#include once "ecs/Component.bi"
#include once "ecs/ComponentRegistry.bi"
#inclib "ecs"

type TestComponent extends Component
    as string _field1
    as long _field2
end type

function TestComponent_create() as Component ptr
    var x = new TestComponent
    x->cname = "TestComponent"
    return x
end function

var hasError = 0

var test1 = new ComponentRegistry
test1->RegisterComponent("TestComponent", @TestComponent_create)
var c = cast(TestComponent ptr, test1->GetComponent("TestComponent"))
var c2 = cast(TestComponent ptr, test1->GetComponent("TestComponent"))
var c4 = new TestComponent

if(c = NULL) then
    hasError = 1
    print "Component not found"
end if

if(c = c2) then
    hasError = 7
    print "both instances are the same object"
end if

delete c
delete c2

test1->ResetIterator()
var _next = test1->IteratorNext()
var cnt = 0
while(_next <> NULL)
    cnt += 1
    _next = test1->IteratorNext()
wend

if(cnt <> 1) then
    hasError = 4
    print "invalid number of components registered"
end if

var c3 = test1->GetComponent("DoesNotExist")

if(c3 <> NULL) then
    hasError = 5
    delete c3
    print "error did not return null for invalid component"
end if

delete test1

if(hasError = 0) then
    print "*** TestComponentRegistry all tests passed ***"
else
    print "*** TestComponentRegistry test failure " & hasError & " ***"
end if