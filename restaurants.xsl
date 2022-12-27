<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes" />

  <xsl:template match="/">
    <html>
      <head>
        <title>Restaurant Catalog</title>
        <link rel="stylesheet" type="text/css" href="styles.css" />
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
              Location:
              <xsl:value-of select="location" />
            </p>
            <img src="{image}" alt="{name}" />
            <p>
              <xsl:value-of select="description" />
            </p>
            <h4>Reviews</h4>
            <ul>
              <xsl:for-each select="reviews/review">
                <li>
                  <p>
                    Author:
                    <xsl:value-of select="author" />
                  </p>
                  <p>
                    Rating:
                    <xsl:value-of select="rating" />
                  </p>
                  <p>
                    Comment:
                    <xsl:value-of select="comment" />
                  </p>
                </li>
              </xsl:for-each>
            </ul>
            <p>
              Part of the
              <xsl:value-of select="document('')/*/chain[@id=current()/chain/@id]/name" />
              chain
            </p>
          </xsl:for-each>
        </xsl:for-each>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
