<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:variable name="is-admin" select="document('userobjectrights:isCurrentUserInRole:admin')/boolean='true'" />
  <xsl:variable name="is-editor" select="document('userobjectrights:isCurrentUserInRole:editor')/boolean='true'" />
  <xsl:variable name="is-submitter" select="document('userobjectrights:isCurrentUserInRole:submitter')/boolean='true'" />

  <xsl:variable name="solr-find-core">
    <xsl:choose>
      <xsl:when test="$is-admin or $is-editor">
        <xsl:value-of select="'find'" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'findPublic'" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="solr-select-core">
    <xsl:choose>
      <xsl:when test="$is-admin or $is-editor or $is-submitter">
        <xsl:value-of select="'select'" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'selectPublic'" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
</xsl:stylesheet>
