<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ext="http://exslt.org/common">
  <xsl:output method="html" indent="yes" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="http://www.w3.org/TR/html4/strict.dtd" />

  <xsl:param name="firstLoad">true</xsl:param>
  <xsl:param name="sortOn">rating</xsl:param>
  <xsl:param name="sortDataType">number</xsl:param>
  <xsl:param name="sortOrder">descending</xsl:param>

  <!-- define a key to index all elements by their id -->
  <xsl:key name="elementById" match="*" use="@id" />

  <!-- start processing of root -->
  <xsl:template match="/">
    <xsl:choose>
      <!-- if that's the first load of the document, 
        then do the full document rendering -->
      <xsl:when test="$firstLoad = 'true'">
        <xsl:call-template name="generate_entire_html"/>
      </xsl:when>
      <!-- otherwise, if that's a reload with new sorting, 
        regenerate the table of restaurant contents only -->
      <xsl:otherwise>
        <xsl:call-template name="generate_sorted_table"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- the template to generate the entire html document -->
  <xsl:template name="generate_entire_html">
    <html>
      <head>
        <title>Restaurant Catalogue</title>
        <meta charset="UFT-8" />

        <!-- import style sheet -->
        <link rel="stylesheet" type="text/css" href="style.css"/>

        <!-- some JQuery -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"/>

        <!-- set the initial sorting parameters in the JS state -->
        <script>
          var sortOn = "<xsl:value-of select='$sortOn'/>";
          var sortOrder = "<xsl:value-of select='$sortOrder'/>";
          var sortDataType = "<xsl:value-of select='$sortDataType'/>";
        </script>

        <!-- load the JS for dynamic resorting -->
        <script type="text/javascript" src="js/home.js"></script>
      </head>
      <body>
        <h1>Restaurant Catalogue</h1>
        <div id="restaurants_table">
          <!-- generate the sorted table -->
          <xsl:call-template name="generate_sorted_table"></xsl:call-template>
        </div>
      </body>
    </html>
  </xsl:template>

  <!-- a template to generate a sorted HTML table element -->
  <xsl:template name="generate_sorted_table">
    <table>
      <!-- first generate the header row -->
      <xsl:call-template name="generate_header_row"/>

      <!-- then iterate over the restaurant elements from the XML data hierarchy -->
      <xsl:for-each select="catalogue/restaurants/restaurant">
        <!-- and sort them in either of two ways: 
          - if the $sortOn element has no @idref attribute, then its content
          - if the $sortOn element has an @idref, then by the content of the element it refers to
        -->
        <xsl:sort select="*[name(.)=$sortOn and not(@idref)] | key('elementById', *[name(.)=$sortOn]/@idref)" 
                  order="{$sortOrder}" 
                  data-type="{$sortDataType}" />
        <tr>
          <!-- apply the necessary template from this level of the tree in order to 
            generate the respective <td> element for each data component (chld of <restaurant>)

              This also works without the specified mode, but we put it there explicitly
              to specify this particular step of the transformation
              with regard to future extensibility of this xsd file
          -->
          <xsl:apply-templates select="*" mode="generate-td"/>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!-- if the element is an image element, then we want an <img> tag -->
  <xsl:template match="image" mode="generate-td">
    <td>
      <img src="{unparsed-entity-uri(@source)}" alt="{../name}" />
    </td>
  </xsl:template>

  <!-- if the element has an idref attribute, then we want to exctract
  the content of the referred element -->
  <xsl:template match="*[@idref]" mode="generate-td">
    <td>
      <xsl:value-of select="key('elementById', @idref)" />
    </td>
  </xsl:template>

  <!-- otherwise (least specific), we just copy the content as plain text -->
  <xsl:template match="*" mode="generate-td">
    <td>
      <xsl:value-of select="." />
    </td>
  </xsl:template>

  <!-- a shorthand template to generate the carets on sorted columns
    if necessary -->
  <xsl:template name="show_sorting_caret">
    <xsl:param name="header_key"/>
    <xsl:if test="$sortOn = $header_key">
      <xsl:if test="$sortOrder = 'ascending'">&#x25B4;</xsl:if>
      <xsl:if test="$sortOrder = 'descending'">&#x25BE;</xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- the template to generate the header row -->
  <xsl:template name="generate_header_row">
    <!-- we define a custom set of header keys
      marking for each header its corresponding element from the XML <restaurant>'s children
      and whether this column should be sortable or not
    -->
    <xsl:variable name="header_keys">
      <key sortable="true">name</key>
      <key sortable="true">type</key>
      <key sortable="true">region</key>
      <key sortable="false">address</key>
      <key sortable="true">rating</key>
      <key sortable="false">image</key>
    </xsl:variable>

    <tr>
      <!-- then we iterate over all header keys -->
      <xsl:for-each select="ext:node-set($header_keys)/key">
        <!-- map the first character to upper case as display value -->
        <xsl:variable name="displayValue" 
          select="concat(translate(substring(., 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'), substring(., 2))" />
        <th>
          <xsl:choose>
            <!-- if this header should be sortable -->
            <xsl:when test="@sortable='true'">
              <!-- render a cute graphical caret to visualize whether
              this is the current header we're sorting by and in which order -->
              <xsl:variable name="caret">
                <xsl:call-template name="show_sorting_caret">
                  <xsl:with-param name="header_key" select="." />
                </xsl:call-template>
              </xsl:variable>

              <!-- and visualize the header displayValue with surrounding carets if necessary -->
              <xsl:value-of select="$caret" />
              <!-- also, for sortable columns, we wrap the displayValue in a link to a
                javascript function to sort by it dynamically on client demand 
                setting the necessary html attributes for the js function to work-->
              <a sort-on="{.}" href="javascript:newSort('{.}')">
                <xsl:value-of select="$displayValue" />
              </a>
              <xsl:value-of select="$caret" />

            </xsl:when>
            <!-- otherwise, if this header is not sortable, we simply display as plain text -->
            <xsl:otherwise>
              <xsl:value-of select="$displayValue" />
            </xsl:otherwise>
          </xsl:choose>
        </th>
      </xsl:for-each>
    </tr>
  </xsl:template>

</xsl:stylesheet>