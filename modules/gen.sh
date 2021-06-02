#!/bin/bash

cat <<H > modules.h
#ifndef MODULES_H
#define MODULES_H

#include "minihdl.h"

H

cat <<H > modules.cpp
#include "modules.h"

H


for f in *.yaml ; do
	name=$(basename $f .yaml)
	yq e .header $f >> modules.h
	yq e .source $f >> modules.cpp
	rank=$(printf "%02d" "$(yq e .rank $f)")
	yq e .testperl $f > ../t/${rank}_$name.t
	yq e .testdata $f > ../t/$name.tdata

	echo -e "#include \"minihdl.h\"\n#include \"modules.h\"\n\nint main(){\ninit() ; \n" > $name.cpp
	yq e .test $f >> $name.cpp
	echo -e "done() ;\n}\n" >> $name.cpp
done

cat <<H >> modules.h

#endif 
H

