<?xml version='1.0' encoding="UTF-8"?>
<!-- ********************************************************************
     $Id: common.xsl,v 1.10 2003/07/10 20:27:40 nilgun Exp $
     ********************************************************************

    Copyright ©  2005  Nilgün Belma Bugüner <nilgun@belgeler.gen.tr>
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!-- özelleştirilmiş xslt betikleri -->
<xsl:import href="arsiv.xsl"/>
<xsl:import href="autodict.xsl"/>
<xsl:import href="expressions.xsl"/>
<xsl:import href="multindex.xsl"/>
<xsl:import href="reftoc.xsl"/>
<xsl:import href="xmldict.xsl"/>

<!-- özelleştirilmiş parametreler -->
<xsl:param name="chunk.sections" select="'1'"/>
<xsl:param name="chunk.first.sections" select="1"/>
<xsl:param name="chunk.section.depth" select="1"/>
<xsl:param name="toc.section.depth">0</xsl:param>
<xsl:param name="root.filename"/>
<xsl:param name="use.id.as.filename" select="'1'"/>
<xsl:param name="html.stylesheet" select="'belgeler.css'"/>
<xsl:param name="admon.graphics.path">../images/xsl/</xsl:param>
<xsl:param name="callout.graphics.path">../images/xsl/callouts/</xsl:param>
<xsl:param name="navig.graphics.path">../images/xsl/</xsl:param>


<xsl:template match="literallayout">
  <pre class="{name(.)}"><xsl:apply-templates/></pre>
</xsl:template>

<xsl:template match="programlisting|screen|synopsis">
  <xsl:param name="suppress-numbers" select="'0'"/>
  <xsl:variable name="vendor" select="system-property('xsl:vendor')"/>
  <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>

  <xsl:if test="@id">
    <a href="{$id}"/>
  </xsl:if>

  <div class="{name(.)}">
    <xsl:attribute name="align">
      <xsl:choose>
        <xsl:when test="name(.) = 'synopsis'">
          <xsl:text>center</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>right</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  <table width="95%" cellpadding="5" cellspacing="1" border="0" class="preoutline">
  <tr class="preinline">
  <xsl:choose>
    <xsl:when test="@linenumbering = 'numbered'">
      <xsl:variable name="rtf">
        <xsl:apply-templates/>
      </xsl:variable>
      <td align="right" width="20" valign="top">
        <pre class="{name(.)}">
          <xsl:call-template name="numbered.lines">
            <xsl:with-param name="rtf" select="$rtf"/>
          </xsl:call-template>
        </pre>
        <xsl:text> </xsl:text>
      </td>
      <td width="*">
        <pre class="{name(.)}">
          <xsl:apply-templates/>
        </pre>
        <xsl:text> </xsl:text>
      </td>
    </xsl:when>
    <xsl:otherwise>
      <td>
        <xsl:text> </xsl:text>
        <pre class="{name(.)}">
          <xsl:apply-templates/>
        </pre>
        <xsl:text> </xsl:text>
      </td>
    </xsl:otherwise>
  </xsl:choose>
  </tr></table></div>
</xsl:template>

<xsl:template name="numbered.lines">
  <xsl:param name="rtf"></xsl:param>
  <xsl:param name="num" select="0"/>

  <xsl:if test="contains($rtf,'&#10;')">
    <xsl:if test="$num>0">
      <xsl:value-of select="$num"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
    <xsl:call-template name="numbered.lines">
      <xsl:with-param name="rtf" select="substring-after($rtf,'&#10;')"/>
      <xsl:with-param name="num" select="$num + 1"/>
    </xsl:call-template>

  </xsl:if>
</xsl:template>
<!--
<xsl:template match="synopsis">
  <blockquote><pre class="{name(.)}">
    <xsl:apply-templates/>
  </pre></blockquote><p/>
</xsl:template>
-->
<!-- Yazar ve sürüm bilgileri alanında standart olarak bulunmayan
     ayrıntıları yazalım -->
<xsl:variable name="authorlabel">Yazan: </xsl:variable>
<xsl:variable name="translatorlabel">Çeviren: </xsl:variable>
<xsl:variable name="legallabel">Yasal Uyarı: </xsl:variable>
<xsl:variable name="preplabel">Hazırlayan: </xsl:variable>
<xsl:variable name="compilelabel">Derleyen: </xsl:variable>
<xsl:variable name="editorlabel">Düzenleyen: </xsl:variable>

<xsl:template match="author" mode="titlepage.mode">
  <xsl:text> </xsl:text>
  <h3 class="{name(.)}">
  <xsl:choose>
    <xsl:when test="@role='translator'">
      <i class="author1"><xsl:value-of select="$translatorlabel"/></i>
    </xsl:when>
    <xsl:when test="@role='prep'">
      <i class="author1"><xsl:value-of select="$preplabel"/></i>
    </xsl:when>
    <xsl:when test="@role='compile'">
      <i class="author1"><xsl:value-of select="$compilelabel"/></i>
    </xsl:when>
    <xsl:when test="@role='editor'">
      <i class="author1"><xsl:value-of select="$editorlabel"/></i>
    </xsl:when>
    <xsl:otherwise>
      <i class="author1"><xsl:value-of select="$authorlabel"/></i>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:call-template name="person.name"/>
  </h3>
  <xsl:apply-templates mode="titlepage.mode" select="./contrib"/>
  <xsl:apply-templates mode="titlepage.mode" select="./affiliation"/>
</xsl:template>

<xsl:template match="small">
  <small><xsl:apply-templates/></small>
</xsl:template>

<xsl:template match="big">
  <big><xsl:apply-templates/></big>
</xsl:template>
<!-- Custom 'emphasis' template to allow 'role="strong"' to
     also produce a bold item. -->
<xsl:template match="emphasis">
  <xsl:choose>
    <xsl:when test="(@role='strong') or (@role='bold') or (@remap='bf')">
      <xsl:call-template name="inline.boldseq"/>
    </xsl:when>
    <xsl:when test="(@role='input')">
      <tt class="empinput"><xsl:apply-templates/></tt>
    </xsl:when>
    <xsl:when test="(@role='output')">
      <tt class="empoutput"><xsl:apply-templates/></tt>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="inline.italicseq"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="string.replace">
  <xsl:param name="string"></xsl:param>
  <xsl:param name="target"></xsl:param>
  <xsl:param name="replace"></xsl:param>
  <xsl:choose>
    <xsl:when test="contains($string,$target)">
      <xsl:value-of select="concat(substring-before($string,$target),$replace)"/>
      <xsl:call-template name="string.replace">
        <xsl:with-param name="string" select="normalize-space(substring-after($string,$target))"/>
        <xsl:with-param name="target" select="$target"/>
        <xsl:with-param name="replace" select="$replace"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="formalpara/title">
  <br/><b><xsl:apply-templates/></b><br/>
</xsl:template>

<xsl:template match="funcsynopsis">
  <dl><xsl:apply-templates/></dl>
</xsl:template>

<xsl:template match="funcsynopsisinfo">
  <dt><xsl:apply-templates/></dt>
</xsl:template>

<xsl:template match="funcdeflist">
  <dt><table width="100%" cellpadding="3" cellspacing="0" border="0" class="func">
    <tr class="funcdef"><td>
      <table cellpadding="5" cellspacing="0" border="0" class="funcinline">
        <xsl:apply-templates/>
      </table>
    </td><td align="right"><xsl:value-of select="@role"/></td></tr>
  </table></dt>
</xsl:template>

<xsl:template match="funcprototype">
  <xsl:if test="(@id)">
    <a><xsl:attribute name="name">
        <xsl:value-of select="@id"/>
    </xsl:attribute></a>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="name(..)!='funcdeflist'">
      <dt><table width="100%" cellpadding="3" cellspacing="0" border="0" class="func">
        <tr class="funcdef"><td>
          <table cellpadding="5" cellspacing="0" border="0" class="funcinline">
            <tr><xsl:apply-templates/></tr>
          </table>
        </td><td align="right"><xsl:value-of select="@role"/></td></tr>
      </table></dt>
    </xsl:when>
    <xsl:otherwise>
      <tr><xsl:apply-templates/></tr>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="funcdef">
<td valign="top" class="tt" nowrap="1"><tt><xsl:apply-templates/></tt></td>
</xsl:template>

<xsl:template match="paramdef">
<td valign="top"><pre class="paramdef"><xsl:apply-templates/></pre></td>
</xsl:template>

<xsl:template match="funcdescr">
<dd><xsl:apply-templates/></dd>
</xsl:template>

<xsl:template match="superset">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="link[(ancestor-or-self::refentry)]">
  <xsl:variable name="targets" select="key('id',@linkend)"/>
  <xsl:variable name="target" select="$targets[1]"/>

  <xsl:variable name="name">
    <xsl:value-of select="."/>
  </xsl:variable>

  <xsl:variable name="volnum">
    <xsl:value-of select="substring-before(substring-after(@linkend, 'man'), '-')"/>
  </xsl:variable>

  <tt><b>
  <xsl:choose>
    <!-- Bu özel kullanım biçimi için bak: crypt.3 ve analyze.7 -->
    <xsl:when test="normalize-space($name) = ''">
      <xsl:choose>
        <xsl:when test="count($target) = 0">
          <xsl:value-of select="concat(substring-after(@linkend, '-'), '(', $volnum, ')')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="xref"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="link"/>
    </xsl:otherwise>
  </xsl:choose>
  </b></tt>
</xsl:template>

<xsl:template match="dicterm|english|turkish|titleabbrev"/>

</xsl:stylesheet>
