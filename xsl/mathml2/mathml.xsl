<?xml version='1.0' encoding="iso-8859-1"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://www.w3.org/1998/Math/MathML"
    version='1.0'>

<xsl:import href="mmltex.xsl"/>

<!-- because UTF-8 is not supported by texclean (not yet) -->
<xsl:output method="text" indent="no" encoding="iso-8859-1"/>

<!-- because xsltproc cannot strip "m:*" elements -->
<xsl:strip-space elements="m:math m:mrow m:mstyle m:mtd m:mphantom
                           m:mi m:mo m:ms m:mn m:mtext m:maction"/>

<!-- hook for mml text template -->
<xsl:template name="mmltext">
  <xsl:call-template name="replaceEntities">
    <xsl:with-param name="content" select="normalize-space()"/>
  </xsl:call-template>
</xsl:template>

<!-- ====================================
     MML TeX patches or missing templates
     ==================================== -->

<!-- don't know how to render this -->
<xsl:template match="m:maligngroup"/>

<!-- 3.3.6 -->
<!-- don't know how to render this -->
<xsl:template match="m:mpadded">
  <xsl:apply-templates/>
</xsl:template>

<!-- 4.4.2.3 fn -->
<xsl:template match="m:fn"> <!-- for m:fn alone -->
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="m:malignmark|m:maction">
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
