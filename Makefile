# Makefile for building a website using sphinx.
# This Makefile has been heavily modified from the original that
# sphinx-quickstart automatically creates

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
BUILDDIR      = _build
OPENSHIFTDIR  = ../jcheng.org_openshift
SOURCEDIR     = .


# Other variables for site management, css updating, etc.
STATICDIR   = _static
STATIC_CSS  = themes/jcheng/static
SITE        = $(BUILDDIR)/html
WWW         = /home/jcheng/mywork/www/jcheng.org_openshift

# Internal variables.
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(SPHINXOPTS) $(SOURCEDIR)

.PHONY: help clean CV html site linkcheck doctest upload dist

default: site

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  html        : make standalone HTML files"
	@echo "  CV          : make my CV"
	@echo "  wordcloud   : make wordcloud from bib file"
	@echo "  linkcheck   : check all external links for integrity"
	@echo "  doctest     : run all doctests embedded in the documentation (if enabled)"
	@echo "  upload      : push the local site build to its public location"
	@echo "  dist        : create a tarball (no .git dir) of site"

clean:
	rm -rf $(BUILDDIR)/html
	mkdir $(BUILDDIR)/html
	rm -rf publications_by_*.rst
	rm -rf publications_first_author.rst

# cleanAll:
#   -rm -rf $(BUILDDIR)/*
#   -rm -rf *~

html: 
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."

papers:
	mkdir $(BUILDDIR)/html -p
	./tools/generate_rst_from_bib.sh
	@echo
	@echo "The publication page is in $(BUILDDIR)/html."

wordcloud:
	@echo "Generate $(STATICDIR)/wordcloud.png."
	./tools/generate_wordcloud.sh


CV: 
	@echo "Build CV in resume/CV_JianCheng.pdf"
	cd resume ; pdflatex CV_JianCheng
	@echo
	@echo "Build finished. The CV is in resume/CV_JianCheng.pdf"

# openshift: html
#   rm -rf $(OPENSHIFTDIR)/diy
#   cp -rp $(BUILDDIR)/html  $(OPENSHIFTDIR)/diy
#   cp -rp $(STATICDIR)/testrubyserver.rb  $(OPENSHIFTDIR)/diy

linkcheck: site
	$(SPHINXBUILD) -b linkcheck $(ALLSPHINXOPTS) $(BUILDDIR)/linkcheck
	@echo
	@echo "Link check complete; look for any errors in the above output " \
	      "or in $(BUILDDIR)/linkcheck/output.txt."

doctest:
	$(SPHINXBUILD) -b doctest $(ALLSPHINXOPTS) $(BUILDDIR)/doctest
	@echo "Testing of doctests in the sources finished, look at the " \
	      "results in $(BUILDDIR)/doctest/output.txt."

copy: 
	chmod -R uog+r $(SITE)
	./copy_www.sh

# jcheng - new targets I've added after sphinx-quickstart
upload: site copy


# Update only css files
css:
	rsync -av --exclude=~ $(STATIC_CSS)/ $(SITE)/$(STATICDIR)

site: papers html css
	./copy_trees.py

# The 'dist' target basically runs this:
# git archive --prefix=fperez.org/  master | gzip > fperez.org.tgz
# but via a shell script that sanitizes the exported data to remove things I
# don't want exposed either for privacy or file size reasons.
# You can replace the following with the git archive call above and you'll get
# a functioning site export.
dist:
	site-export-clean
