modules: hdl modules/*.yaml
	cd modules && ./gen.sh
	g++ -c -Iminihdl -Imodules modules/modules.cpp -o modules/modules.o
	for f in modules/*.yaml ; do name=$$(basename $$f .yaml) ; g++ -c -Iminihdl -Imodules modules/$$name.cpp -o modules/$$name.o || exit 1; done
	for f in modules/*.yaml ; do name=$$(basename $$f .yaml) ; g++ -o modules/$$name.test modules/$$name.o modules/modules.o minihdl/minihdl.o || exit 1; done
	for f in modules/*.yaml ; do name=$$(basename $$f .yaml) ; modules/$$name.test > sim/$$name.sim || exit 1; done


hdl: minihdl/minihdl.cpp minihdl/minihdl.h
	g++ -c -Iminihdl minihdl/minihdl.cpp -o minihdl/minihdl.o

clean:
	rm -f minihdl/minihdl.o modules/*.cpp modules/*.h modules/*.o modules/*.test sim/*.sim t/*.t


test: modules
	prove -Iminihdl -It
