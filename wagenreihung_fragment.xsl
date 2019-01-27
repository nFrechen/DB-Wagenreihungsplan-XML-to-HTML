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


<xsl:template match="identifier">
  <xsl:value-of select="."/>
</xsl:template>


<xsl:template match="trainNumber">
  <xsl:value-of select="."/>
</xsl:template>


<xsl:template match="/">
  <div class="container-fluid">
    <div id="header">
      <h2>Wagenreihung <xsl:value-of select="station/name"/><span class="DS100"><xsl:value-of select="station/shortcode"/></span></h2>
      <p>Gültig vom <xsl:value-of select="station/validity/from"/> bis <xsl:value-of select="station/validity/to"/>. Datenquelle: <a href="http://data.deutschebahn.com/dataset/data-wagenreihungsplan-soll-daten" target="_blank">data.deutschebahn.com/dataset/data-wagenreihungsplan-soll-daten</a>.</p>
    </div>
    <div id="station">
      <xsl:apply-templates select="station/tracks/track"/>
    </div>
  </div>
</xsl:template>


<xsl:template match="track">
  <div class="track">
    <div class="track-name">
      <xsl:value-of select="name"/>
    </div>
    <table class="traintimes">
      <tr>
        <th>Zeit</th>
        <th>Zug</th>
        <th>Richtung</th>
        <th>Wagen</th>
        <th>Zusatzinfo</th>
      </tr>
      <xsl:apply-templates select="trains/train"/>
    </table>

  </div>
</xsl:template>


<xsl:template match="train">
  <tr class="traintime">
    <td class="time"><xsl:apply-templates select="time"/></td>
    <td>
      <xsl:for-each select="traintypes/traintype">
        <xsl:variable name="pos" select="position()"/>
        <span class="traintype"><xsl:apply-templates select="."/></span>
        <span class="trainNumber"><xsl:apply-templates select="../../trainNumbers/trainNumber[$pos]"/></span>
        <xsl:if test="position() != last()"><br/></xsl:if>
      </xsl:for-each>
    </td>
    <td>
      <xsl:for-each select="subtrains/subtrain">
        <span class="destination">
          <span class="via">
            <xsl:for-each select="destination/destinationVia/item">
              <span><xsl:value-of select="."/></span>
            </xsl:for-each>
          </span>
          <span class="destinationName"><xsl:value-of select="destination/destinationName"/></span>
        </span>
      </xsl:for-each>
    </td>
    <td class="train">
      <xsl:apply-templates select="waggons/waggon"/>
    </td>
    <td>
      <span class="additionalText"><xsl:value-of select="additionalText"/></span>
    </td>

  </tr>
</xsl:template>


<xsl:template match="waggon">
  <span>

    <xsl:attribute name="class">
      <xsl:text>waggon </xsl:text>
      <xsl:for-each select="sections/identifier">
        <xsl:apply-templates select="."/>
        <xsl:if test="position() != last()"><xsl:text> </xsl:text></xsl:if>
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
        <xsl:apply-templates select="."/>
        <xsl:if test="position() != last()">/</xsl:if>
      </xsl:for-each>
    </span>
    <span class="waggon-symbols">
      <xsl:call-template name="tokenize">
          <xsl:with-param name="pText" select="symbols"/>
      </xsl:call-template>
    </span>
  </span>
</xsl:template>

<xsl:template name="tokenize">
    <xsl:param name="pText"/>
    <xsl:if test="string-length($pText)">
        <span class="symbol">
            <xsl:choose>
              <xsl:when test="substring($pText, 1,1) = 'A'">
                <a href="#" class="fas fa-mug-hot" data-toggle="popover" data-trigger="hover" data-content="Bordbistro"></a>
              </xsl:when>
              <xsl:when test="substring($pText, 1,1) = 'B'">
                <a href="#" class="fas fa-plane-departure" data-toggle="popover" data-trigger="hover" data-content="Lufthansa Kontingent"></a>
              </xsl:when>
              <xsl:when test="substring($pText, 1,1) = 'C'">
                <a href="#"  data-toggle="popover" data-trigger="hover" class="fas fa-address-card " data-content="bahn.comfort-Bereich"></a>
              </xsl:when>
              <xsl:when test="substring($pText, 1,1) = 'D'">
                <a href="#"  data-toggle="popover" data-trigger="hover" class="fas fa-cookie-bite" data-content="Snack-Point (Imbiss)"></a>
              </xsl:when>
              <xsl:when test="substring($pText, 1,1) = 'E'">
                <a href="#"  data-toggle="popover" data-trigger="hover" class="fas fa-comment-slash" data-content="Ruhebereich"></a>
                <!-- eventuell auch fa-bolume-mute verwenden -->
              </xsl:when>
              <xsl:when test="substring($pText, 1,1) = 'F'">
                <a href="#"  data-toggle="popover" data-trigger="hover" class="fas fa-users" data-content="Familienbereich"></a>
              </xsl:when>
              <xsl:when test="substring($pText, 1,1) = 'G'">
                <a href="#"  data-toggle="popover" data-trigger="hover" class="fas fa-glasses-cheers" data-content="Club"></a>
              </xsl:when>
              <xsl:when test="substring($pText, 1,1) = 'H'">
                <a href="#"  data-toggle="popover" data-trigger="hover" class="fas fa-laptop" data-content="Office"></a>
              </xsl:when>
              <xsl:when test="substring($pText, 1,1) = 'I'">
                <a href="#"  data-toggle="popover" data-trigger="hover" class="fas fa-phone-slash" data-content="Silence"></a>
              </xsl:when>
              <xsl:when test="substring($pText, 1,1) = 'J'">
                <a href="#"  data-toggle="popover" data-trigger="hover" class="fas fa-globe" data-content="Traveller"></a>
              </xsl:when>

              <xsl:when test="substring($pText, 1,1) = 'a'">
                <a href="#"  data-toggle="popover" data-trigger="hover" class="fas fa-mail-bulk  " data-content="ic:kurier (Kuriersendungen)"></a>
                <!-- eventuell fa-dolly -->
              </xsl:when>
              <xsl:when test="substring($pText, 1,1) = 'b'">
                <a href="#"  data-toggle="popover" data-trigger="hover" class="fas fa-car" data-content="Autotransportwagen"></a>
              </xsl:when>
              <xsl:when test="substring($pText, 1,1) = 'c'">
                <a href="#"  data-toggle="popover" data-trigger="hover" class="fas fa-phone" data-content="Telefon"></a>
              </xsl:when>
              <xsl:when test="substring($pText, 1,1) = 'd'">
                <a href="#"  data-toggle="popover" data-trigger="hover" class="fas fa-envelope" data-content="Post"></a>
              </xsl:when>
              <xsl:when test="substring($pText, 1,1) = 'e'">
                <a href="#" class="fas fa-wheelchair" data-toggle="popover" data-trigger="hover" data-content="Rollstuhlgerechter Wagen"></a>
              </xsl:when>
              <xsl:when test="substring($pText, 1,1) = 'f'">
                <a href="#"  data-toggle="popover" data-trigger="hover" class="fas fa-smoking-ban" data-content="Nichtraucher"></a>
              </xsl:when>
              <xsl:when test="substring($pText, 1,1) = 'g'">
                <a href="#"  data-toggle="popover" data-trigger="hover" class="fas fa-smoking" data-content="Raucher"></a>
              </xsl:when>
              <xsl:when test="substring($pText, 1,1) = 'h'">
                <a href="#"  data-toggle="popover" data-trigger="hover" class="fas fa-bicycle" data-content="Fahrrad-Beförderung"></a>
              </xsl:when>
              <!-- i = Wagen-Nummer -->
              <!-- j existiert nicht -->
              <xsl:when test="substring($pText, 1,1) = 'k'">
                <a href="#"  data-toggle="popover" data-trigger="hover" class="fas fa-expand" data-content="Großraumwagen"></a>
                <!-- eventuell fa-cube, fa-grip-horizontal, square-->
              </xsl:when>
              <xsl:when test="substring($pText, 1,1) = 'l'">
                <a href="#"  data-toggle="popover" data-trigger="hover" class="fas fa-mask" data-content="Schlafwagen"></a>
              </xsl:when>
              <xsl:when test="substring($pText, 1,1) = 'm'">
                <a href="#"  data-toggle="popover" data-trigger="hover" class="fas fa-bed" data-content="Liegewagen"></a>
              </xsl:when>
              <xsl:when test="substring($pText, 1,1) = 'n'">
                <a href="#" class="fas fa-universal-access" data-toggle="popover" data-trigger="hover" data-content="Plätze für mobilitätseingeschränkte Menschen"></a>
              </xsl:when>
              <xsl:when test="substring($pText, 1,1) = 'o'">
                <a href="#"  data-toggle="popover" data-trigger="hover" class="fas fa-baby" data-content="Kleinkindabteil"></a>
              </xsl:when>
              <xsl:when test="substring($pText, 1,1) = 'p'">
                <a href="#" class="fas fa-utensils" data-toggle="popover" data-trigger="hover" data-content="Bordrestaurant"></a>
              </xsl:when>
              <xsl:when test="substring($pText, 1,1) = 'w'">
                <a href="#"  data-toggle="popover" data-trigger="hover" class="fas fa-info-circle" data-content="Rezeption"></a>
              </xsl:when>
              <xsl:when test="substring($pText, 1,1) = 'y'">
                <a href="#"  data-toggle="popover" data-trigger="hover" class="fas fa-person-booth" data-content="Schlafabteile Deluxe"></a>
              </xsl:when>
              <xsl:when test="substring($pText, 1,1) = 'x'">
                <a href="#"  data-toggle="popover" data-trigger="hover" class="fas fa-couch" data-content="Liegesesselwagen"></a>
              </xsl:when>

              <xsl:otherwise>
                <xsl:value-of select="substring($pText, 1,1)"/>
              </xsl:otherwise>
              <!-- weitere icons: Sprechblasen: fa-comments, -->
            </xsl:choose>
        </span>
        <xsl:call-template name="tokenize">
            <xsl:with-param name="pText" select="substring($pText, 2)"/>
        </xsl:call-template>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>
