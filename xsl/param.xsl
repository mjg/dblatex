<?xml version='1.0' encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!-- "Latex" parameters -->

<xsl:param name="latex.hyperparam"/>
<xsl:param name="latex.style">docbook</xsl:param>
<xsl:param name="latex.biblio.output">all</xsl:param>
<xsl:param name="latex.bibfiles">''</xsl:param>
<xsl:param name="latex.bibwidelabel">WIDELABEL</xsl:param>
<xsl:param name="latex.output.revhistory">1</xsl:param>
<xsl:param name="latex.babel.use">1</xsl:param>
<xsl:param name="latex.babel.language"/>
<xsl:param name="latex.class.options"/>
<xsl:param name="biblioentry.item.separator">, </xsl:param>

<!-- Default behaviour setting -->

<xsl:param name="refentry.xref.manvolnum" select="1"/>
<xsl:param name="refsynopsis.title">Synopsis</xsl:param>
<xsl:param name="refnamediv.title"></xsl:param>
<xsl:param name="funcsynopsis.style">ansi</xsl:param>
<xsl:param name="funcsynopsis.decoration" select="1"/>
<xsl:param name="function.parens">0</xsl:param>
<xsl:param name="classsynopsis.default.language">java</xsl:param>
<xsl:param name="show.comments" select="1"/>
<xsl:param name="glossterm.auto.link" select="0"/>

<!-- "Common" parameters -->

<xsl:param name="author.othername.in.middle" select="1"/>
<xsl:param name="section.autolabel" select="1"/>
<xsl:param name="section.label.includes.component.label" select="0"/>
<xsl:param name="chapter.autolabel" select="1"/>
<xsl:param name="preface.autolabel" select="0"/>
<xsl:param name="part.autolabel" select="1"/>
<xsl:param name="qandadiv.autolabel" select="1"/>
<xsl:param name="qanda.inherit.numeration" select="1"/>
<xsl:param name="qanda.defaultlabel">number</xsl:param>
<xsl:param name="graphic.default.extension"/>
<xsl:param name="make.single.year.ranges" select="0"/>
<xsl:param name="make.year.ranges" select="0"/>


<xsl:variable name="latex.book.afterauthor">
  <xsl:text>% --------------------------------------------&#10;</xsl:text>
  <xsl:text>\makeindex&#10;</xsl:text>
  <xsl:text>\makeglossary&#10;</xsl:text>
  <xsl:text>% --------------------------------------------&#10;</xsl:text>
</xsl:variable>

<xsl:variable name="latex.book.begindocument">
  <xsl:text>\begin{document}&#10;</xsl:text>
</xsl:variable>

<xsl:variable name="latex.book.end">
  <xsl:text>% --------------------------------------------&#10;</xsl:text>
  <xsl:text>% End of document&#10;</xsl:text>
  <xsl:text>% --------------------------------------------&#10;</xsl:text>
  <xsl:text>\end{document}&#10;</xsl:text>
</xsl:variable>


</xsl:stylesheet>

