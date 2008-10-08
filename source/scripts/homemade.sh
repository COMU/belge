#!/bin/bash
#

xsl="docbook/xsl/belgeler/chapterless.xsl"
xml="belgeler.xml"
cd ..
LANG="C" xsltproc $xsl $xml
cd -

