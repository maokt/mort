.PHONY : all
all: mort

test: mort
	make -C t
	prove

.PHONY : clean
clean:
	rm -f mort
	make -C t clean
