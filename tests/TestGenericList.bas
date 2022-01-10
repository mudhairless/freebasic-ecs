#include once "ecs/GenericList.bi"
#inclib "ecs"

var hasError = 0

var list1 = new GenericList

if(list1->count() <> 0) then
    print "Invalid list item count after creation"
    hasError = 1
end if

var item1 = new long
var item2 = new long
var item3 = new long

list1->AddItem(item1)
if(list1->count() <> 1) then
    print "Invalid list item count after adding item"
    hasError = 2
end if

list1->AddItem(item2)
if(list1->count() <> 2) then
    print "Invalid list item count after adding item"
    hasError = 3
end if

list1->AddItem(item1)
if(list1->count() <> 3) then
    print "Invalid list item count after adding item"
    hasError = 4
end if

list1->RemoveItem(item2)
if(list1->count() <> 2) then
    print "Invalid list item count after removing item"
    hasError = 5
end if

var list2 = new GenericList(*list1)
if(list2->count() <> 2) then
    print "Invalid list item count after copy constructor"
    hasError = 6
end if

dim as GenericList list3 = *list1 + *list2
if(list3.count() <> 4) then
    print "Invalid list item count after concating lists"
    hasError = 7
end if

var list4 = new GenericList
var list5 = new GenericList
dim as GenericList list6 = *list4 + *list5
if(list6.count() <> 0) then
    print "Invalid list item count after concating empty lists"
    hasError = 8
end if

if(hasError = 0) then
    print "*** TestGenericList all tests passed ***"
else
    print "*** TestGenericList test failure " & hasError & " ***"
end if

delete item1
delete item2
delete item3
delete list1
delete list2
delete list4
delete list5