<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:include href="resource:xsl/slavdok-user-rights.xsl" />

  <xsl:template match="recent-documents">
    <xsl:variable name="solr-uri" select="
      concat(
        'xslStyle:response2html:xslTransform:response-prepared:solr:',
        'q=state%3Apublished+AND+objectType%3Amods',
        '&amp;rows=5',
        '&amp;start=0',
        '&amp;sort=created+desc'
      )
    " />
    <div class="card">
      <div class="card-header">
        <h3 class="card-title slav-icon-headline">
          <i class="fas fa-arrow-right" aria-hidden="true" />
          <xsl:value-of select="document('i18n:index.header.latestPublications')/i18n/text()" />
        </h3>
      </div>
      <div class="card-body">
        <div class="row">
          <div class="col-12 result_body">
            <div class="result_list">
              <div id="hit_list">
                <xsl:copy-of select="document($solr-uri)/div/*"/>
              </div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-12 text-center">
            <a href="{concat('../servlets/solr/', $solr-find-core)}" class="btn btn-primary btn-sm">
              <xsl:value-of select="document('i18n:index.button.furtherPublications')/i18n/text()" />
            </a>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="index-search-form">
    <form
      action="{concat('../servlets/solr/', $solr-find-core)}"
      id="project-searchMainPage"
      class="form-inline"
      role="search">
      <div class="input-group input-group-lg w-100">
        <input
          name="condQuery"
          placeholder="{document('i18n:project.index_search.placeholder')/i18n/text()}"
          class="form-control search-query"
          id="project-searchInput"
          type="text"
        />
        <div class="input-group-append">
          <button type="submit" class="btn btn-primary">
            <i class="fa fa-search"/>
          </button>
        </div>
      </div>
    </form>
  </xsl:template>

</xsl:stylesheet>
