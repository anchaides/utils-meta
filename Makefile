DIRNAME := $(shell basename $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

.phony: all build 
all: build

build:    
	makepkg -si --noconfirm 


