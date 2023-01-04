<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="http://www.w3.org/TR/html4/strict.dtd" />

  <xsl:param name="sortOn">type</xsl:param>
  <xsl:param name="sortDataType">text</xsl:param>
  <xsl:param name="sortOrder">ascending</xsl:param>

  <!-- define a key to index all elements by their id -->
  <xsl:key name="elementById" match="*" use="@id"/>

  <!-- identity template to copy everything as-is -->
  <!-- <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template> -->

  <!-- <xsl:template match="catalogue/restaurants/restaurant/*[@idref]"> -->
    <!-- use the key to retrieve the element with the corresponding id -->
    <!-- <xsl:variable name="referencedElement" select="key('elementById', @idref)"/> -->
    <!-- copy the contents of the referenced element -->
    <!-- <xsl:copy>
      <xsl:value-of select="$referencedElement"/>
    </xsl:copy>
  </xsl:template> -->

  <!-- start processing of root -->
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
        <xsl:sort select="*[name(.)=$sortOn and not(@idref)] | key('elementById', *[name(.)=$sortOn]/@idref)"
          order="{$sortOrder}"
          data-type="{$sortDataType}" />
        <tr>
          <td>
            <xsl:value-of select="name" />
          </td>
          <td>
            <xsl:value-of select="key('elementById', type/@idref)" />
          </td>
          <td>
            <xsl:value-of select="key('elementById', region/@idref)" />
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
