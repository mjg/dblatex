<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    Feuille de style de transformation XML DocBook -> LaTeX 
    ############################################################################ -->

<xsl:template name="scape" >
  <xsl:param name="string"/>
  <xsl:call-template name="tex-format">
    <xsl:with-param name="string" select="$string"/>
  </xsl:call-template>
</xsl:template>


<!-- Text format template -->

<xsl:template name="tex-format">
  <xsl:param name="string"/>
  <xsl:call-template name="special-replace">
    <xsl:with-param name="i">1</xsl:with-param>
    <xsl:with-param name="mapfile" select="document('texmap.xml')"/>
    <xsl:with-param name="string" select="$string"/>
  </xsl:call-template>
</xsl:template>


<!-- Special character replacement engine -->

<xsl:template name="special-replace">
  <xsl:param name="i"/>
  <xsl:param name="mapfile"/>
  <xsl:param name="string"/>
  <xsl:choose>
  <xsl:when test="($mapfile/mapping/map[position()=$i])[1]">
    <xsl:variable name="map" select="($mapfile/mapping/map[position()=$i])[1]"/>
    <xsl:call-template name="string-replace">
      <xsl:with-param name="to">
        <xsl:value-of select="$map/@text"/></xsl:with-param>
      <xsl:with-param name="from">
        <xsl:value-of select="$map/@key"/></xsl:with-param>
      <xsl:with-param name="string">
        <xsl:call-template name="special-replace">
          <xsl:with-param name="i" select="$i+1"/>
          <xsl:with-param name="mapfile" select="$mapfile"/>
          <xsl:with-param name="string" select="$string"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$string"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
