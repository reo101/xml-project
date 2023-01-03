<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>

<xsl:template match="/">
  <html>
  <head>
    <title>Restaurant Catalogue</title>
    <link rel="stylesheet" type="text/css" href="style.css" />
  </head>
  <body>
    <h1>Restaurant Catalogue</h1>
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
  </body>
  </html>
</xsl:template>

</xsl:stylesheet>