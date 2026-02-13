<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:include href="resource:xsl/layout-utils.xsl" />
  <xsl:include href="resource:xsl/response-utils.xsl" />
  <xsl:include href="xslInclude:solrResponse" />
  <xsl:include href="resource:xsl/slavdok-user-rights.xsl" />

  <!-- Changed from find to select in order to work properly with the dashboard-->
  <xsl:param name="proxyBaseURL" select="concat($WebApplicationBaseURL, 'servlets/solr/', $solr-select-core)" />

  <xsl:template match="/">
    <div>
      <xsl:apply-templates select="/response/result/doc" mode="resultList" />
    </div>
  </xsl:template>

</xsl:stylesheet>
