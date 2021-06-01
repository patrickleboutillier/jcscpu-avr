build: *.cpp *.h
	g++ -c -I. minihdl.cpp -o minihdl.o
	g++ -c -I. basic.cpp -o basic.o

clean:
	rm -f *.o

test: build
	g++ -c -I. test.cpp -o test.o
	g++ -o minihdl *.o
