CC ?= cc

VERSION := 0.1.0
BINDIR := bin
DEPDIR := deps
BINARY := simple-svc
CFLAGS := -lulfius -ljansson -lyder -lorcania -ljson-c

$(BINDIR)/$(BINARY): $(BINDIR) clean
	$(CC) -Dgit_sha="$(git rev-parse HEAD)" main.c $(DEPDIR)/log.c $(CFLAGS) -o $(BINDIR)/$(BINARY) 

$(BINDIR):
	mkdir -p $(BINDIR)

$(DEPDIR):
	mkdir -p $(DEPDIR)

.PHONY: deps
deps: $(DEPDIR)
	git clone git@github.com:briandowns/struCtured-logger.git $(DEPDIR)

.PHONY:
clean:
	rm -f $(BINDIR)/*
