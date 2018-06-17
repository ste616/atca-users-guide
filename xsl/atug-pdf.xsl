<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:date="http://exslt.org/dates-and-times"
		exclude-result-prefixes="date">
  <xsl:import href="/usr/share/xml/docbook/stylesheet/docbook-xsl/fo/docbook.xsl"/>

  <!-- Import styles common to all outputs of the ATUG. -->
  <xsl:import href="atug-common.xsl"/>
  <!-- END Common style import. -->

  <!-- Set some obvious parameters. -->
  <xsl:param name="paper.type">A4</xsl:param>
  <xsl:param name="double.sided" select="1" />
  <xsl:param name="draft.mode">no</xsl:param>
  <!-- END Obvious parameters. -->

  <!-- This parameter allows FOP 1.0 to make the PDF. -->
  <xsl:param name="fop1.extensions" select="1"/>
  <!-- END FOP 1.0 parameter. -->

  <!-- Make the CSIRO-look front-cover. -->
  <xsl:template name="book.titlepage.before.recto">
    <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format">
      <fo:block-container absolute-position="absolute" top="-25mm" left="-25mm" width="210mm" height="297mm"
			  background-image="figures/reportfront-formal-midday.png">
	<fo:block>
	  <fo:block-container absolute-position="absolute" top="20mm" left="20mm">
	    <fo:block font-family="sans-serif" font-weight="bold" font-size="12pt" color="white">
	      ASTRONOMY AND SPACE SCIENCE
	    </fo:block>
	  </fo:block-container>
	  <fo:block-container absolute-position="absolute" top="25mm" left="20mm">
	    <fo:block font-family="sans-serif" font-weight="bold" font-size="12pt">
	      www.csiro.au
	    </fo:block>
	  </fo:block-container>
	</fo:block>
      </fo:block-container>
    </fo:block>
  </xsl:template>
  <xsl:template match="title" mode="book.titlepage.recto.auto.mode">
    <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format">
      <fo:block-container absolute-position="absolute" top="30mm" left="-10mm">
	<fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" xsl:use-attribute-sets="book.titlepage.recto.style" text-align="left" font-size="24.8832pt" space-before="18.6624pt" font-weight="bold" font-family="sans-serif" color="#00a9ce">
	  <xsl:call-template name="division.title">
	    <xsl:with-param name="node" select="ancestor-or-self::book[1]"/>
	  </xsl:call-template>
	</fo:block>
      </fo:block-container>
    </fo:block>
  </xsl:template>
  
  <xsl:template match="authorgroup" mode="book.titlepage.recto.auto.mode">
    <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format">
      <fo:block-container absolute-position="absolute" top="60mm" left="-10mm">
	<fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" xsl:use-attribute-sets="book.titlepage.recto.style" text-align="left" font-size="16.8832pt" space-before="18.6624pt" font-weight="bold" font-family="sans-serif" color="black">
	  <xsl:call-template name="person.name.list">
	    <xsl:with-param name="person.list" select="author|corpauthor|editor"/>
	  </xsl:call-template>
	</fo:block>
	<fo:block font-size="14pt" space-before="14pt" font-weight="normal" font-family="sans-serif" color="black">
	  <xsl:call-template name="datetime.format">
	    <xsl:with-param name="date" select="date:date-time()"/>
	    <xsl:with-param name="format" select="'d B Y'"/>
	  </xsl:call-template>
	</fo:block>
      </fo:block-container>
    </fo:block>
  </xsl:template>
  <!-- END CSIRO-look front cover. -->

  <!-- Make the CSIRO-look back cover. -->
  <xsl:template name="back.cover">
    <xsl:call-template name="page.sequence">
      <xsl:with-param name="master-reference">titlepage</xsl:with-param>
      <xsl:with-param name="content">
	<fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format">
	  <fo:block-container absolute-position="absolute" top="-25mm" left="-25mm" width="210mm" height="297mm"
			      background-image="figures/reportback-formal-midday.png">
	    <fo:block/>
	  </fo:block-container>
	</fo:block>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!-- END CSIRO-look back cover. -->

  <!-- Automatically scale images to fit on the page. -->
  <xsl:template name="process.image">
    <!-- When this template is called, the current node should be  -->
    <!-- a graphic, inlinegraphic, imagedata, or videodata. All    -->
    <!-- those elements have the same set of attributes, so we can -->
    <!-- handle them all in one place.                             -->
    
    <xsl:variable name="scalefit">
      <xsl:choose>
	<xsl:when test="$ignore.image.scaling != 0">0</xsl:when>
	<xsl:when test="@contentwidth">0</xsl:when>
	<xsl:when test="@contentdepth and 
			@contentdepth != '100%'">0</xsl:when>
	<xsl:when test="@scale">0</xsl:when>
	<xsl:when test="@scalefit"><xsl:value-of select="@scalefit"/></xsl:when>
	<xsl:when test="@width or @depth">1</xsl:when>
	<xsl:when test="$default.image.width != ''">1</xsl:when>
	<xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="scale">
      <xsl:choose>
	<xsl:when test="$ignore.image.scaling != 0">0</xsl:when>
	<xsl:when test="@contentwidth or @contentdepth">1.0</xsl:when>
	<xsl:when test="@scale">
	  <xsl:value-of select="@scale div 100.0"/>
	</xsl:when>
	<xsl:otherwise>1.0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="filename">
      <xsl:choose>
	<xsl:when test="local-name(.) = 'graphic'
			or local-name(.) = 'inlinegraphic'">
	  <!-- handle legacy graphic and inlinegraphic by new template --> 
	  <xsl:call-template name="mediaobject.filename">
	    <xsl:with-param name="object" select="."/>
	  </xsl:call-template>
	</xsl:when>
	<xsl:otherwise>
	  <!-- imagedata, videodata, audiodata -->
	  <xsl:call-template name="mediaobject.filename">
	    <xsl:with-param name="object" select=".."/>
	  </xsl:call-template>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="content-type">
      <xsl:if test="@format">
	<xsl:call-template name="graphic.format.content-type">
	  <xsl:with-param name="format" select="@format"/>
	</xsl:call-template>
      </xsl:if>
    </xsl:variable>
    
    <xsl:variable name="bgcolor">
      <xsl:call-template name="pi.dbfo_background-color">
	<xsl:with-param name="node" select=".."/>
      </xsl:call-template>
    </xsl:variable>
    
    <fo:external-graphic>
      <xsl:attribute name="src">
	<xsl:call-template name="fo-external-image">
	  <xsl:with-param name="filename">
	    <xsl:if test="$img.src.path != '' and
			  not(starts-with($filename, '/')) and
			  not(contains($filename, '://'))">
	      <xsl:value-of select="$img.src.path"/>
	    </xsl:if>
	    <xsl:value-of select="$filename"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:attribute>
      
      <xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
      
      <xsl:attribute name="inline-progression-dimension.maximum">100%</xsl:attribute>
      
      <xsl:if test="$content-type != ''">
	<xsl:attribute name="content-type">
	  <xsl:value-of select="concat('content-type:',$content-type)"/>
	</xsl:attribute>
      </xsl:if>
      
      <xsl:if test="$bgcolor != ''">
	<xsl:attribute name="background-color">
	  <xsl:value-of select="$bgcolor"/>
	</xsl:attribute>
      </xsl:if>
      
      <xsl:if test="@align">
	<xsl:attribute name="text-align">
	  <xsl:value-of select="@align"/>
	</xsl:attribute>
      </xsl:if>
      
      <xsl:if test="@valign">
	<xsl:attribute name="display-align">
	  <xsl:choose>
	    <xsl:when test="@valign = 'top'">before</xsl:when>
	    <xsl:when test="@valign = 'middle'">center</xsl:when>
	    <xsl:when test="@valign = 'bottom'">after</xsl:when>
	    <xsl:otherwise>auto</xsl:otherwise>
	  </xsl:choose>
	</xsl:attribute>
      </xsl:if>
    </fo:external-graphic>
  </xsl:template>
  <!-- END automatic image scaling. -->

  <!-- Make LaTeX equations appear properly, and centered on the page. -->
  <xsl:template match="informalequation/textobject[@role='tex'] | equation/textobject[@role='tex']">
    <fo:block text-align="center">
      <fo:instream-foreign-object>
	<latex xmlns="http://forge.scilab.org/p/jlatexmath">
	  <xsl:value-of select="."/>
	</latex>
      </fo:instream-foreign-object>
    </fo:block>
  </xsl:template>
  <xsl:template match="inlineequation/textobject[@role='tex']">
    <fo:instream-foreign-object>
      <latex xmlns="http://forge.scilab.org/p/jlatexmath">
	<xsl:value-of select="."/>
      </latex>
    </fo:instream-foreign-object>
  </xsl:template>
  <!-- END LaTeX equations. -->

  <!-- Keep the body text aligned with the page edge rather than
       indented hugely. -->
  <xsl:param name="body.start.indent">0pt</xsl:param>
  <!-- END Text alignment. -->

  <!-- Make the header (which is just the chapter name in the centre
       column) take up as much room as it needs. -->
  <xsl:param name="header.column.widths">0 3 0</xsl:param>
  <!-- END Header modification. -->

  <!-- Make the body text sans-serif, and slightly smaller because it
       appears that the sans-serif font is naturally larger than the
       serif. -->
  <xsl:param name="body.font.family">sans-serif</xsl:param>
  <xsl:param name="body.font.master">9</xsl:param>
  <!-- END Body font. -->

  <!-- Keep all rows of a table on the same page if at all possible. -->
  <xsl:attribute-set name="table.properties" use-attribute-sets="formal.object.properties">
    <xsl:attribute name="keep-together.within-column">
      always
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="informaltable.properties" use-attribute-sets="informal.object.properties">
    <xsl:attribute name="keep-together.within-column">
      always
    </xsl:attribute>
  </xsl:attribute-set>
  <!-- END Table page breaks. -->

  <!-- Make the chapter and title colours the same CSIRO Midday Blue. -->
  <xsl:param name="title.color">#00A9CE</xsl:param>

  <xsl:attribute-set name="section.title.properties">
    <xsl:attribute name="color">
      <xsl:value-of select="$title.color"/>
    </xsl:attribute>
    <xsl:attribute name="font-family">
      <xsl:value-of select="$title.font.family"></xsl:value-of>
    </xsl:attribute>
    <xsl:attribute name="font-weight">
      bold
    </xsl:attribute>
    <xsl:attribute name="keep-with-next.within-column">
      always
    </xsl:attribute>
    <xsl:attribute name="space-before.minimum">
      0.8em
    </xsl:attribute>
    <xsl:attribute name="space-before.optimum">
      1.0em
    </xsl:attribute>
    <xsl:attribute name="space-before.maximum">
      1.2em
    </xsl:attribute>
    <xsl:attribute name="text-align">
      left
    </xsl:attribute>
    <xsl:attribute name="start-indent">
      <xsl:value-of select="$title.margin.left"></xsl:value-of>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:template match="title" mode="chapter.titlepage.recto.auto.mode">
    <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format"
	      xsl:use-attribute-sets="chapter.titlepage.recto.style"
	      margin-left="{$title.margin.left}"
	      font-size="24.8832pt"
	      font-weight="bold"
	      font-family="{$title.font.family}">
      <xsl:attribute name="color">
	<xsl:value-of select="$title.color"/>
      </xsl:attribute>
      <xsl:call-template name="component.title">
	<xsl:with-param name="node" select="ancestor-or-self::chapter[1]"/>
      </xsl:call-template>
    </fo:block>
  </xsl:template>

  <xsl:template match="title" mode="appendix.titlepage.recto.auto.mode">
    <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format"
	      xsl:use-attribute-sets="appendix.titlepage.recto.style"
	      margin-left="{$title.margin.left}"
	      font-size="24.8832pt"
	      font-weight="bold"
	      font-family="{$title.font.family}">
      <xsl:attribute name="color">
	<xsl:value-of select="$title.color"/>
      </xsl:attribute>
      <xsl:call-template name="component.title">
	<xsl:with-param name="node" select="ancestor-or-self::appendix[1]"/>
      </xsl:call-template>
    </fo:block>
  </xsl:template>
  <!-- END Chapter and title colours. -->

  <!-- Make the index character divider titles Midday blue -->
  <xsl:attribute-set name="index.div.title.properties">
    <xsl:attribute name="color">
      <xsl:value-of select="$title.color"/>
    </xsl:attribute>
  </xsl:attribute-set>
  <!-- END Index title colors. -->

  <!-- Make the captions for tables and figures centre aligned. -->
  <xsl:attribute-set name="formal.title.properties" use-attribute-sets="normal.para.spacing">
    <xsl:attribute name="text-align">center</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.2 ">
	</xsl:value-of><xsl:text>pt</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="hyphenate">
      false
    </xsl:attribute>
    <xsl:attribute name="space-after.minimum">
      0.4em
    </xsl:attribute>
    <xsl:attribute name="space-after.optimum">
      0.6em
    </xsl:attribute>
    <xsl:attribute name="space-after.maximum">
      0.8em
    </xsl:attribute>
  </xsl:attribute-set>
  <!-- END Caption alignment. -->

  <!-- Include page number in cross references. -->
  <xsl:param name="insert.xref.page.number">yes</xsl:param>
  <xsl:param name="local.l10n.xml" select="document('')"/>
  <l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
    <l:l10n language="en">
      <l:context name="xref">
	<l:template name="page.citation" text=" (p. %p)"/>
      </l:context>
    </l:l10n>
  </l:i18n>
  <!-- END Cross reference style. -->

</xsl:stylesheet>
