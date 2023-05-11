<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions"
                xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
                xmlns:encoder="xalan://java.net.URLEncoder"
                exclude-result-prefixes="mcrxsl i18n encoder">

  <xsl:variable name="Find">
    <xsl:choose>
      <xsl:when test="mcrxsl:isCurrentUserInRole('editor') or mcrxsl:isCurrentUserInRole('admin')">
        <xsl:copy-of select="concat('../servlets/solr/', 'find')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="concat('../servlets/solr/', 'findPublic')" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="solrQuery" select="concat('q=', encoder:encode('state:published AND objectType:mods'))" />

  <xsl:template match="recent_documents">
    <div class="card">
      <div class="card-header">
        <h3 class="card-title slav-icon-headline">
          <i class="fas fa-arrow-right" aria-hidden="true" />
          <xsl:value-of select="i18n:translate('index.header.latestPublications')"/>
        </h3>
      </div>
      <div class="card-body">
        <div class="row">
          <div class="col-12 result_body">
            <div class="result_list">
              <div id="hit_list">
                <xsl:copy-of select="document(concat('xslStyle:response2html:xslTransform:response-prepared:solr:', $solrQuery, '&amp;rows=5&amp;start=0&amp;sort=created+desc'))/div/*" />
              </div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-12 text-center">
            <a href="{$Find}" class="btn btn-primary btn-sm">
              <xsl:value-of select="i18n:translate('index.button.furtherPublications')"/>
            </a>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="index_search_form">
    <form action="{$Find}" id="project-searchMainPage" class="form-inline" role="search">
      <div class="input-group input-group-lg w-100">
        <input name="condQuery" placeholder="{i18n:translate('project.index_search.placeholder')}" class="form-control search-query" id="project-searchInput" type="text" />
        <div class="input-group-append">
          <button type="submit" class="btn btn-primary">
            <i class="fa fa-search"/>
          </button>
        </div>
      </div>
    </form>
  </xsl:template>

</xsl:stylesheet>
