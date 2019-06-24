CC ?= cc

VERSION := 0.1.0
BINDIR := bin
DEPDIR := deps
BINARY := simple-svc
CFLAGS := -lulfius -ljansson -lyder -lorcania -ljson-c 

$(BINDIR)/$(BINARY): $(BINDIR) clean
	$(CC) main.c $(DEPDIR)/log.c $(CFLAGS) -o $(BINDIR)/$(BINARY) 

$(BINDIR):
	mkdir -p $(BINDIR)

.PHONY: push
push:
	docker push briandowns/simple-svc:latest

.PHONY: deploy
deploy:
	kubectl -f ops/deployment.yaml
	kubectl -f ops/service.yaml

.PHONY: deps
deps: $(DEPDIR)
	git clone git@github.com:briandowns/struCtured-logger.git $(DEPDIR)

.PHONY:
clean:
	rm -f $(BINDIR)/*
