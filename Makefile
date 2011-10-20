MYLIBS=
COMPILER=ghc
GHCPRE=$(COMPILER) --make -O3 -i$(MYLIBS) -threaded

resuscitate: Resuscitate.hs
	$(GHCPRE) -o resuscitate Resuscitate.hs

clean:
	rm -rf resuscitate *.hi *.o

all: resuscitate
	exit

test: resuscitate
	./resuscitate false

install: resuscitate
	install -Sc resuscitate /usr/local/bin
