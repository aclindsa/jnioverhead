#BUILD_32_ON_64=True#uncomment to build 32-bit version on 64-bit Linux
#PERC=True#uncomment to run in PERC
#JAMAICA=True#uncomment to run and build with JamaicaVM
JNI_INCLUDE_DIR=/usr/lib/jvm/java-6-openjdk/include

CC=gcc
JAVA=java
JAVAC=javac
JAVAH=javah
SHAREDFLAGS=-Wall -o0
JNICFLAGS=$(SHAREDFLAGS) -fpic -shared -D_GNU_SOURCE
CFLAGS=$(SHAREDFLAGS)
ENV=

ifdef BUILD_32_ON_64
	SHAREDFLAGS += -m32
endif

ifdef PERC
	JAVA=/opt/perc/ultra5.3/bin/pvm
	JAVAC=/opt/perc/ultra5.3/bin/jdtc
	ENV=. /opt/perc/ultra5.3/bin/percenv.sh;
	JNI_INCLUDE_DIR=/opt/perc/ultra5.3/include
endif

ifdef JAMAICA
	JAVA=jamaicavm
	JAVAC=jamaicac
	JAVAH=jamaicah
	JNI_INCLUDE_DIR=/usr/local/jamaica-6.0-2/target/linux-x86/include
endif

#silence the command-printing
.SILENT:

all: build

build:
	#make sure the build directories exist
	mkdir -p bin/classes bin/lib
	echo Building everything...
	#compile all the Java files
	$(ENV) $(JAVAC) -d bin/classes src/OverheadTester.java
	#generate the JNI headers
	$(ENV) $(JAVAH) -classpath bin/classes -d src OverheadTester
	#compile the JNI C library code with the generated headers
	$(CC) $(JNICFLAGS) -o bin/lib/liboverhead.so -Isrc -I$(JNI_INCLUDE_DIR) src/OverheadTester.c
	#finally, compile the C code for the C test
	$(CC) $(CFLAGS) -o bin/overhead_tester -Isrc src/overhead_tester.c
	echo Done. Run \`sudo make run\` to run the tests.

run:
ifeq ($(shell /usr/bin/id -u), 0)
	mkdir -p results
	echo Running Java test...
	$(ENV) nice -n -20 taskset 0x00000001 $(JAVA) -Djava.library.path=./bin/lib -classpath bin/classes OverheadTester > results/java
#remove unnecessary one-line header from PERC output file
ifdef PERC
	sed -i '1d' results/java
endif
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
