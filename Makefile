.PHONY : all
all: mort

CFLAGS := -std=c11

test: t
	make -C t
	prove

.PHONY : clean
clean:
	rm -f mort
	make -C t clean
