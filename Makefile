#!/bin/bash

CC = g++
FLAGS = 
TAG = test

TOPDIR = $(PWD)

OBJDIR = $(TOPDIR)/obj
BINDIR = $(TOPDIR)/bin
SRCDIR = $(TOPDIR)/src
INCDIR = $(TOPDIR)/include
LIBDIR = $(TOPDIR)/lib

#EXAMPLE = $(TOPDIR)/example
#INCLUDE = -I/home/oeasy/install/opencv-3.4.0/build_install/include 
#LIB = -L/home/oeasy/install/opencv-3.4.0/build_install/lib -L$(TOPDIR)/src/kernel
#LDL = -lopencv_core -lopencv_highgui -lopencv_imgproc -lopencv_imgcodecs -fpermissive #-lfacedetectcnn

#INC = -I./src/kernel 

EXAMPLE = $(TOPDIR)/example
INCLUDE = -I/usr/local/include 
LIB = -L/usr/local/lib -L$(TOPDIR)/src
LDL = -lopencv_core -lopencv_highgui -lopencv_imgproc -lopencv_imgcodecs -fpermissive -lfacedetectcnn

INC = -I./src


export CC TAG TOPDIR SUBDIR OBJDIR BINDIR INC #导出全局变量 
all:CHECK $(SRCDIR) $(TAG) 

CHECK:
	mkdir -p $(OBJDIR) $(BINDIR) $(INCDIR) $(LIBDIR)

$(SRCDIR):ECHO
	make -C $@



$(TAG):
	$(CC) -o  $(addprefix $(BINDIR)/,$(TAG))   $(EXAMPLE)/libfacedetectcnn-example.cpp  $(INC) $(INCLUDE) $(LIB) $(LDL) 


install:
	cp $(SRCDIR)/*.h $(INCDIR)
	cp $(SRCDIR)/*.so $(LIBDIR)
	sudo cp $(LIBDIR)/*.so /usr/local/lib/
	sudo ldconfig
ECHO:  
	@echo $@


CLEANDIR:ECHO
	make -C $(SRCDIR) clean

.PHONY : clean
clean :CLEANDIR
	-rm $(BINDIR)/$(TAG)
	-rm -rf $(INCDIR)
	-rm -rf $(LIBDIR)
