PROGRAM_NAME=hello-world
GDB_PORT=10101

.PHONY: clean build dbg

CC=arm-none-eabi-gcc
LD=arm-none-eabi-ld
AS=arm-none-eabi-as
ASFLAGS=-mcpu=cortex-m0plus -mthumb -gstabs
CFLAGS=-save-temps

$(PROGRAM_NAME): $(PROGRAM_NAME).o
	$(LD) $? -o $@

$(PROGRAM_NAME).s: $(PROGRAM_NAME).S

clean:
	# rm $(PROGRAM_NAME).s
	rm $(PROGRAM_NAME).o $(PROGRAM_NAME)

build: $(PROGRAM_NAME)

run: $(PROGRAM_NAME)
	qemu-arm-static -cpu cortex-m0 -g $(GDB_PORT) $(PROGRAM_NAME)

dbg: $(PROGRAM_NAME)
	gdb-multiarch -q \
		-ex "set confirm off" \
		-ex "file $(PROGRAM_NAME)" \
		-ex "target remote localhost:$(GDB_PORT)" \
		-ex "set confirm on" \
		# -ex "layout arm"

		# -ex "break _start" \
		# -ex "set architecture armv6-m" \
