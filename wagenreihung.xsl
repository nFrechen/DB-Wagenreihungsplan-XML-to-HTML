<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


<xsl:template match="time">
  <!-- remove seconds part if zero -->
  <xsl:choose>
    <xsl:when test="string-length(.) = 8 and substring(., 6) = ':00'"><xsl:value-of select="substring(., 1, 5)"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="/">
  <html>
    <head>
      <link rel="stylesheet" href="main.css"/>
    </head>
  <body>
    <div id="header">
      <h2>Wagenreihung <xsl:value-of select="station/name"/></h2>
      <p>Gültig vom <xsl:value-of select="station/validity/from"/> bis <xsl:value-of select="station/validity/to"/>. Datenquelle: <a href="http://data.deutschebahn.com/dataset/data-wagenreihungsplan-soll-daten">data.deutschebahn.com</a>.</p>
    </div>
    <div id="station">
      <xsl:for-each select="station/tracks/track">
      <div class="track">
        <div class="track-name">
          <xsl:value-of select="name"/>
        </div>
        <table class="traintimes">
          <tr>
            <th>Zeit</th>
            <th>Zug</th>
            <th>Richtung</th>
          </tr>
          <xsl:for-each select="trains/train">
            <tr class="traintime">
              <td class="time"><xsl:apply-templates select="time"/></td>
              <!--<span class="additionalText"><xsl:value-of select="additionalText"/></span>-->
              <td>
                <span class="traintype"><xsl:value-of select="traintypes/traintype"/> </span>
                <span class="trainNumbers">
                <xsl:for-each select="trainNumbers/trainNumber">
                  <span class="trainNumber"><xsl:value-of select="."/></span>
                </xsl:for-each>
                </span>
              </td>
              <td class="train">
                <xsl:for-each select="waggons/waggon">
                  <span>

                    <xsl:attribute name="class">
                      <xsl:text>waggon </xsl:text>
                      <xsl:for-each select="sections/identifier">
                        <xsl:value-of select="."/>
                      </xsl:for-each>
                      <xsl:choose>
                        <xsl:when test="type = 'b'">
                          <xsl:text> bistro</xsl:text>
                        </xsl:when>
                        <xsl:when test="type = '1'">
                          <xsl:text> erste</xsl:text>
                        </xsl:when>
                        <xsl:when test="type = '1'">
                          <xsl:text> zweite</xsl:text>
                        </xsl:when>
                        <xsl:when test="type = 'v'">
                          <xsl:text> ICE-Lok</xsl:text>
                        </xsl:when>
                        <xsl:when test="type = 'r'">
                          <xsl:text> ICE-Lok</xsl:text>
                        </xsl:when>
                        <xsl:when test="type = 't'">
                          <xsl:text> Triebwagen</xsl:text>
                        </xsl:when>
                        <xsl:when test="type = 's'">
                          <xsl:text> IC-Lok</xsl:text>
                        </xsl:when>
                      </xsl:choose>

                    </xsl:attribute>


                    <span class="waggon-number"><xsl:value-of select="number"/></span>
                    <span class="waggon-type"><xsl:value-of select="type"/></span>
                    <span class="wagon-section">
                      <xsl:for-each select="sections/identifier">
                        <xsl:value-of select="."/>
                      </xsl:for-each>
                    </span>
                  </span>

                </xsl:for-each>
              </td>

            </tr>
          </xsl:for-each>
        </table>

      </div>
      </xsl:for-each>
    </div>
  </body>
  </html>
</xsl:template>

</xsl:stylesheet>
