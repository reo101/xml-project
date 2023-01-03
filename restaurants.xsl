<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>

<xsl:template match="/">
  <xsl:call-template name="sort_table">
    <xsl:with-param name="sortOn">rating</xsl:with-param>
    <xsl:with-param name="sortOrder">descending</xsl:with-param>
    <xsl:with-param name="sortDataType">number</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="sort_table">
  <xsl:param name="sortOn"/>
  <xsl:param name="sortDataType"/>
  <xsl:param name="sortOrder"/>
    <table>
      <tr>
        <th>Name</th>
        <th>Type</th>
        <th>Region</th>
        <th>Address</th>
        <th>Rating</th>
        <th>Image</th>
      </tr>
      <xsl:for-each select="catalogue/restaurants/restaurant">
        <xsl:sort select="*[name(.)=$sortOn]" order="{$sortOrder}" data-type="{$sortDataType}"/>
        <tr>
          <td><xsl:value-of select="name"/></td>
          <td>
            <xsl:value-of select="../../types/type[@id=current()/type/@idref]"/>
          </td>
          <td>
            <xsl:value-of select="../../regions/region[@id=current()/region/@idref]"/>
          </td>
          <td><xsl:value-of select="address"/></td>
          <td><xsl:value-of select="rating"/></td>
          <td>
            <img src="{unparsed-entity-uri(image/@source)}" alt="{name}"/>
          </td>
        </tr>
      </xsl:for-each>
    </table>
</xsl:template>

</xsl:stylesheet>