<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions"
                xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
                exclude-result-prefixes="">

  <xsl:template match="recent_documents">
    <div class="row">
      <div class="col-md-12">
        <div class="card">
          <div class="card-header">
            <h3 class="card-title">
              <i class="fas fa-arrow-right" style="margin-right:1ex;" aria-hidden="true" />
              <xsl:value-of select="i18n:translate('index.header.latestPublications')"/>
            </h3>
          </div>
          <div class="card-body">
            <div class="row">
              <div class="col-12 result_body">
                <div class="result_list">
                  <div id="hit_list">
                    <xsl:copy-of select="document('xslStyle:response2html:xslTransform:response-prepared:solr:q=state:published AND objectType:mods&amp;rows=5&amp;start=0&amp;sort=created+desc')/div/*" />
                  </div>
                </div>
              </div>
            </div>
            <div class="row">
              <a href="../servlets/solr/find" class="btn btn-primary btn-sm" style="margin:auto; display:block; max-width:200px;">
                <xsl:value-of select="i18n:translate('index.button.furtherPublications')"/>
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="index_search_form">

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

    <form action="{$Find}" id="project-searchMainPage" class="form-inline" role="search">
      <div class="input-group input-group-lg w-100">
        <input name="condQuery" placeholder="{i18n:translate('project.index_search.placeholder')}" class="form-control search-query" id="project-searchInput" type="text" />
        <div class="input-group-append">
          <button type="submit" class="btn btn-primary">
            <i class="fa fa-search"></i>
          </button>
        </div>
      </div>
    </form>

  </xsl:template>


</xsl:stylesheet>