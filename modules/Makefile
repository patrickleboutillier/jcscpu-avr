SHELL := /bin/bash


YAMLS := $(wildcard *.yaml)
CPPS := $(addprefix out/, $(patsubst %.yaml,%.cpp,$(YAMLS)))
OS := $(patsubst %.cpp,%.o,$(CPPS))

# Create all the module object files.
modules: ../minihdl/minihdl.o out/modules.h out/modules.cpp $(CPPS) $(OS) 

out/modules.h: $(YAMLS)
	echo -e "#ifndef MODULES_H\n#define MODULES_H\n\n#include \"minihdl.h\"\n\n" > out/modules.h
	yq e .header *.yaml | grep -v '^---' >> out/modules.h
	echo -e "\n\n#endif" >> out/modules.h

out/modules.cpp: $(YAMLS)
	echo -e "#include \"modules.h\"\n" > out/modules.cpp
	yq e .source *.yaml | grep -v '^---' >> out/modules.cpp


TESTS := $(patsubst %.o,%.test,$(OS))
SIMS := $(addprefix ../sim/,$(patsubst %.yaml,%.sim,$(YAMLS)))
sim: modules $(TESTS) $(SIMS)


TDATAS := $(addprefix ../t/,$(patsubst %.yaml,%.tdata,$(YAMLS)))
test: $(TDATAS)
	for f in *.yaml ; do name=$$(basename $$f .yaml) ; rank=$$(printf "%02d" "$$(yq e .rank $$f)") ; yq e .testperl $$f > ../t/$${rank}_$${name}.t ; done


out/%.cpp: %.yaml
	echo -e "#include \"minihdl.h\"\n#include \"modules.h\"\n\nint main(){\ninit() ; \n" > $@
	yq e .test $< >> $@
	echo -e "done() ;\n}\n" >> $@

../t/%.tdata: %.yaml
	yq e .testdata $< > ../t/$@

out/%.o: out/%.cpp
	g++ -I../minihdl -I. -c $< -o $@

out/%.test: out/%.o out/modules.o
	g++ -o $@ $< out/modules.o ../minihdl/minihdl.o

../sim/%.sim: out/%.test
	$< > $@

clean:
	rm -f out/*.* ../sim/*.sim ../t/*.t ../t/*.tdata

