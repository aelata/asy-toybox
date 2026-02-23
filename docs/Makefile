# This Makefile only checks whether TARGET files need to be updated.
# Run "Export > HTML > HTML (cdn hosted)" in the preview of VS Code to update.

TARGET=$(shell find . -name '*.md' | sed -e 's/\.md/\.html/')

all: $(TARGET)

%.html: %.md
	@echo $@ is out of date.

clean:
	rm -f $(TARGET)
