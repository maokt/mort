.PHONY : all
all: mort

CC := clang -std=c11

test: t
	make -C t
	prove

.PHONY : clean
clean:
	make -C t clean
	rm mort
