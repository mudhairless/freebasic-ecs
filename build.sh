#!/bin/sh

fbc -i inc -lib src/Entity.bas src/ComponentRegistry.bas src/Component.bas src/Transform2D.bas -x lib/libecs.a -g -w all
