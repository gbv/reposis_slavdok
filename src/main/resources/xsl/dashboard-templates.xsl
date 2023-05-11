<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions"
                xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
                xmlns:encoder="xalan://java.net.URLEncoder"
                exclude-result-prefixes="encoder mcrxsl i18n">

  <xsl:param name="CurrentUser"/>

  <xsl:template match="published_documents">

    <xsl:variable name="solrQuery">
      <xsl:choose>
        <xsl:when test="mcrxsl:isCurrentUserInRole('editor') or mcrxsl:isCurrentUserInRole('admin')">
          <xsl:value-of select="concat('q=', encoder:encode('state:published AND objectType:mods'),'&amp;sort=created+desc')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('q=', encoder:encode(concat('state:published AND createdby:', $CurrentUser)), '&amp;fq=objectType:mods&amp;sort=created+desc')" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="headline">
      <xsl:choose>
        <xsl:when test="mcrxsl:isCurrentUserInRole('editor') or mcrxsl:isCurrentUserInRole('admin')">
          <xsl:value-of select="i18n:translate('dashboard.header.admin.published_documents')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="i18n:translate('dashboard.header.user.published_documents')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <div class="row">
      <div class="col-md-12">
        <div class="card">
          <div class="card-header">
            <h3 class="card-title slav-icon-headline">
              <i class="fas fa-arrow-right" aria-hidden="true" />
              <span><xsl:value-of select="$headline"/></span>
            </h3>
          </div>
          <div class="card-body">
            <div class="row">
              <div class="col-12 result_body">
                <div class="result_list">
                  <div id="hit_list">
                    <xsl:copy-of select="document(concat('xslStyle:response2html:xslTransform:response-prepared:solr:', $solrQuery,'&amp;rows=3&amp;start=0'))/div/*" />
                  </div>
                </div>
              </div>
            </div>
            <div class="row">
              <a href="../servlets/solr/select?{$solrQuery}" class="btn btn-primary btn-sm" style="margin:auto; display:block; max-width:200px;">
                <xsl:value-of select="i18n:translate('dashboard.button.more')"/>
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="unpublished_documents">
    <xsl:variable name="solrQuery">
      <xsl:choose>
        <xsl:when test="mcrxsl:isCurrentUserInRole('editor') or mcrxsl:isCurrentUserInRole('admin')">
          <xsl:value-of select="concat('q=', encoder:encode('state:(state:submitted OR state:blocked) AND objectType:mods'),'&amp;sort=created+desc')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('q=', encoder:encode(concat('state:submitted AND createdby:', $CurrentUser)), '&amp;fq=objectType:mods&amp;sort=created+desc')" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="headline">
      <xsl:choose>
        <xsl:when test="mcrxsl:isCurrentUserInRole('editor') or mcrxsl:isCurrentUserInRole('admin')">
          <xsl:value-of select="i18n:translate('dashboard.header.admin.unpublished_documents')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="i18n:translate('dashboard.header.user.unpublished_documents')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <div class="row">
      <div class="col-md-12">
        <div class="card">
          <div class="card-header">
            <h3 class="card-title slav-icon-headline">
              <i class="fas fa-arrow-right" aria-hidden="true" />
              <span><xsl:value-of select="$headline"/></span>
            </h3>
          </div>
          <div class="card-body">
            <div class="row">
              <div class="col-12 result_body">
                <div class="result_list">
                  <div id="hit_list">
                    <xsl:copy-of select="document(concat('xslStyle:response2html:xslTransform:response-prepared:solr:', $solrQuery,'&amp;rows=3&amp;start=0'))/div/*" />
                  </div>
                </div>
              </div>
            </div>
            <div class="row">
              <a href="../servlets/solr/select?{$solrQuery}" class="btn btn-primary btn-sm" style="margin:auto; display:block; max-width:200px;">
                <xsl:value-of select="i18n:translate('dashboard.button.more')"/>
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>
