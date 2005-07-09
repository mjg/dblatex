<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->


<xsl:template match="variablelist/title|
                     orderedlist/title | itemizedlist/title | simplelist/title">
  <xsl:text>&#10;{\sc </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}&#10;</xsl:text>
</xsl:template>

<xsl:template match="itemizedlist">
  <xsl:apply-templates select="title"/>
  <xsl:text>\begin{itemize}&#10;</xsl:text>
  <xsl:apply-templates select="listitem"/>
  <xsl:text>\end{itemize}&#10;</xsl:text>
</xsl:template>

<xsl:template match="orderedlist">
  <xsl:apply-templates select="title"/>
  <xsl:text>\begin{enumerate}</xsl:text>
  <xsl:if test="@numeration">
    <xsl:choose>
    <xsl:when test="@numeration='arabic'">    <xsl:text>[1]</xsl:text>&#10;</xsl:when>
    <xsl:when test="@numeration='upperalpha'"><xsl:text>[A]</xsl:text>&#10;</xsl:when>
    <xsl:when test="@numeration='loweralpha'"><xsl:text>[a]</xsl:text>&#10;</xsl:when>
    <xsl:when test="@numeration='upperroman'"><xsl:text>[I]</xsl:text>&#10;</xsl:when>
    <xsl:when test="@numeration='lowerroman'"><xsl:text>[i]</xsl:text>&#10;</xsl:when>
    </xsl:choose>
  </xsl:if>
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates select="listitem"/>
  <xsl:text>\end{enumerate}&#10;</xsl:text>
</xsl:template>

<xsl:template match="variablelist">
  <xsl:apply-templates select="title"/>
  <xsl:text>&#10;\noindent&#10;</xsl:text> 
  <xsl:text>\begin{description}&#10;</xsl:text>
  <xsl:apply-templates select="varlistentry"/>
  <xsl:text>\end{description}&#10;</xsl:text>
</xsl:template>

<xsl:template match="listitem">
  <xsl:text>&#10;\item </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="varlistentry">
  <xsl:text>\item[</xsl:text>
  <xsl:apply-templates select="term"/>
  <xsl:text>] </xsl:text>
  <xsl:apply-templates select="listitem"/>
</xsl:template>

<xsl:template match="varlistentry/term">
  <xsl:apply-templates/><xsl:text>, </xsl:text>
</xsl:template>

<xsl:template match="varlistentry/term[position()=last()]">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="varlistentry/listitem">
  <xsl:apply-templates/>
</xsl:template>

<!-- ##############
     # Simplelist #
     ############## -->

<xsl:template name="tabular.string">
  <xsl:param name="cols" select="1"/>
  <xsl:param name="i" select="1"/>
  <xsl:if test="$i &lt;= $cols">
    <xsl:text>l</xsl:text>
    <xsl:call-template name="tabular.string">
      <xsl:with-param name="i" select="$i+1"/>
      <xsl:with-param name="cols" select="$cols"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="member">
  <xsl:apply-templates/>
</xsl:template>


<!-- Inline simplelist is a comma separated list of items -->

<xsl:template match="simplelist[@type='inline']">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="simplelist[@type='inline']/member">
  <xsl:apply-templates/>
  <xsl:text>, </xsl:text>
</xsl:template>

<xsl:template match="simplelist[@type='inline']/member[position()=last()]">
  <xsl:apply-templates/>
</xsl:template>

<!-- Horizontal simplelist, is actually a tabular -->

<xsl:template match="simplelist[@type='horiz']">
  <xsl:variable name="cols">
    <xsl:choose>
      <xsl:when test="@columns">
        <xsl:value-of select="@columns"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:text>&#10;\begin{tabular*}{\linewidth}{</xsl:text>
  <xsl:call-template name="tabular.string">
    <xsl:with-param name="cols" select="$cols"/>
  </xsl:call-template>
  <xsl:text>}&#10;</xsl:text> 
  <xsl:for-each select="member">
    <xsl:apply-templates select="."/>
    <xsl:choose>
    <xsl:when test="position()=last()">
      <xsl:text> \\&#10;</xsl:text>
    </xsl:when>
    <xsl:when test="position() mod $cols">
      <xsl:text> &amp; </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text> \\&#10;</xsl:text>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
  <xsl:text>&#10;\end{tabular*}&#10;</xsl:text>
</xsl:template>

<!-- Vertical simplelist, a tabular too -->

<xsl:template match="simplelist|simplelist[@type='vert']">
  <xsl:variable name="cols">
    <xsl:choose>
      <xsl:when test="@columns">
        <xsl:value-of select="@columns"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:text>&#10;\vspace{1cm}&#10;</xsl:text>
  <xsl:text>\begin{tabular*}{\linewidth}{</xsl:text>
  <xsl:call-template name="tabular.string">
    <xsl:with-param name="cols" select="$cols"/>
  </xsl:call-template>
  <xsl:text>}&#10;</xsl:text> 

  <!-- recusively display each row -->
  <xsl:call-template name="simplelist.vert.row">
    <xsl:with-param name="rows" select="floor((count(member)+$cols - 1) div $cols)"/>
  </xsl:call-template>
  <xsl:text>&#10;\end{tabular*}&#10;</xsl:text>
  <xsl:text>\vspace{1cm}&#10;</xsl:text>
</xsl:template>

<xsl:template name="simplelist.vert.row">
  <xsl:param name="cell">0</xsl:param>
  <xsl:param name="rows"/>
  <xsl:if test="$cell &lt; $rows">
    <xsl:for-each select="member[((position()-1) mod $rows) = $cell]">
      <xsl:apply-templates select="."/>
      <xsl:if test="position()!=last()">
        <xsl:text> &amp; </xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:text> \\&#10;</xsl:text> 
    <xsl:call-template name="simplelist.vert.row">
      <xsl:with-param name="cell" select="$cell+1"/>
      <xsl:with-param name="rows" select="$rows"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- Segmentedlist stuff -->

<xsl:template match="segmentedlist">
  <xsl:apply-templates select="node()[not(self::segtitle)]"/>
</xsl:template>

<xsl:template match="segmentedlist/title">
  <xsl:text>{\bf </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}\\&#10;</xsl:text>
</xsl:template>

<xsl:template match="segtitle">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="seglistitem">
  <xsl:apply-templates/>
  <xsl:text> \\&#10;</xsl:text>
</xsl:template>

<!-- We trust in the right count of segtitle declarations -->

<xsl:template match="seg">
  <xsl:variable name="p" select="position()"/>
  <xsl:text> \emph{</xsl:text>
  <xsl:apply-templates select="../../segtitle[position()=$p]"/>
  <xsl:text>:} </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
