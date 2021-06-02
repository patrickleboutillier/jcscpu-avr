#!/bin/bash

cat <<H > out/modules.h
#ifndef MODULES_H
#define MODULES_H

#include "minihdl.h"

H

cat <<H > out/modules.cpp
#include "modules.h"

H


for f in *.yaml ; do
	name=$(basename $f .yaml)
	yq e .header $f >> out/modules.h
	yq e .source $f >> out/modules.cpp
	rank=$(printf "%02d" "$(yq e .rank $f)")
	yq e .testperl $f > ../t/${rank}_$name.t
	yq e .testdata $f > ../t/$name.tdata

	#echo -e "#include \"minihdl.h\"\n#include \"modules.h\"\n\nint main(){\ninit() ; \n" > out/$name.cpp
	#yq e .test $f >> out/$name.cpp
	#echo -e "done() ;\n}\n" >> out/$name.cpp
done

cat <<H >> out/modules.h

#endif 
H

