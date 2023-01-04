<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="http://www.w3.org/TR/html4/strict.dtd" />

  <xsl:param name="sortOn" />
  <xsl:param name="sortDataType" />
  <xsl:param name="sortOrder" />

  <xsl:template match="/">
    <xsl:call-template name="sort_table"></xsl:call-template>
  </xsl:template>

  <xsl:template name="sort_table">
    <table>
      <tr>
        <th>
          <a href="javascript:newSort('name')">Name</a>
        </th>
        <th>
          <a href="javascript:newSort('type')">Type</a>
        </th>
        <th>
          <a href="javascript:newSort('region')">Region</a>
        </th>
        <th>
          <a href="javascript:newSort('address')">Address</a>
        </th>
        <th>
          <a href="javascript:newSort('rating')">Rating</a>
        </th>
        <th>Image</th>
      </tr>
      <xsl:for-each select="catalogue/restaurants/restaurant">
        <xsl:variable name="sortKey" select="*[name(.)=$sortOn]"/>
        <xsl:when test="not($sortKey)">
          <xsl:variable name="sortKey">
            <xsl:copy-of select="id(*[name(.)=$sortOn]/@idref)"/>
          </xsl:variable>
        </xsl:when>
        <xsl:sort select="sortKey" order="{$sortOrder}" data-type="{$sortDataType}" />
        <tr>
          <td>
            <xsl:value-of select="name" />
          </td>
          <td>
            <xsl:value-of select="../../types/type[@id=current()/type/@idref]" />
          </td>
          <td>
            <xsl:value-of select="../../regions/region[@id=current()/region/@idref]" />
          </td>
          <td>
            <xsl:value-of select="address" />
          </td>
          <td>
            <xsl:value-of select="rating" />
          </td>
          <td>
            <img src="{unparsed-entity-uri(image/@source)}" alt="{name}" />
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

</xsl:stylesheet>
