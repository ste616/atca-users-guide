<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <!-- Enable auto-labelling of sections, and include the chapter number
       in the section numbers. -->
  <xsl:param name="section.autolabel" select="1"/>
  <xsl:param name="section.label.includes.component.label" select="1"/>
  <!-- END Section labelling. -->

  <!-- Enable having the TOC after the preface. -->
  <xsl:param name="process.empty.source.toc" select="1"/>
  <xsl:param name="generate.toc">book title</xsl:param>
  <!-- END TOC after preface. -->
  
  <!-- Set the position of the captions (main change is that the caption
       for figures should be after the image. -->
  <xsl:param name="formal.title.placement">
    figure after
    example before
    equation before
    table before
    procedure before
    task before
  </xsl:param>
  <!-- END Caption placement. -->

  <!-- Show only the number without title for cross references. -->
  <xsl:param name="xref.with.number.and.title" select="0"></xsl:param>
  <!-- END Cross reference style. -->

  <!-- Remove leading whitespace from each line of a screen environment.
       We have this here so we can indent our screens as much as we like
       in the XML files, to match the flow of the section, and this routine
       will make sure the leading tabs and whitespaces go away during
       compilation. -->
  <xsl:template match="screen/text()">
    <xsl:variable name="before" select="preceding-sibling::node()"/>
    <xsl:variable name="after" select="following-sibling::node()"/>
    
    <xsl:variable name="conts" select="."/>
    
    <xsl:variable name="contsl">
      <xsl:choose>
	<xsl:when test="count($before) = 0">
	  <xsl:call-template name="remove-leading-ws">
	    <xsl:with-param name="astr" select="$conts"/>
	  </xsl:call-template>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="$conts"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:value-of select="$contsl"/>
  </xsl:template>

  <!-- This recursive template does the leading whitespace removal. -->
  <xsl:template name="remove-leading-ws">
    <xsl:param name="astr"/>

    <xsl:variable name="after-replace-ws">
      <xsl:call-template name="string-replace-all">
	<xsl:with-param name="text" select="$astr"/>
	<xsl:with-param name="replace" select="'&#xA;&#x20;'"/>
	<xsl:with-param name="by" select="'&#xA;'"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="after-replace-tb">
      <xsl:call-template name="string-replace-all">
	<xsl:with-param name="text" select="$after-replace-ws"/>
	<xsl:with-param name="replace" select="'&#xA;&#x9;'"/>
	<xsl:with-param name="by" select="'&#xA;'"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="(contains($after-replace-tb, '&#xA;&#x20;')) or
		      (contains($after-replace-tb, '&#xA;&#x9;'))">
	<xsl:call-template name="remove-leading-ws">
	  <xsl:with-param name="astr" select="$after-replace-tb"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$after-replace-tb"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- We have to implement our own "replace" function since XPath 1.0 
       doesn't support the inbuilt "replace" that 2.0 does. -->
  <xsl:template name="string-replace-all">
    <xsl:param name="text"/>
    <xsl:param name="replace"/>
    <xsl:param name="by"/>
    <xsl:choose>
      <xsl:when test="contains($text,$replace)">
	<xsl:value-of select="substring-before($text,$replace)"/>
	<xsl:value-of select="$by"/>
	<xsl:call-template name="string-replace-all">
	  <xsl:with-param name="text" select="substring-after($text,$replace)"/>
	  <xsl:with-param name="replace" select="$replace"/>
	  <xsl:with-param name="by" select="$by"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- END Leading whitespace removal. -->

</xsl:stylesheet>
