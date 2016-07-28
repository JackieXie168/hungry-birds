OS := $(shell uname -s)

EXEC = pc-test
.PHONY: all
all: $(EXEC)

CC ?= gcc
CFLAGS = -std=c11 -Wall -g
ifeq ($(OS),Darwin)
CFLAGS += -I. -I/opt/local/include -I/usr/include/sys -I$HOME/include
LDFLAGS = -L/opt/local/lib -lpth
else
ifeq ($(OS),Linux)
LDFLAGS = -lpthread
endif
endif

OBJS := \
    pc-test.o \
    queue.o

deps := $(OBJS:%.o=.%.o.d)

%.o: %.c
	$(CC) $(CFLAGS) -c -MMD -MF .$@.d -o $@ $<

$(EXEC): $(OBJS)
	$(CC) -o $@ $^ $(LDFLAGS)

check: $(EXEC)
	./$(EXEC)

clean:
	$(RM) $(EXEC) $(OBJS) $(deps)

-include $(deps)
