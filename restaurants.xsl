<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes" />

  <xsl:template match="/">
    <html>
      <head>
        <title>Restaurant Catalog</title>
        <link rel="stylesheet" type="text/css" href="style.css" />
      </head>
      <body>
        <h1>Restaurant Catalog</h1>
        <xsl:for-each select="restaurants/region">
          <h2>
            <xsl:value-of select="name" />
          </h2>
          <xsl:for-each select="restaurant">
            <h3>
              <xsl:value-of select="name" />
            </h3>
            <p>
              Type:
              <xsl:value-of select="type" />
            </p>
            <p>
              Region:
              <xsl:value-of select="region" />
            </p>
            <p>
              Address:
              <xsl:value-of select="address" />
            </p>
            <p>
              Rating:
              <xsl:value-of select="rating" />
            </p>
          </xsl:for-each>
        </xsl:for-each>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
