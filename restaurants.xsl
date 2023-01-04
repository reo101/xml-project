<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ext="http://exslt.org/common">
  <xsl:output method="html" indent="yes" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="http://www.w3.org/TR/html4/strict.dtd" />

  <xsl:param name="firstLoad">true</xsl:param>
  <xsl:param name="sortOn">type</xsl:param>
  <xsl:param name="sortDataType">text</xsl:param>
  <xsl:param name="sortOrder">ascending</xsl:param>

  <!-- define a key to index all elements by their id -->
  <xsl:key name="elementById" match="*" use="@id" />

  <!-- start processing of root -->
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$firstLoad = 'true'">
        <xsl:call-template name="full"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="generate_sorted_table"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="full">
    <html>
      <head>
        <title>Restaurant Catalogue</title>
        <link rel="stylesheet" type="text/css" href="style.css" />
        <meta charset="UFT-8" />

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
        <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.13.2/themes/smoothness/jquery-ui.css" />
        <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.13.2/jquery-ui.min.js"></script>

        <script type="text/javascript" src="js/home.js"></script>
      </head>
      <body>
        <h1>Restaurant Catalogue</h1>
        <div id="restaurants_table">
          <xsl:call-template name="generate_sorted_table"></xsl:call-template>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="generate_sorted_table">
    <table>
      <xsl:call-template name="generate_header_row" />
      <xsl:for-each select="catalogue/restaurants/restaurant">
        <xsl:sort select="*[name(.)=$sortOn and not(@idref)] | key('elementById', *[name(.)=$sortOn]/@idref)" order="{$sortOrder}" data-type="{$sortDataType}" />
        <tr>
          <xsl:apply-templates select="*" />
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template match="*">
    <td>
      <xsl:value-of select="." />
    </td>
  </xsl:template>

  <xsl:template match="*[@idref]">
    <td>
      <xsl:value-of select="key('elementById', @idref)" />
    </td>
  </xsl:template>

  <xsl:template match="image">
    <td>
      <img src="{unparsed-entity-uri(image/@source)}" alt="{../name}" />
    </td>
  </xsl:template>

  <xsl:template name="show_sorting_caret">
    <xsl:param name="header" />
    <xsl:if test="$sortOn = $header">
      <xsl:if test="$sortOrder = 'ascending'">&#x25B4;</xsl:if>
      <xsl:if test="$sortOrder = 'descending'">&#x25BE;</xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="generate_header_row">
    <xsl:variable name="elements">
      <element sortable="true">name</element>
      <element sortable="true">type</element>
      <element sortable="true">region</element>
      <element sortable="false">address</element>
      <element sortable="true">rating</element>
      <element sortable="false">image</element>
    </xsl:variable>

    <tr>
      <xsl:for-each select="ext:node-set($elements)/element">
        <xsl:variable name="displayValue" select="concat(translate(substring(., 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'), substring(., 2))" />
        <th>
          <xsl:choose>
            <xsl:when test="@sortable='true'">
              <xsl:variable name="caret">
                <xsl:call-template name="show_sorting_caret">
                  <xsl:with-param name="header" select="." />
                </xsl:call-template>
              </xsl:variable>

              <xsl:value-of select="$caret" />
              <a sort-on="{.}" href="javascript:newSort('{.}')">
                <xsl:value-of select="$displayValue" />
              </a>
              <xsl:value-of select="$caret" />

            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$displayValue" />
            </xsl:otherwise>
          </xsl:choose>
        </th>
      </xsl:for-each>
    </tr>
  </xsl:template>

</xsl:stylesheet>
