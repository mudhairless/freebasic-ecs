#include once "ecs/Component.bi"
#include once "ecs/ComponentRegistry.bi"
#inclib "ecs"

type TestComponent extends Component
    as string _field1
    as long _field2
    declare function create(byref cname as const string) as Component ptr
end type

function TestComponent.create(byref cname as const string) as Component ptr
    var x = new TestComponent
    x->cname = cname
    return x
end function

var hasError = 0

var test1 = new ComponentRegistry
var register = new TestComponent
register->_field2 = 32
test1->RegisterComponent("TestComponent", register)
var c = cast(TestComponent ptr, test1->GetComponent("TestComponent"))
var c2 = cast(TestComponent ptr, test1->GetComponent("TestComponent"))
var c4 = new TestComponent

if(c = 0) then
    hasError = 1
    print "Component not found"
end if

if(c = register) then
    hasError = 2
    print "retrieved component is registered component"
end if

c->_field1 = "test"
c->_field2 = 32

if(c->_field2 = register->_field2) then
    hasError = 3
    print "instance field matches registered component"
end if

if(c = c2) then
    hasError = 7
    print "both instances are the same object"
end if

delete c

test1->ResetIterator()
var _next = test1->IteratorNext()
var cnt = 0
while(_next <> 0)
    cnt += 1
    _next = test1->IteratorNext()
wend

if(cnt <> 1) then
    hasError = 4
    print "invalid number of components registered"
end if

var c3 = test1->GetComponent("DoesNotExist")

if(c3 <> 0) then
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