<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- This is the multi-page HTML style file. -->
  <xsl:import href="/usr/share/xml/docbook/stylesheet/docbook-xsl/html/chunk.xsl"/>
  <xsl:import href="atug-common.xsl"/>
  <xsl:import href="atug-html-common.xsl"/>

  <!-- Include the CASS SSI before the navigation for the chunked output. -->
  <xsl:template name="user.header.navigation">
    <xsl:text disable-output-escaping="yes">&lt;?php include( $_SERVER['DOCUMENT_ROOT'] . "/includes/title_bar_atnf.inc" ) ?&gt;</xsl:text>
  </xsl:template>
  <!-- END SSI includes. -->

</xsl:stylesheet>
