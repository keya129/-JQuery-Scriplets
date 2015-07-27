<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:inv="http://wwww.investis.com/inv"
 xmlns:msxsl="urn:schemas-microsoft-com:xslt"  xmlns:js="urn:custom-javascript" exclude-result-prefixes="msxsl js inv ">
  <xsl:output method="html" indent="yes"/>
  <xsl:param name="category" />
  <xsl:param name="freeText" />
  <xsl:param name="month" />
  <xsl:param name="year" />
  <xsl:param name="resultNotFoundMessage" />
  <xsl:param name="filterCount" />
  <xsl:param name="CurrentPage" select="1" />

  <!--PRODUCER OPTIONS START-->
  <!--Provide PARENT NODE STRUCTURE in XML Feed 
  For example the following RNS XML Structure: 
  <rss><channel><item>
		<Date>Date</Date>
		<Title>Title text</Title>
		<Link>http://....</Link>
  </item></channel></rss>
  Parent Nodes will be provided as: select="rss/channel/item"-->
  <xsl:variable name="ParentNodes" select="rss/channel/item" />

  <!--MAPPING for each RNS XML Item Nodes
  For example: RNS Item Node name = RNSSummary; RNS Item Title Node name = Subject; etc.
  not all values require to be modified or removed only when differences from this example exist-->
  <xsl:variable name="Item" select="'item'" />
  <xsl:variable name="Title" select="'title'" />
  <xsl:variable name="Link" select="'link'" />
  <xsl:variable name="File" select="'link'" />
  <xsl:variable name="PubDate" select="'description'" />
  <xsl:variable name="CurrYear" select="''" />

  <!--MAPPING for RNS Date Format-->
  <!--Specify Date FORMAT appearing in XML Feed
  Options listed below: 'yyyy-MM-dd', 'dd-MMM-yyyy' etc. 
  Where: d-day, M-month and y-year-->
  <xsl:variable name="DateFormat" select="'Day,dd-MMM-yyyy'" />
  <!--<xsl:variable name="DateFormat" select="'Day,dd-MMM-yyyy'" />-->
  <!--<xsl:variable name="DateFormat" select="'dd-MMM-yyyy'" />-->
  <!--<xsl:variable name="DateFormat" select="'MMM-dd-yyyy'" />-->

  <!--Select Desired Date Output FORMAT; 
  Options listed below 'dd-MM-yyyy' etc.
  Where: d-day, M-month and y-year-->
  <!--Example output-->
  <!--<xsl:variable name="outputDateFormat" select="''"/>-->
  <!--No change-->
  <!--<xsl:variable name="outputDateFormat" select="'dd-MM-yyyy'" />-->
  <!--01/01/2010-->
  <!--<xsl:variable name="outputDateFormat" select="'dd-MMM-yyyy'" />-->
  <!--01 Jan 2010-->
  <!--<xsl:variable name="outputDateFormat" select="'MMM-dd-yyyy'" />-->
  <!--Jan 01 2010-->
  <!--<xsl:variable name="outputDateFormat" select="'MM-dd-yyyy'"/>-->
  <!--01/01/2010-->
  <!--<xsl:variable name="outputDateFormat" select="'yyyy-MMM-dd'" />-->
  <!--2010/01/01-->
  <!--<xsl:variable name="outputDateFormat" select="'dd.MM.yyyy'" />-->
  <!--01.01.2010 !Only available for UPM - yyyy-MM-dd-->

  <!--ItemsPerPage refers to total number of RNS Items per page-->
  <xsl:param name="ItemsPerPage" select="5" />

  <!--Specify URL for Individual RNS Story display page 
  Relative path can also be given for ex /rnsDetail.aspx?ResultPageURL-->
  <xsl:param name="RNSDetailPageURL" select="''" />

  <!--PaginationSize - number of page links in Pagination. 
  For example [1][2][3][4][5] displayed when the value is 5. 
  When more pages exist 'First' and 'Last' or similar links appear-->
  <xsl:param name="PaginationSize" select="8" />

  <!-- SHOW/HIDE  Top and Bottom Pagination by setting value for 'select' attribute below: 
  'show' will display element-->
  <xsl:param name="PaginationTop" select="'hide'" />
  <xsl:param name="PaginationBottom" select="'show'" />

  <!--SHOW/HIDE Pagination LINKS by setting value for 'select' attribute below:
  'show' will display element-->
  <xsl:param name="PaginationFirst" select="'hide'" />
  <xsl:param name="PaginationPrevious" select="'hide'" />
  <xsl:param name="PaginationLinks" select="'hide'" />
  <xsl:param name="PaginationNext" select="'show'" />
  <xsl:param name="PaginationLast" select="'hide'" />

  <!--SHOW/HIDE Pagination 'X of Y' by setting value for 'select' attribute below:
  'show' will display element-->
  <xsl:param name="PaginationXofY" select="'hide'" />
  <xsl:param name="PaginationXofYtotal" select="'hide'" />

  <!--PRODUCER OPTIONS END-->



  <!--MAIN Template
  	*** MAKE SURE THE OUTPUT IN HTML STRUCTURE REMAINS VALID WHEN MAKING CHAGES BELOW *** -->
  <xsl:template match="/">
  
    <!--Below variable will have pure node list with and without filter-->
    <xsl:variable name ="FilteredNodes">
      <xsl:choose>
        <xsl:when test="$category!='' or $freeText!='' or $month!='' or $year!=''">
          <xsl:apply-templates select="$ParentNodes" mode="copy">
            <xsl:with-param name="ignoreCheck" select="'false'"></xsl:with-param>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="$category='' and $freeText='' and $month='' and $year=''">
          <xsl:call-template name="findNodes" >
            <xsl:with-param name="FilteredRec" select="$ParentNodes" />
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <!--End Here-->

    <!--Top Pagination-->
    <xsl:if test="$PaginationTop='show'">
      <div class="pagination top">
        <xsl:call-template name="PaginationDetails">
          <xsl:with-param name="Nodes" select="$FilteredNodes"></xsl:with-param>
        </xsl:call-template>
      </div>
    </xsl:if>

    <!-- RNS Definition list-->
   <div class="newsWrapper">
      	  
        <xsl:call-template name="filterRecords">
          <xsl:with-param name="Nodes" select="$FilteredNodes"/>
        </xsl:call-template>
	 <xsl:if test="$PaginationBottom='show'">
      <div class="pagination bottom">
        <xsl:call-template name="PaginationDetails">
          <xsl:with-param name="Nodes" select="$FilteredNodes"></xsl:with-param>
        </xsl:call-template>
      </div>
    </xsl:if>	
  								
  
      </div>
    <!--End of RNS Table-->

    <!--Bottom Pagination-->
   
  </xsl:template>



  <xsl:template name="filterRecords">
    <xsl:param name="Nodes"></xsl:param>

    <!--RNS ITEMS-->
    <xsl:if test="$CurrentPage>0">
      <xsl:for-each select="msxsl:node-set($Nodes)/*[name()=$Item]">
        <xsl:choose>
          <xsl:when test="(position() >= 1 + ($CurrentPage - 1) * $ItemsPerPage) and (position() &lt; (1 + $CurrentPage * $ItemsPerPage))">
            <div>
			  <xsl:if test="position() mod 2!=0">
                <xsl:attribute name="class">
                  <xsl:value-of select="concat('newsItem story',position())" />
                  <!--RNS Table row class value-->
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="position() mod 2=0">
                <xsl:attribute name="class">
                  <xsl:value-of select="concat(concat('newsItem story',position()),' alternative')" />
                  <!--Alternative row class value-->
                </xsl:attribute>
              </xsl:if>

              <div class="calendar-left">
              <p class="date">
                <!--<xsl:value-of select="substring(./pubDate, 6,11)" />-->
<xsl:value-of select="substring-before(substring-after(description,'>'),'&lt;')" />
<xsl:value-of select="substring-before(substring-after(substring-after(description,'/'),'&gt;'),'&lt;')" />

                <!-- FOR DATE SUFFIX, COMMENT OUT ABOVE LINE
				   <xsl:value-of select="substring(./pubDate, 6,11)"/>
				   AND USE THE SUFFIX CODE HERE. SEE WIKI FOR SUFFIX CODE-->
			</p>

              <!--RNS Title-->
              <p class="story">
			
			  <xsl:value-of select="./*[name()=$Title]"/></p>
			  </div>
			  <div class="calendar-right">
				<a target="_blank">
					<xsl:attribute name="href">
						<xsl:value-of select="./*[name()=$File]"/>
					</xsl:attribute>
					Add to Calendar
				</a>
                </div>
            </div>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </xsl:if>

    <!--NO RECORDS FOUND-->
    <xsl:if test="count(msxsl:node-set($Nodes)/*[name()=$Item])=0">
      <p class="noResultsFound">
        <!--attention table structure-->
        <xsl:value-of select="$resultNotFoundMessage"/>
      </p>
    </xsl:if>
  </xsl:template>


  <!-- Pagination SETTINGS
	*** MAKE SURE THE OUTPUT IN HTML STRUCTURE REMAINS VALID WHEN MAKING CHAGES BELOW *** -->
  <xsl:template name="PaginationDetails">
    <xsl:param name="Nodes" />
    <xsl:variable name="SelectedNode" select="msxsl:node-set($Nodes)"/>
    <xsl:variable name="TotalItems" select="count($SelectedNode/*[name()=$Item])" />
    <xsl:variable name="Pages" select="ceiling($TotalItems div $ItemsPerPage)" />
    <div class="nextdataLoad"></div>
	<div class="removeWrapper">
		<div style="display:none; font-weight:bold; font-size:14px; padding:15px; text-align:center;" class="loading">Loading...</div>
		
    <xsl:if test ="$TotalItems > $ItemsPerPage">
      <!--Paggination details-->
      <p class="loadmore">
        <!--FIRST link pagination-->
        <xsl:if test="$PaginationFirst='show'">
          <xsl:if test="$CurrentPage!=1">
            <span class="first">
              <a href="">&lt;&lt;</a>
            </span>
          </xsl:if>
          <!--Comment IF statement below for "First" link NOT to appear for the first page-->
          <xsl:if test="$CurrentPage=1">
            <span class="first noanchor">&lt;&lt;</span>
          </xsl:if>
        </xsl:if>

        <!--PREVIOUS link pagination-->
        <xsl:if test="$PaginationPrevious='show'">
          <xsl:if test="position()!=$CurrentPage">
            <span class="previous">
              <a>
                <xsl:attribute name="href">
                  <xsl:value-of select="concat('?page=', ($CurrentPage)-1)"/>
                </xsl:attribute>&lt;
              </a>
            </span>
          </xsl:if>
          <!--Comment IF statement below for "Previous" link NOT to appear for the first page-->
          <xsl:if test="position()=$CurrentPage">
            <span class="previous noanchor">&lt;</span>
          </xsl:if>
        </xsl:if>

        <!--Page links-->
		 <xsl:if test="$PaginationLinks='show'">
		<xsl:for-each select="$SelectedNode/*[name()=$Item][((position()-1) mod $ItemsPerPage = 0)]">
          <xsl:choose>
            <xsl:when test="(position() > ($CurrentPage - ceiling($PaginationSize div 2)) or position() > (last() - $PaginationSize)) and ((position() &lt; $CurrentPage + $PaginationSize div 2) or (position() &lt; 1 + $PaginationSize))">
              <xsl:if test="position()=$CurrentPage">
                <!--Current Page Class no Link-->
                <!--|-->
                <span>
                  <xsl:attribute name="class">
                    <xsl:value-of select="concat('current p', position())"/>
                  </xsl:attribute>
                  <xsl:value-of select="position()"/>
                </span>
              </xsl:if>

              <!--Remaining Pages Class and Link-->
              <xsl:if test="position()!=$CurrentPage">
                <!--|-->
                <span>
                  <xsl:attribute name="class">
                    <xsl:value-of select="concat('p', position())"/>
                  </xsl:attribute>
                  <a>
                    <xsl:attribute name="href">
                      <xsl:value-of select="concat('?page=', position())"/>
                    </xsl:attribute>
                    <xsl:value-of select="position()"/>
                  </a>
                </span>
              </xsl:if>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
		</xsl:if>
        <!--NEXT link pagination-->
        <xsl:if test="$PaginationNext='show'">
          <xsl:if test="$CurrentPage!=$Pages">
            <!--|-->
            <span class="next">
              <a>
                <xsl:attribute name="href">
                  <xsl:value-of select="concat('?page=', ($CurrentPage)+1)"/>
                </xsl:attribute>More
              </a>
            </span>
          </xsl:if>
          <!--Comment out the IF statement below when "Next" link text should NOT appear for the first page in the list-->
          <xsl:if test="$CurrentPage=$Pages">
            <span class="next noanchor">Finished loading</span>
          </xsl:if>
        </xsl:if>

        <!--LAST link pagination-->
        <xsl:if test="$PaginationLast='show'">
          <xsl:if test="$CurrentPage!=$Pages">
            <span class="last">
              <a>
                <xsl:attribute name="href">
                  <xsl:value-of select="concat('?page=', $Pages)"/>
                </xsl:attribute>
                &gt;&gt;
              </a>
            </span>
          </xsl:if>
          <xsl:if test="$CurrentPage=$Pages">
            <span class="last noanchor">&gt;&gt;</span>
          </xsl:if>
        </xsl:if>
      </p>


      <!--Pagination 'X of Y' SETTINGS No OF PAGED PAGES 
    For example: 1 of 10, 2 of 10 pages based on the current page.-->
      <xsl:if test="$PaginationXofY='show' and $Pages > 1">
        <p class="XofY">
          <xsl:value-of select="number($CurrentPage)"/> of
          <xsl:value-of select="number($Pages)"/> pages
        </p>
      </xsl:if>


      <!--Pagination 'X of Y' SETTINGS FOR EACH RNS ITEM 
    For example: 1 to 5 of 58 RNS Items, 6 to 10 of 58 RNS Items, based on the current page.-->
      <xsl:if test="$PaginationXofYtotal='show' and $Pages > 1">
        <p class="XofY">
          <xsl:value-of select="number(((($CurrentPage)-1)*$ItemsPerPage)+1)"/> to
          <xsl:if test="($CurrentPage*$ItemsPerPage)>$TotalItems">
            <xsl:value-of select="number($TotalItems)"/> of
          </xsl:if>
          <xsl:if test="($CurrentPage*$ItemsPerPage)&lt;$TotalItems">
            <xsl:value-of select="number($CurrentPage*$ItemsPerPage)"/> of total
          </xsl:if>
          <xsl:value-of select="number($TotalItems)"/> pages
        </p>
      </xsl:if>
    </xsl:if>
	</div>
  </xsl:template>
  <!-- Pagination SETTINGS End-->


  <xsl:template name="findNodes">
    <xsl:for-each select="$ParentNodes">
	<xsl:sort select="@date" data-type="number" order="ascending"/>
      <!--DISPLAY RNS FOR ALL YEARS - REMOVE THOSE COMMENTS ...

        <xsl:copy>
          <xsl:apply-templates select="@* | node()" mode="copy"/>
        </xsl:copy>

	... END REMOVE COMMENTS ALL YEARS; 
	*** REMEMBER TO COMMENT THE DEFAULT YEAR DISPLAY BELOW -->

      <!--DEFAULT SINGLE YEAR RNS STORIES ON PAGE LOAD ...
    Only RNS stories for year 2010 are listed in this example-->
		
      <xsl:if test="$DateFormat='Day,dd-MMM-yyyy'">
        <xsl:if test="contains(substring(./*[name()=$PubDate], 12,5), $CurrYear)">
          <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="copy"/>
          </xsl:copy>
        </xsl:if>
      </xsl:if>
	  
	  
	  <xsl:if test="$DateFormat='yyyy-MM-dd'">
        <xsl:if test="contains(substring(./*[name()=$PubDate], 0,5), $CurrYear)">
          <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="copy"/>
          </xsl:copy>
        </xsl:if>
      </xsl:if>
      <xsl:if test="$DateFormat='dd-MMM-yyyy'">
        <xsl:if test="contains(substring(./*[name()=$PubDate], 8,5), $CurrYear)">
          <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="copy"/>
          </xsl:copy>
        </xsl:if>
      </xsl:if>
      <!-- ... END OF DEFAULT YEAR-->
    </xsl:for-each>
  </xsl:template>


  <xsl:template match="@* | node()" mode="copy">
    <xsl:param name="ignoreCheck" select="'true'"></xsl:param>

    <xsl:choose>
      <xsl:when test="$DateFormat='Day,dd-MMM-yyyy'">
        <xsl:if test="$ignoreCheck='true' or(((contains(./*[name()=$Title], $category) and $category!='') or $category='' )
                    and ((js:IsTextFound(string(./*[name()=$Link]),string(./*[name()=$Title]),$freeText)='true' and $freeText!='') or $freeText='' )
                    and ((contains(substring(./*[name()=$PubDate], 13,4), $year) and $year != '') or $year = '' )
                  and ((js:IsMonthMatch(substring(./*[name()=$PubDate], 9,3),$month) and $month != '') or $month = '' ))">
          <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="copy"/>
          </xsl:copy>
        </xsl:if>
      </xsl:when>



      <xsl:when test="$DateFormat='yyyy-MM-dd'">
        <xsl:choose>
          <xsl:when test="$CurrYear != ''">
            <xsl:if test="$ignoreCheck='true' or(((contains(./*[name()=$Title], $category) and $category!='') or $category='' )
				and ((js:IsTextFound(string(./*[name()=$Link]),string(./*[name()=$Title]),$freeText)='true' and $freeText!='') or $freeText='' )
				and ((contains(substring(./*[name()=$PubDate], 1,4), $year) and $year != '') or $year = '' )
				and ((js:IsMonthMatch(substring(./*[name()=$PubDate], 5,2),$month) and $month != '') or $month = '' ) and substring(./*[name()=$PubDate], 1,4) = $CurrYear)">
              <xsl:copy>
                <xsl:apply-templates select="@* | node()" mode="copy"/>
              </xsl:copy>
            </xsl:if>
          </xsl:when>
          <xsl:when test="$ignoreCheck='true' or(((contains(./*[name()=$Title], $category) and $category!='') or $category='' )
				and ((js:IsTextFound(string(./*[name()=$Link]),string(./*[name()=$Title]),$freeText)='true' and $freeText!='') or $freeText='' )
				and ((contains(substring(./*[name()=$PubDate], 1,4), $year) and $year != '') or $year = '' )
				and ((js:IsMonthMatch(substring(./*[name()=$PubDate], 5,2),$month) and $month != '') or $month = '' ))">
            <xsl:copy>
              <xsl:apply-templates select="@* | node()" mode="copy"/>
            </xsl:copy>
          </xsl:when>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$DateFormat='dd-MMM-yyyy'">
        <xsl:if test="$ignoreCheck='true' or(((contains(./*[name()=$Title], $category) and $category!='') or $category='' )
				and ((js:IsTextFound(string(./*[name()=$Link]),string(./*[name()=$Title]),$freeText)='true' and $freeText!='') or $freeText='' )
				and ((contains(substring(./*[name()=$PubDate], 8,5), $year) and $year != '') or $year = '' )
				and ((js:IsMonthMatch(substring(./*[name()=$PubDate], 4,3),$month) and $month != '') or $month = '' ))">
          <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="copy"/>
          </xsl:copy>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>


  <!--<xsl:if test="$DateFormat='MMM-dd-yyyy'">
      <xsl:if test="$ignoreCheck='true' or(((contains(./*[name()=$Title], $category) and $category!='') or $category='' )
                    and ((js:IsTextFound(string(./*[name()=$Link]),string(./*[name()=$Title]),$freeText)='true' and $freeText!='') or $freeText='' )
                    and ((contains(substring(./*[name()=$PubDate], 8,4), $year) and $year != '') or $year = '' )
                  and ((js:IsMonthMatch(substring(./*[name()=$PubDate], 1,3),$month) and $month != '') or $month = '' ))">
        <xsl:copy>
          <xsl:apply-templates select="@* | node()" mode="copy"/>
        </xsl:copy>
      </xsl:if>
    </xsl:if>-->

  <msxsl:script language="JavaScript" implements-prefix="js">
      
function IsTextFound(strLink,strTitle,freeText){
	var xmlhttp=false;
	try {xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");} /* for IE < 5 */
	catch (e){
		try {xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");}
		catch (E){xmlhttp = false;}
	}
	 
	xmlhttp.open("GET",strLink,false);
	xmlhttp.send("");
	var xmlData=xmlhttp.responseText.toLowerCase();
	if(xmlData.indexOf(freeText.toLowerCase())>0 || strTitle.toLowerCase().indexOf(freeText.toLowerCase())>0) {
		return true;
	}
	else {return false;}
}

  </msxsl:script>

  <msxsl:script language="JavaScript" implements-prefix="js">
      
function IsMonthMatch(month,mon){
	if(mon.indexOf(month)>=0) {return true;}
	else{
		if(mon==1 && month=="Jan"){return true;}
		else if(mon==2 && month=="Feb") {return true;}
		else if(mon==3 && month=="Mar") {return true;}
		else if(mon==4 && month=="Apr") {return true;}
		else if(mon==5 && month=="May") {return true;}
		else if(mon==6 && month=="Jun") {return true;}
		else if(mon==7 && month=="Jul") {return true;}     
		else if(mon==8 && month=="Aug") {return true;}
		else if(mon==9 && month=="Sep") {return true;}
		else if(mon==10 && month=="Oct") {return true;}
		else if(mon==11 && month=="Nov") {return true;}
		else if(mon==12 && month=="Dec") {return true;}
		else {return false;}
	}
}

function makeUrl(url){
  //url = url.replace(/\&/g,"%26");  
  //url = url.replace(/\?/g,"%3F");
  url = url.replace("%0A","");
  url = url.replace("%09","");
  //url = url.replace("http://otp.investis.com/generic/regulatory-story.aspx", "http://otp.investis.com/generic/xml-feed-story-controller.aspx");
  return url;
}

function IsMonthMatch(month){
   if(month == 01) {return "Jan";}
   else if(month == 02) {return "Feb";}
   else if(month == 03) {return "Mar";}
   else if(month == 04) {return "Apr";}
   else if(month == 05) {return "May";}
   else if(month == 06) {return "Jun";}
   else if(month == 07) {return "Jul";}
   else if(month == 08) {return "Aug";}
   else if(month == 09) {return "Sep";}
   else if(month == 10) {return "Oct";}
   else if(month == 11) {return "Nov";}
   else if(month == 12) {return "Dec";}
   else {return false;}
}

function ConvertMonthMatch(extractmonth){
   if(extractmonth == "Jan") {return "01";}
   if(extractmonth == "Feb") {return "02";}
   if(extractmonth == "Mar") {return "03";}
   if(extractmonth == "Apr") {return "04";}
   if(extractmonth == "May") {return "05";}
   if(extractmonth == "Jun") {return "06";}
   if(extractmonth == "Jul") {return "07";}
   if(extractmonth == "Aug") {return "08";}
   if(extractmonth == "Sep") {return "09";}
   if(extractmonth == "Oct") {return "10";}
   if(extractmonth == "Nov") {return "11";}
   if(extractmonth == "Dec") {return "12";}
}

  </msxsl:script>
</xsl:stylesheet>
