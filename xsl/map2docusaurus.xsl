<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:js="js"
                version="2.0"
                exclude-result-prefixes="xs js">

  <xsl:output method="text"/>
  <!--  <xsl:import href="plugin:org.lwdita:xsl/map2markdown-cover.xsl"/>-->

  <xsl:template match="/">
    <xsl:text>export default</xsl:text>
    <xsl:variable name="data" as="element()*">
      <xsl:apply-templates select="*"/>
    </xsl:variable>
    <xsl:apply-templates select="$data" mode="js"/>
  </xsl:template>

  <xsl:template match="*[contains-token(@class, 'map/map')]">
    <js:object>
      <js:entry name="docs">
        <js:array>
          <xsl:apply-templates select="*[contains-token(@class, 'map/topicref')]"/>
        </js:array>
      </js:entry>
    </js:object>
  </xsl:template>

  <xsl:template match="*[contains-token(@class, 'map/topicref')]">
    <xsl:variable name="items" select="*[contains-token(@class, 'map/topicref')]"/>
    <xsl:variable name="title" as="node()?"
                  select="(*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/navtitle ')],
                           @navtitle,
                           *[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/linktext ') or contains(@class, ' map/linktext ')])[1]"/>
    <xsl:variable name="profiles" as="attribute()*" select="@audience"/>
    <js:object>
      <js:entry name="type">
        <js:string>doc</js:string>
      </js:entry>
      <js:entry name="id">
        <js:string>
          <xsl:value-of select="replace( @href, '\.[^\.]+?$','')"/>
        </js:string>
      </js:entry>
      <xsl:if test="$title">
        <js:entry name="label">
          <js:string>
            <xsl:value-of select="normalize-space($title)"/>
          </js:string>
        </js:entry>
      </xsl:if>
      <xsl:if test="$profiles">
        <js:entry name="customProps">
          <js:object>
            <js:entry name="profiles">
              <js:object>
                <xsl:for-each select="$profiles">
                  <js:entry name="{name()}">
                    <js:array>
                      <xsl:for-each select="tokenize(normalize-space())">
                        <js:string>
                          <xsl:value-of select="."/>
                        </js:string>
                      </xsl:for-each>
                    </js:array>
                  </js:entry>
                </xsl:for-each>
              </js:object>
            </js:entry>
          </js:object>
        </js:entry>
      </xsl:if>
      <xsl:if test="$items">
        <js:entry name="items">
          <js:array>
            <xsl:apply-templates select="*[contains-token(@class, 'map/topicref')]"/>
          </js:array>
        </js:entry>
      </xsl:if>
    </js:object>
  </xsl:template>

  <xsl:mode name="js"/>

  <xsl:template match="js:object" mode="js">
    <xsl:text>{</xsl:text>
    <xsl:for-each select="js:entry">
      <xsl:if test="position() ne 1">,</xsl:if>
      <xsl:value-of select="@name"/>
      <xsl:text>:</xsl:text>
      <xsl:apply-templates select="*" mode="#current"/>
    </xsl:for-each>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="js:array" mode="js">
    <xsl:text>[</xsl:text>
    <xsl:for-each select="*">
      <xsl:if test="position() ne 1">,</xsl:if>
      <xsl:apply-templates select="." mode="#current"/>
    </xsl:for-each>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:variable name="string-escape" as="xs:string">["\\]</xsl:variable>

  <xsl:template match="js:string" mode="js">
    <xsl:text>"</xsl:text>
    <xsl:value-of select="replace(replace(., $string-escape, '\\$0'), '\n', '\\n')"/>
    <xsl:text>"</xsl:text>
  </xsl:template>

</xsl:stylesheet>
