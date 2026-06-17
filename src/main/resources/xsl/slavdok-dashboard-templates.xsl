<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:mcracl="xalan://org.mycore.common.xml.MCRXMLFunctions"
  xmlns:mcri18n="xalan://org.mycore.services.i18n.MCRTranslation"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="mcracl mcri18n">

  <xsl:param name="CurrentUser" />
  <xsl:include href="resource:xsl/slavdok-solr-utils.xsl" />

  <xsl:template name="document-card">
    <xsl:param name="solr-query" />
    <xsl:param name="type" />
    <xsl:variable name="role">
      <xsl:choose>
        <xsl:when test="mcracl:isCurrentUserInRole('editor') or mcracl:isCurrentUserInRole('admin')">
          <xsl:value-of select="'admin'" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'user'" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div class="row">
      <div class="col-md-12">
        <div class="card">
          <div class="card-header">
            <h3 class="card-title slav-icon-headline">
              <i class="fas fa-arrow-right" aria-hidden="true" />
              <span>
                <xsl:value-of select="
                  mcri18n:translate(concat('dashboard.header.',$role,'.',$type,'_documents'))
                " />
              </span>
            </h3>
          </div>
          <div class="card-body">
            <div class="row">
              <div class="col-12 result_body">
                <div class="result_list">
                  <div id="hit_list">
                    <xsl:copy-of select="
                      document(
                        concat(
                          'xslStyle:response2html:xslTransform:response-prepared:solr:',
                          $solr-query,
                          '&amp;rows=3&amp;start=0'
                        )
                      )/div/*
                    " />
                  </div>
                </div>
              </div>
            </div>
            <div class="row">
              <a
                href="../servlets/solr/select?{$solr-query}"
                class="btn btn-primary btn-sm"
                style="margin:auto; display:block; max-width:200px;">
                <xsl:value-of select="mcri18n:translate('dashboard.button.more')" />
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="published-documents">
    <xsl:variable name="solr-query">
      <xsl:choose>
        <xsl:when test="mcracl:isCurrentUserInRole('editor') or mcracl:isCurrentUserInRole('admin')">
          <xsl:value-of select="'q=state%3Apublished+AND+objectType%3Amods&amp;sort=created+desc'" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="
            concat(
              'q=state%3Apublished%20AND%20createdby%3A',
              $CurrentUser,
              '&amp;fq=objectType:mods&amp;sort=created+desc'
            )
          " />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="document-card">
      <xsl:with-param name="solr-query" select="$solr-query" />
      <xsl:with-param name="type" select="'published'" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="unpublished-documents">
    <xsl:variable name="solr-query">
      <xsl:choose>
        <xsl:when test="mcracl:isCurrentUserInRole('editor') or mcracl:isCurrentUserInRole('admin')">
          <xsl:value-of select="
            concat(
              'q=state%3A%28state%3Asubmitted+OR+state%3Ablocked%29+AND+objectType%3Amods',
              '&amp;sort=created+desc'
            )
          " />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="
            concat(
              'q=state%3Asubmitted%20AND%20createdby%3A',
              $CurrentUser,
              '&amp;fq=objectType:mods&amp;sort=created+desc'
            )
          " />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="document-card">
      <xsl:with-param name="solr-query" select="$solr-query" />
      <xsl:with-param name="type" select="'unpublished'" />
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
