.PHONY: modules
modules: 
	make -C modules modules


.PHONY: minihdl
minihdl: 
	make -C minihdl minihdl.o


clean:
	make -C minihdl clean
	make -C modules clean


test: modules
	make -C modules sim test
	prove -Iminihdl -It
