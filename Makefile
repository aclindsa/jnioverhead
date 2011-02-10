CC=gcc
JNICFLAGS=-Wall -fpic -shared -o0 -D_GNU_SOURCE
CFLAGS=-Wall -o0
JNI_INCLUDE_DIR=/usr/lib/jvm/java-6-openjdk/include

#silence the command-printing
.SILENT:

all: build

build:
	#make sure the build directories exist
	mkdir -p bin/classes bin/lib
	echo Building everything...
	#compile all the Java files
	javac -d bin/classes src/OverheadTester.java
	#generate the JNI headers
	javah -classpath bin/classes -d src OverheadTester
	#compile the JNI C library code with the generated headers
	$(CC) $(JNICFLAGS) -o bin/lib/liboverhead.so -Isrc -I$(JNI_INCLUDE_DIR) src/OverheadTester.c
	#finally, compile the C code for the C test
	$(CC) $(CFLAGS) -o bin/overhead_tester -Isrc src/overhead_tester.c
	echo Done. Run \`sudo make run\` to run the tests.

run:
ifeq ($(shell /usr/bin/id -u), 0)
	mkdir -p results
	echo Running Java test...
	nice -n -20 taskset 0x00000001 java -Djava.library.path=./bin/lib -cp bin/classes OverheadTester > results/java
	echo Running C test...
	nice -n -20 taskset 0x00000001 bin/overhead_tester > results/c
	#fix the permissions so 'make clean' doesn't barf if not run with sudo
	sudo chmod -R 777 results
	echo
	./stats.py
else
	echo "Please run with sudo (required for 'nice')"
endif

clean:
	rm -rf bin results
