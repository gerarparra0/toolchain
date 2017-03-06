ARCH = i686-elf
BINVER = binutils-2.27
GCCVER = gcc-6.3.0

TOOL = toolchain
DIR = toolchain/src
BINBUILD = $(DIR)/build-binutils
GCCBUILD = $(DIR)/build-gcc

BUILDBIN = $(DIR)/$(BINVER)

.PHONY: all clean
all : install-binutils install-gcc

clean :
	rm -rf $(TOOL)

reqs :
	mkdir -p $(DIR) $(BINBUILD) $(GCCBUILD)

get-binutils : reqs
	wget ftp://ftp.gnu.org/gnu/binutils/$(BINVER).tar.bz2 -P $(DIR)
	tar -xvf $(DIR)/$(BINVER).tar.bz2 -C $(DIR)
	
install-binutils : get-binutils
	export PREFIX="$$HOME/dev/toolchain" && \
	export TARGET=$(ARCH) && \
	export PATH="$$PREFIX/bin:$$PATH" && \
	cd $(BINBUILD) && ../$(BINVER)/configure --target=$$TARGET --prefix="$$PREFIX" --with-sysroot --disable-nls --disable-werror && \
	make -j8 && \
	make install -j8
	
get-gcc : reqs
	wget ftp://ftp.gnu.org/gnu/gcc/$(GCCVER)/$(GCCVER).tar.bz2 -P $(DIR)
	tar -xvf $(DIR)/$(GCCVER).tar.bz2 -C $(DIR)
	cd $(DIR)/$(GCCVER) && \
	contrib/download_prerequisites
	
install-gcc : get-gcc
	export PREFIX="$$HOME/dev/toolchain" && \
	export TARGET=$(ARCH) && \
	export PATH="$$PREFIX/bin:$$PATH" && \
	cd $(GCCBUILD) && ../$(GCCVER)/configure --target=$$TARGET --prefix="$$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers && \
	make all-gcc -j8 && \
	make all-target-libgcc -j8 && \
	make install-gcc -j8 && \
	make install-target-libgcc -j8
