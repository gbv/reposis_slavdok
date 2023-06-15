<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
    xmlns:mcrver="xalan://org.mycore.common.MCRCoreVersion"
    xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions"
    exclude-result-prefixes="i18n mcrver mcrxsl">

  <xsl:import href="resource:xsl/layout/mir-common-layout.xsl" />
  <xsl:param name="piwikID" select="'0'" />

  <xsl:template name="mir.navigation">

    <div class="mir-main-nav">
      <div class="container container-no-padding">
        <nav class="navbar navbar-expand-lg navbar-dark">

          <button
                  class="navbar-toggler order-1"
                  type="button"
                  data-toggle="collapse"
                  data-target="#mir-main-nav__entries"
                  aria-controls="mir-main-nav__entries"
                  aria-expanded="false"
                  aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>

          <div
            id="mir-main-nav__entries"
            class="collapse navbar-collapse mir-main-nav__entries order-4 order-lg-2">
            <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
              <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='search']" />
              <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='publish']" />
              <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='about']" />
              <xsl:call-template name="mir.basketMenu" />
            </ul>
          </div>

          <div class="searchBox order-3 order-sm-2 order-lg-3">
            <xsl:variable name="Find">
              <xsl:choose>
                <xsl:when test="mcrxsl:isCurrentUserInRole('editor') or mcrxsl:isCurrentUserInRole('admin')">
                  <xsl:copy-of select="concat('servlets/solr/', 'find')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:copy-of select="concat('servlets/solr/', 'findPublic')" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <form
                    action="{$WebApplicationBaseURL}{$Find}"
                    class="searchfield_box form-inline my-2 my-lg-0"
                    role="search">
              <input
                      name="condQuery"
                      placeholder="{i18n:translate('mir.navsearch.placeholder')}"
                      class="form-control search-query"
                      id="searchInput"
                      type="text"
                      aria-label="Search" />
              <xsl:choose>
                <xsl:when test="mcrxsl:isCurrentUserInRole('admin') or mcrxsl:isCurrentUserInRole('editor')">
                  <input name="owner" type="hidden" value="createdby:*" />
                </xsl:when>
                <xsl:when test="not(mcrxsl:isCurrentUserGuestUser())">
                  <input name="owner" type="hidden" value="createdby:{$CurrentUser}" />
                </xsl:when>
              </xsl:choose>
              <button type="submit" class="btn btn-primary my-2 my-sm-0">
                <i class="fas fa-search"></i>
              </button>
            </form>
          </div>

          <div id="options_nav_box" class="mir-prop-nav order-2 order-sm-3 order-lg-4">
            <div class="container container-no-padding">
              <nav>
                <ul class="navbar-nav ml-auto flex-row">
                  <xsl:call-template name="mir.loginMenu" />
                  <xsl:call-template name="mir.languageMenu" />
                </ul>
              </nav>
            </div>
          </div>

        </nav>
      </div>
    </div>

    <div id="header_box">
      <div class="clearfix container container-no-padding">
        <div class="project_logo_box">
          <div class="project_logo">
            <a href="{concat($WebApplicationBaseURL,substring($loaded_navigation_xml/@hrefStartingPage,2),$HttpSession)}"
               title="Home"
               class="project-logo__link">
              <span class="fid logo main">SlavDok</span>
              <span class="fid logo sub">Dokumentenserver</span>
            </a>
          </div>
        </div>
      </div>
    </div>

    <!-- Collect the nav links, forms, and other content for toggling -->

  </xsl:template>

  <xsl:template name="mir.jumbotwo">

  </xsl:template>

  <xsl:template name="mir.footer">
    <div class="container container-no-padding">
      <div class="row">
        <div class="col-12 d-flex justify-content-center logo-section">

          <a
            class="sbb-logo-link logo-link"
            href="https://www.staatsbibliothek-berlin.de"
            title="Staatsbibliothek Berlin Home"
            target="_blank">
            <span>Ein Dienst der</span>
            <img
              class="img-fluid"
              src="{$WebApplicationBaseURL}/images/logo-sbb-grau.png"
              alt="Logo SBB" />
          </a>

          <a
            class="dfg-logo-link logo-link"
            href="https://www.dfg.de"
            title="DFG Home"
            target="_blank">
            <span>Gefördert durch</span>
            <img
              class="img-fluid"
              src="{$WebApplicationBaseURL}/images/logo-dfg-grau.png"
              alt="Logo DFG" />
          </a>

          <a
            class="slavistik-logo-link logo-link"
            href="https://slavistik-portal.de/"
            title="Slavistik-Portal Home"
            target="_blank">
            <span>Ein Projekt von</span>
            <img
              class="img-fluid"
              src="{$WebApplicationBaseURL}/images/logo-slavistikportal-grau.png"
              alt="Logo Slavistik-Portal" />
          </a>

        </div>
      </div>
      <div class="row">
        <div class="col-12">
          <ul class="internal_links nav navbar-nav">
            <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='below']/*" mode="footerMenu" />
          </ul>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="slavdok.generate_single_menu_entry">
    <xsl:param name="menuID" />
    <li class="nav-item">
      <xsl:variable name="activeClass">
        <xsl:choose>
          <xsl:when test="$loaded_navigation_xml/menu[@id=$menuID]/item[@href = $browserAddress ]">
          <xsl:text>active</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>not-active</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <a id="{$menuID}" href="{$WebApplicationBaseURL}{$loaded_navigation_xml/menu[@id=$menuID]/item/@href}" class="nav-link {$activeClass}" >
        <xsl:choose>
          <xsl:when test="$loaded_navigation_xml/menu[@id=$menuID]/item/label[lang($CurrentLang)] != ''">
            <xsl:value-of select="$loaded_navigation_xml/menu[@id=$menuID]/item/label[lang($CurrentLang)]" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$loaded_navigation_xml/menu[@id=$menuID]/item/label[lang($DefaultLang)]" />
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </li>
  </xsl:template>

  <xsl:template name="mir.powered_by">
    <xsl:variable name="mcr_version" select="concat('MyCoRe ',mcrver:getCompleteVersion())" />
    <div id="powered_by">
      <a href="http://www.mycore.de">
        <img src="{$WebApplicationBaseURL}mir-layout/images/mycore_logo_small_invert.png" title="{$mcr_version}" alt="powered by MyCoRe" />
      </a>
    </div>

    <!-- Matomo -->
    <xsl:if test="$piwikID &gt; 0">
      <script>
        var _paq = _paq || [];
        _paq.push(['setDoNotTrack', true]);
        _paq.push(['trackPageView']);
        _paq.push(['enableLinkTracking']);
        (function() {
        var u="https://matomo.gbv.de/";
        var objectID = '<xsl:value-of select="//site/@ID" />';
        if(objectID != "") {
        _paq.push(["setCustomVariable",1, "object", objectID, "page"]);
        }
        _paq.push(['setTrackerUrl', u+'piwik.php']);
        _paq.push(['setSiteId', '<xsl:value-of select="$piwikID" />']);
        _paq.push(['setDownloadExtensions', '7z|aac|arc|arj|asf|asx|avi|bin|bz|bz2|csv|deb|dmg|doc|exe|flv|gif|gz|gzip|hqx|jar|jpg|jpeg|js|mp2|mp3|mp4|mpg|mpeg|mov|movie|msi|msp|odb|odf|odg|odp|ods|odt|ogg|ogv|pdf|phps|png|ppt|qt|qtm|ra|ram|rar|rpm|sea|sit|tar|tbz|tbz2|tgz|torrent|txt|wav|wma|wmv|wpd|z|zip']);
        var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
        g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'piwik.js'; s.parentNode.insertBefore(g,s);
        })();
      </script>
      <noscript><p><img src="https://matomo.gbv.de/piwik.php?idsite={$piwikID}" style="border:0;" alt="" /></p></noscript>
    </xsl:if>
    <!-- End Piwik Code -->
  </xsl:template>

</xsl:stylesheet>
