<?xml version='1.0'?>
<!--############################################################################# 
 |	$Id$
 |- #############################################################################
 |	$Author$
 |														
 |   PURPOSE:
 + ############################################################################## -->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
	exclude-result-prefixes="doc" version='1.0'>


<xsl:template match="part">
<xsl:text>% -------------------------------------------------------------	&#10;</xsl:text>
<xsl:text>%&#10;</xsl:text>
<xsl:text>% PART&#10;</xsl:text>
<xsl:text>%&#10;</xsl:text>
<xsl:text>% -------------------------------------------------------------	&#10;</xsl:text>
<xsl:call-template name="element.and.label"/>
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="part/docinfo"/>
<xsl:template match="part/title"/>
<xsl:template match="part/subtitle"/>
<xsl:template match="partintro"/>
<xsl:template match="partintro/title"/>
<xsl:template match="partintro/subtitle"/>
<xsl:template match="partintro/titleabbrev"/>

</xsl:stylesheet>
