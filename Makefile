.PHONY : all
all: mort

CFLAGS := -std=c11

test: mort
	make -C t
	prove

.PHONY : clean
clean:
	rm -f mort
	make -C t clean
