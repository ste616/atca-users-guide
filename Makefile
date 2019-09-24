XSLT = xsltproc
STYLESHEETS_DIR = /usr/share/xml/docbook/stylesheet/docbook-xsl
BUILD_DIR = builds
HTML_BUILD_DIR = $(BUILD_DIR)/html
PDF_BUILD_DIR = $(BUILD_DIR)/pdf
XSL_DIR = xsl

all: html pdf

$(HTML_BUILD_DIR):
	mkdir -p builds/html

$(PDF_BUILD_DIR):
	mkdir -p builds/pdf

html: | $(HTML_BUILD_DIR)
	$(XSLT) -o $(BUILD_DIR)/html/atug.html $(XSL_DIR)/atug-html.xsl xml/atug.xml
	$(XSLT) -o $(BUILD_DIR)/html/chunked/ $(XSL_DIR)/atug-chunked-html.xsl xml/atug.xml

fo:
	$(XSLT) -o $(BUILD_DIR)/temp/atug.fo $(XSL_DIR)/atug-pdf.xsl xml/atug.xml

pdf: fo | $(PDF_BUILD_DIR)
	fop -pdf $(BUILD_DIR)/pdf/atug.pdf -fo $(BUILD_DIR)/temp/atug.fo -c static/pdf/fop.cfg.xml

installnamoi:
	cp -v builds/html/atug.html builds/html/atug.css builds/pdf/atug.pdf /nfs/wwwnar/observing/users_guide/html/.
	cp -v builds/html/chunked/*.html /nfs/wwwnar/observing/users_guide/html/chunked/.
	cp -v figures/* /nfs/wwwnar/observing/users_guide/html/figures/.
	cp -v figures/* /nfs/wwwnar/observing/users_guide/html/chunked/figures/.

clean:
	rm -f $(BUILD_DIR)/pdf/atug.pdf $(BUILD_DIR)/html/atug.html $(BUILD_DIR)/temp/atug.fo

