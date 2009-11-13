# さくらインターネットのスタンダードプランでは mod_deflate や mod_gzip
# が使えない。転送効率を稼ぐために、あらかじめ gzip しておいて、
# mod_rewrite で圧縮したファイルを見に行かせる。その gzip をするための
# Makefile 
# 
# .htaccess の設定例:
# 
# <IfModule mod_rewrite.c>
# RewriteBase /
# RewriteCond %{HTTP:Accept-Encoding} gzip
# RewriteCond %{REQUEST_FILENAME} "\.(css|js|html)$"
# RewriteCond %{REQUEST_FILENAME} !"\.gz$"
# RewriteCond %{REQUEST_FILENAME}.gz -s
# RewriteRule .+ %{REQUEST_URI}.gz [L]
# </IfModule>

html_files := $(shell find . -name "*.html" -print)
js_files := $(shell find . -name "*.js" -print)
css_files := $(shell find . -name "*.css" -print)

all : htmlcomp jscomp csscomp

htmlcomp: $(html_files:.html=.html.gz)
jscomp: $(js_files:.js=.js.gz)
csscomp: $(css_files:.css=.css.gz)

clean:
	find . -name '*.html.gz' -exec rm {} \;
	find . -name '*.js.gz' -exec rm {} \;
	find . -name '*.css.gz' -exec rm {} \;

.SUFFIXES: .html .js .css .gz 
.PHONY: main jscomp csscomp clean

%.html.gz: %.html
	gzip -c $< > $<.gz
%.js.gz: %.js
	gzip -c $< > $<.gz
%.css.gz: %.css
	gzip -c $< > $<.gz
