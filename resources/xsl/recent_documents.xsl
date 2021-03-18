<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions"
  exclude-result-prefixes="">
  <!-- that breaks solr:find for the rest of the website
    <xsl:include href="response-mir.xsl" />
    <xsl:include href="response-utils.xsl" />
  -->
  <xsl:param name="WebApplicationBaseURL"></xsl:param>
  <xsl:variable name="parameters" select="@data-parameters" />

  <xsl:template match="recent_documents">
    <div class="row">
      <div class="col-md-12">
        <div class="card"></div>
          <div class="card-header">
            <h3 class="card-title">
              <i class="fas fa-arrow-right" style="margin-right:1ex;" aria-hidden="true"/>
              Neueste Veröffentlichungen 2
            </h3>
          </div>
          <div class="col-12 col-sm-8 result_list">
              <xsl:apply-templates select="document(concat('solr:q=', '*&amp;rows=3&amp;sort=created+desc'))//doc|arr[@name='groups']/lst/str[@name='groupValue']" mode="resultList" />
          </div>
        </div>
      </div>
  </xsl:template>

</xsl:stylesheet>