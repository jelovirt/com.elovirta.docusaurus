<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="plugin:org.lwdita:xsl/dita2mdx.xsl"/>

  <xsl:template name="ast-attibutes"/>

<!--  <xsl:template match="*" mode="chapterHead">-->
<!--    <head>-->
<!--      <map>-->
<!--        <entry key="profiles">-->
<!--          <map>-->
<!--            <entry key="audience">-->
<!--              <array>-->
<!--                <entry>novice</entry>-->
<!--              </array>-->
<!--            </entry>-->
<!--          </map>-->
<!--        </entry>-->
<!--      </map>-->
<!--    </head>-->
<!--  </xsl:template>-->

  <xsl:template match="*[@audience]" priority="1000">
    <component name="Audience">
      <prop name="only" value="{@audience}"/>
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
