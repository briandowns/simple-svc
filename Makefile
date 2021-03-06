CC ?= cc

VERSION := 0.1.0
BINDIR  := bin
DEPDIR  := deps
BINARY  := simple-svc
LDFLAGS := -lulfius -ljansson -lyder -lorcania -ljson-c 
CFLAGS  := -Dgit_sha=$(shell git rev-parse HEAD)

$(BINDIR)/$(BINARY): $(BINDIR) clean
	$(CC) main.c $(DEPDIR)/logger.c $(CFLAGS) -o $@ $(LDFLAGS)

$(BINDIR):
	mkdir -p $@

.PHONY: push
push:
	docker push briandowns/$(BINARY):latest

.PHONY: deploy
deploy:
	kubectl apply -f ops/deployment.yaml
	kubectl apply -f ops/service.yaml

.PHONY: deps
deps: $(DEPDIR)
	git clone git@github.com:briandowns/liblogger.git $(DEPDIR)

.PHONY:
clean:
	rm -f $(BINDIR)/*
