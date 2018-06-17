<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <!-- Include the stylesheets and HTML required to make it look nice, and to
       put the CASS stuff on it. -->
  <xsl:param name="html.stylesheet">
    atug.css
  </xsl:param>
  <!-- END Style includes. -->

  <!-- Enable LaTeX mathematics parsing and display with MathJax. -->
  <xsl:template name="user.head.content">
    <script src="/jslib/mathjax/2.3/MathJax.js?config=TeX-AMS-MML_HTMLorMML" type="text/javascript"></script>
    <xsl:text disable-output-escaping="yes">&lt;?php include( $_SERVER['DOCUMENT_ROOT'] . "/includes/standard_head.inc" ) ?&gt;</xsl:text>
  </xsl:template>
  <xsl:template match="informalequation/textobject[@role='tex'] | equation/textobject[@role='tex']">
    <script type="math/tex; mode=display">
      <xsl:value-of select="."/>
    </script>
  </xsl:template>
  <xsl:template match="inlineequation/textobject[@role='tex']">
    <script type="math/tex">
      <xsl:value-of select="."/>
    </script>
  </xsl:template>
  <!-- End LaTeX Mathematics. -->

</xsl:stylesheet>
