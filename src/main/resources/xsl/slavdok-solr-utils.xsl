<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:mcracl="xalan://org.mycore.common.xml.MCRXMLFunctions"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="mcracl">

  <xsl:variable name="solr-find-core">
    <xsl:choose>
      <xsl:when test="mcracl:isCurrentUserInRole('admin') or mcracl:isCurrentUserInRole('editor')">
        <xsl:value-of select="'find'" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'findPublic'" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="solr-select-core">
    <xsl:choose>
      <xsl:when test="
        mcracl:isCurrentUserInRole('admin')
        or mcracl:isCurrentUserInRole('editor')
        or mcracl:isCurrentUserInRole('submitter')
      ">
        <xsl:value-of select="'select'" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'selectPublic'" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
</xsl:stylesheet>
