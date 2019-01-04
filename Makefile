
CURRENT_DIR = $(shell pwd)
DL_DIR = $(CURRENT_DIR)/dl

CHIBIOS_VER = 18.2.1
CHIBIOS_NAME = ChibiOS_$(CHIBIOS_VER)
CHIBIOS_ZIP = $(DL_DIR)/$(CHIBIOS_NAME).zip
CHIBIOS_DIR = $(CURRENT_DIR)/$(CHIBIOS_NAME)

PATCHFILES := $(sort $(wildcard patches/*.patch ))

PATCH_CMD = \
  for f in $(PATCHFILES); do\
      echo $$f ":"; \
      patch -d $(CHIBIOS_DIR) -p1 < $$f || exit 1; \
  done

COPY_CMD = tar cf - -C files . | tar xf - -C $(CHIBIOS_DIR)

.PHONY: all clean

all:
	unzip -q $(CHIBIOS_ZIP)
	$(COPY_CMD)
	$(PATCH_CMD)
	make -C $(CHIBIOS_DIR)/demos/STM32/RT-STM32F407-DISCOVERY

clean:
	-rm -rf $(CHIBIOS_DIR)
