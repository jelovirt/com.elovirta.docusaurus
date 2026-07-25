<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:js="js"
                exclude-result-prefixes="js">

  <xsl:import href="plugin:org.lwdita:xsl/dita2mdx.xsl"/>

  <xsl:template name="ast-attibutes"/>

  <xsl:template match="*" mode="chapterHead">
    <xsl:call-template name="getMeta"/>
  </xsl:template>

  <xsl:template name="getMeta">
    <xsl:variable name="fields" as="element()*">
      <xsl:call-template name="get-value">
        <xsl:with-param name="values" select="*[contains(@class, ' topic/title ')]"/>
      </xsl:call-template>
      <xsl:for-each select="*[contains(@class, ' topic/prolog ')] | /dita/*[1]/*[contains(@class, ' topic/prolog ')]">
        <xsl:call-template name="get-value">
          <xsl:with-param name="values" select="*[contains(@class, ' topic/author ')]"/>
        </xsl:call-template>
        <xsl:call-template name="get-value">
          <xsl:with-param name="values" select="*[contains(@class, ' topic/source ')]"/>
        </xsl:call-template>
        <xsl:call-template name="get-value">
          <xsl:with-param name="values" select="*[contains(@class, ' topic/publisher ')]"/>
        </xsl:call-template>
        <xsl:call-template name="get-value">
          <xsl:with-param name="values" select="*[contains(@class, ' topic/permissions ')]/@view"/>
          <xsl:with-param name="key" select="'permissions'"/>
        </xsl:call-template>
        <xsl:for-each select="*[contains(@class, ' topic/metadata ')]">
          <xsl:call-template name="get-value">
            <xsl:with-param name="values" select="*[contains(@class, ' topic/audience ')]"/>
          </xsl:call-template>
          <xsl:call-template name="get-value">
            <xsl:with-param name="values" select="*[contains(@class, ' topic/category ')]"/>
          </xsl:call-template>
          <xsl:call-template name="get-value">
            <xsl:with-param name="values" select="*[contains(@class, ' topic/keywords ')]/*[contains(@class, ' topic/keyword ')]"/>
          </xsl:call-template>
        </xsl:for-each>
        <xsl:call-template name="get-value">
          <xsl:with-param name="values" select="*[contains(@class, ' topic/resourceid ')]/@appid"/>
          <xsl:with-param name="key" select="'resourceid'"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:variable>
    <xsl:if test="exists($fields)">
      <head>
        <map>
          <xsl:copy-of select="$fields"/>
        </map>
      </head>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*[@audience | @product | @platform | @otherprops]" priority="1000">
    <component name="Profile">
      <xsl:for-each select="@audience | @product | @platform | @otherprops">
        <prop name="{name()}">
          <js:array>
            <xsl:for-each select="tokenize(normalize-space(.), '\s+')">
              <js:string>
                <xsl:value-of select="."/>
              </js:string>
            </xsl:for-each>
          </js:array>
        </prop>
      </xsl:for-each>
      <xsl:next-match/>
    </component>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/note ')]" name="topic.note">
    <xsl:variable name="type" select="if (exists(@type)) then @type else 'note'"/>
    <xsl:variable name="title">
      <xsl:call-template name="getVariable">
        <xsl:with-param name="id" select="concat(upper-case(substring($type, 1, 1)),
                                                         substring($type, 2))"/>
      </xsl:call-template>
    </xsl:variable>
    <note type="{$type}" title="{$title}">
      <xsl:apply-templates/>
    </note>
  </xsl:template>

  <!-- AST -->

  <xsl:template match="note" mode="ast">
    <xsl:text>:::</xsl:text>
    <xsl:value-of select="@type"/>
    <xsl:value-of select="$linefeed"/>
    <xsl:value-of select="$linefeed"/>
    <xsl:call-template name="process-inline-contents"/>
    <xsl:value-of select="$linefeed"/>
    <xsl:value-of select="$linefeed"/>
    <xsl:text>:::</xsl:text>
    <xsl:value-of select="$linefeed"/>
    <xsl:value-of select="$linefeed"/>
  </xsl:template>

</xsl:stylesheet>
