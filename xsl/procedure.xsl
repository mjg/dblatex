<?xml version='1.0' encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>
<!--############################################################################# 
 |	$Id$
 |- #############################################################################
 |	$Author$
 |														
 |   PURPOSE: Prise en compte des r�f�rences dans step
 + ############################################################################## -->

<xsl:template match="step">
<xsl:text>\item{</xsl:text>
<xsl:call-template name="label.id"/>
<xsl:choose>
	<xsl:when test="title">
		<xsl:text>{\sc </xsl:text>
    <xsl:apply-templates select="title"/>
    <xsl:text>}&#10;</xsl:text>
	</xsl:when>
</xsl:choose>
<xsl:apply-templates/>
<xsl:text>}&#10;</xsl:text>
</xsl:template>

</xsl:stylesheet>
