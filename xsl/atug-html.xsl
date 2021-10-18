<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- This is the single-page HTML style file. -->
  <xsl:import href="docbook/html/docbook.xsl"/>
  <xsl:import href="atug-common.xsl"/>
  <xsl:import href="atug-html-common.xsl"/>

  <!-- Include the CASS SSI before the content for the single page output. -->
  <xsl:template name="user.header.content">
    <xsl:text disable-output-escaping="yes">&lt;?php include( $_SERVER['DOCUMENT_ROOT'] . "/includes/title_bar_atnf.inc" ) ?&gt;</xsl:text>
  </xsl:template>
  <!-- END SSI includes. -->

  <!-- Don't include mediaobjects that are only supposed to go in the PDF. -->
  <xsl:template match="mediaobject[@role='fop']">
    <xsl:text>
      <!-- Don't show this image -->
    </xsl:text>
  </xsl:template>
  <!-- END PDF mediaobjects exclusion. -->
</xsl:stylesheet>
