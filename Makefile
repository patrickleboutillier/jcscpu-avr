modules: minihdl modules/*.yaml
	cd modules && ./gen.sh
	g++ -c -Iminihdl -Imodules modules/modules.cpp -o modules/modules.o
	for f in modules/*.yaml ; do name=$$(basename $$f .yaml) ; g++ -c -Iminihdl -Imodules modules/$$name.cpp -o modules/$$name.o || exit 1 ; done
	for f in modules/*.yaml ; do name=$$(basename $$f .yaml) ; g++ -o modules/$$name.test modules/$$name.o modules/modules.o minihdl/minihdl.o || exit 1 ; done
	for f in modules/*.yaml ; do name=$$(basename $$f .yaml) ; modules/$$name.test > sim/$$name.sim || exit 1; done


.PHONY: minihdl
minihdl: 
	make -C minihdl

clean:
	make -C minihdl clean
	rm -f modules/*.cpp modules/*.h modules/*.o modules/*.test sim/*.sim t/*.t t/*.tdata


test: modules
	prove -Iminihdl -It
