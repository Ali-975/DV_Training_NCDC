CC=gcc
CFLAGS=-Wall -std=c99 -g

all: test_vector

test_vector: vector.o test_vector.o
	$(CC) -o test_vector vector.o test_vector.o

vector.o: vector.c vector.h
	$(CC) $(CFLAGS) -c vector.c

test_vector.o: test_vector.c vector.h
	$(CC) $(CFLAGS) -c test_vector.c

clean:
	rm test_vector vector.o test_vector.o
