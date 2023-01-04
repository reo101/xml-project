<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ext="http://exslt.org/common">
  <xsl:output method="html" indent="yes" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="http://www.w3.org/TR/html4/strict.dtd" />

  <xsl:param name="sortOn">type</xsl:param>
  <xsl:param name="sortDataType">text</xsl:param>
  <xsl:param name="sortOrder">ascending</xsl:param>

  <!-- define a key to index all elements by their id -->
  <xsl:key name="elementById" match="*" use="@id"/>

  <!-- start processing of root -->
  <xsl:template match="/">
    <xsl:call-template name="generate_sorted_table"></xsl:call-template>
  </xsl:template>

  <xsl:template name="generate_sorted_table">
    <table>
      <xsl:call-template name="generate_header_row"/>
      <xsl:for-each select="catalogue/restaurants/restaurant">
        <xsl:sort select="*[name(.)=$sortOn and not(@idref)] | key('elementById', *[name(.)=$sortOn]/@idref)"
                  order="{$sortOrder}"
                  data-type="{$sortDataType}" />
        <tr>
          <xsl:apply-templates select="*"/>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <xsl:template match="*">
    <td>
      <xsl:value-of select="."/>
    </td>
  </xsl:template>

  <xsl:template match="*[@idref]">
    <td>
      <xsl:value-of select="key('elementById', @idref)"/>
    </td>
  </xsl:template>

  <xsl:template match="image">
    <td>
      <img src="{unparsed-entity-uri(image/@source)}" alt="{../name}"/>
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
        <xsl:variable name="displayValue" select="concat(translate(substring(., 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'), substring(., 2))"/>
        <th>
          <xsl:choose>
            <xsl:when test="@sortable='true'">
              <xsl:variable name="caret">
                <xsl:call-template name="show_sorting_caret">
                  <xsl:with-param name="header" select="."/>
                </xsl:call-template>
              </xsl:variable>

              <xsl:value-of select="$caret"/>
              <a sort-on="{.}" href="javascript:newSort('{.}')">
                <xsl:value-of select="$displayValue"/>
              </a>
              <xsl:value-of select="$caret"/>
              
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$displayValue"/>
            </xsl:otherwise>
          </xsl:choose>
        </th>
      </xsl:for-each>
    </tr>
  </xsl:template>

</xsl:stylesheet>
