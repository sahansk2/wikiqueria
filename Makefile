# =================== SETTINGS ===================
EXENAME = finalproj

CXX			:=	clang++
CXXFLAGS	:=	$(CS225) -std=c++1y -stdlib=libc++ -c -g -O0 -Wall -Wextra -pedantic -Iheaders
LD			:=	clang++
LDFLAGS		:=	-std=c++1y -stdlib=libc++ -lc++abi -lm -Iheaders
ALL_HEADERS	:=	headers/BFS.h headers/Edge.h headers/FullBFS.h headers/Graph.h headers/Mock.h headers/SCCGraph.h headers/Vertex.h
#----------------------------------------------

define make-build-dir
	@mkdir -p build
endef 

.PHONY: all-data all clean

# $^ = all dependencies
# $< = first dependency
# $@ = target

all : $(EXENAME)

$(EXENAME): build/main.o build/Graph.o build/Vertex.o build/Edge.o build/BFS.o build/Mock.o build/SCCGraph.o build/FullBFS.o
	$(LD) $^ $(LDFLAGS) -o $(EXENAME)

build/readFromFile.o: src/readFromFile.cpp headers/readFromFile.hpp
	$(make-build-dir)
	$(CXX) $(CXXFLAGS) $< -o $@ 

build/main.o: src/main.cpp headers/Graph.h headers/Vertex.h headers/Edge.h headers/SCCGraph.h
	$(make-build-dir)
	$(CXX) $(CXXFLAGS) $< -o $@

build/SCCGraph.o: src/SCCGraph/SCCGraph.cpp headers/SCCGraph.h headers/Graph.h
	$(make-build-dir)
	$(CXX) $(CXXFLAGS) $< -o $@

build/Graph.o: src/GraphADT/Graph.cpp headers/Graph.h headers/Vertex.h headers/Edge.h
	$(make-build-dir)
	$(CXX) $(CXXFLAGS) $< -o $@

build/Vertex.o: src/GraphADT/Vertex.cpp headers/Vertex.h
	$(make-build-dir)
	$(CXX) $(CXXFLAGS) $< -o $@

build/Edge.o: src/GraphADT/Edge.cpp headers/Edge.h
	$(make-build-dir)
	$(CXX) $(CXXFLAGS) $< -o $@

build/Mock.o: src/Mock/Mock.cpp headers/Mock.h
	$(make-build-dir)
	$(CXX) $(CXXFLAGS) $< -o $@

build/BFS.o: src/BFS/BFS.cpp headers/Graph.h headers/Vertex.h headers/Edge.h headers/BFS.h
	$(make-build-dir)
	$(CXX) $(CXXFLAGS) $< -o $@

build/FullBFS.o: src/BFS/FullBFS.cpp headers/Graph.h headers/Vertex.h headers/Edge.h headers/FullBFS.h headers/BFS.h
	$(make-build-dir)
	$(CXX) $(CXXFLAGS) $< -o $@

build/catch.o: tests/catch.cpp tests/catch.hpp
	$(make-build-dir)
	$(CXX) $(CXXFLAGS) $< -o $@

test: build/tests-misc.o build/tests-bfs.o build/tests-graphadt.o build/tests-scc.o build/tests-landmark.o build/catch.o build/Vertex.o build/Graph.o build/Edge.o build/BFS.o build/Mock.o build/SCCGraph.o build/FullBFS.o
	$(LD) $^ $(LDFLAGS) -o test

build/tests-misc.o: tests/tests-misc.cpp $(ALL_HEADERS)
	$(make-build-dir)
	$(CXX) $(CXXFLAGS) $< -o $@

build/tests-bfs.o: tests/tests-bfs.cpp $(ALL_HEADERS)
	$(make-build-dir)
	$(CXX) $(CXXFLAGS) $< -o $@

build/tests-graphadt.o: tests/tests-graphadt.cpp $(ALL_HEADERS)
	$(make-build-dir)
	$(CXX) $(CXXFLAGS) $< -o $@

build/tests-scc.o: tests/tests-scc.cpp $(ALL_HEADERS)
	$(make-build-dir)
	$(CXX) $(CXXFLAGS) $< -o $@

build/tests-landmark.o: tests/tests-landmark.cpp $(ALL_HEADERS)
	$(make-build-dir)
	$(CXX) $(CXXFLAGS) $< -o $@

clean:
	rm -rf build/ $(EXENAME) test

# =================== CREATE DATA ===================

all-data: data/enwiki-2013-names.csv data/enwiki-2013.txt

data/enwiki-2013-names.csv: data
	curl --output data/enwiki-2013-names.csv.gz 'https://snap.stanford.edu/data/enwiki-2013-names.csv.gz'
	gunzip -d data/enwiki-2013-names.csv.gz 

data/enwiki-2013.txt: data
	curl --output data/enwiki-2013.txt.gz 'https://snap.stanford.edu/data/enwiki-2013.txt.gz'
	gunzip -d data/enwiki-2013.txt.gz

data:
	mkdir data