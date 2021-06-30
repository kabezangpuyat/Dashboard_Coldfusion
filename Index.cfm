<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Dashboard</title>
</head>
<body>
<script>
	function SubmitSelect()
	{
		document.frmDashboards.action = "Index.cfm";
		document.frmDashboards.submit();
	}
</script>
<form name="frmDashboards" method="post" action="Index.cfm">
<cfparam name="form.ddlYearMonth" default="0">
<cfparam name="form.ddlYear" default="0">

<cfscript>
	dashboard = CreateObject("Component","saficfc.DashboardManager");

	//START set up default month and Year
	monthPart = DatePart('m',NOW());
	if(monthPart<10)
	{
		monthPart = "0" & monthPart;	
	}
	defaultYearMonth = DatePart('yyyy',NOW()) & monthPart;
	defaultYear = DatePart('yyyy',NOW());
	
	if(form.ddlYearMonth NEQ 0)
	{
		defaultYearMonth = 	form.ddlYearMonth;
	}
	if(form.ddlYear NEQ 0)
	{
		defaultYear = 	form.ddlYear;
	}
	//END set up default month and Year
		
	//1. zed chart

		//zedChartData = dashboard.GetSalesZEDChart(200902);		
		saleZEDByActualCummulativeSales = dashboard.GetSaleZEDByActualCummulativeSales(defaultYearMonth);
		saleZEDByActualMonthSales = dashboard.GetSaleZEDByActualMonthSales(defaultYearMonth);
		saleZEDByActualYTDSales = dashboard.GetSaleZEDByActualYTDSales(defaultYearMonth);
		saleZEDByTargetCummulativeSales = dashboard.GetSaleZEDByTargetCummulativeSales(defaultYearMonth);
		saleZEDByTargetMonthSales = dashboard.GetSaleZEDByTargetMonthSales(defaultYearMonth);
		saleZEDByTargetYTDSales = dashboard.GetSaleZEDByTargetYTDSales(defaultYearMonth);
		
	//2. Sales Analysis Per Product Group
		//CM
		salesAnalysisPerCM = dashboard.GetSalesAnalysisPerCategoryCM(defaultYearMonth);
		//YTD
		salesAnalysisPerYTD = dashboard.GetSalesAnalysisPerCategoryYTD(defaultYear);
		
	//3. Sales Analysis Per Channel
		//CM
		salesAnalysisPerChannelCM = dashboard.GetSalesAnalysisPerChannelCM(defaultYearMonth);
		//YTD
		salesAnalysisPerChannelYTD = dashboard.GetSalesAnalysisPerChannelYTD(defaultYear);
		
	//4. collection vs receivables
		collectionVsReceivables = dashboard.GetCollectionVsReceivables(defaultYear);
	
	//5. Volume Objective Per Visit Actual VS. Plan
		actualVsPlan = dashboard.GetActualVsTargetSales(defaultYearMonth);
		
	//6. invetory analysis
		inventoryAnalysis = dashboard.GetInventoryAnalysis(defaultYearMonth);
	
</cfscript>
<table width="100%" cellpadding="0" cellspacing="0" border="1">
    <tr>
    	<td colspan="2" align="center">
        	<strong>Management Dashboard</strong>
        </td>
    </tr>
    <tr>
    	<td colspan="2">
        	<table width="100%" cellpadding="0" cellspacing="0" border="0">
            	<tr>
                	<td width="6%">Month Year:&nbsp;</td>
                    <td width="94%">
						<cfscript>
                            qryYearMonth = "SELECT MonthValue DataValueField, CONCAT(Left(Month,3),'&nbsp;&nbsp;',Year) DataTextField FROM months ORDER BY monthValue DESC";
                            ddlSelectedValue = "";
                            if(IsDefined('form.ddlYearMonth'))
                            {
                                ddlSelectedValue = form.ddlYearMonth;	
                            }
                            ddlYearMonth = dashboard.CreateDynamicSelect('ddlYearMonth',
                                                                      qryYearMonth,
                                                                      ddlSelectedValue,
                                                                      '',
                                                                      true,
                                                                      'SubmitSelect();');
                            WriteOutput(ddlYearMonth);
                        </cfscript>
                    </td>
                </tr>
            	<tr>
                	<td>Year:&nbsp;</td>
                    <td>
						<cfscript>
                            qryYear = "SELECT DISTINCT(Year) DataValueField, Year DataTextField FROM months ORDER BY Year DESC";
                            ddlSelectedValueYear = "";
                            if(IsDefined('form.ddlYear'))
                            {
                                ddlSelectedValueYear = form.ddlYear;	
                            }
                            ddlYear = dashboard.CreateDynamicSelect('ddlYear',
                                                                      qryYear,
                                                                      ddlSelectedValueYear,
                                                                      '',
                                                                      true,
                                                                      'SubmitSelect();');
                            WriteOutput(ddlYear);
                        </cfscript>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
        <td width="50%">
            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td width="100%">
                        <table  width="100%" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td colspan="2" align="left"><strong><i>SALES</i></strong></td>
                            </tr>
                            <tr>
                            	<td colspan="2">
                                	<table width="100%" cellpadding="0" cellspacing="0" border="0">
                                    	<tr>
                                        	<td>&nbsp;</td>
                                        </tr>
                                	</table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center">
                                   <cfchart showborder="no"
                                    chartheight="500" chartwidth="500"
                                    yaxistitle="Amount" xaxistitle="Month" 
                                    showlegend="yes" show3d="no">
                                     
                                        <cfif saleZEDByActualCummulativeSales.RecordCount GT 0>
                                            <!-- Actual Cummulative Sales -->
                                            <cfchartseries type="line" itemcolumn="Actual Cummulative Sales" seriescolor="##009999">
                                                <cfloop query="saleZEDByActualCummulativeSales">
                                                    <!-- if column is not null print line -->
                                                    <cfset REQUEST.NullAmount = saleZEDByActualCummulativeSales.GetString( "Amount" )>
                                                    <cfif YesNoFormat(StructKeyExists( REQUEST, "NullAmount" ))>
                                                        <cfchartdata item="#Month#" value="#Amount#">
                                                    </cfif>
                                                </cfloop>  
                                            </cfchartseries>
                                         </cfif>
                                    	
                                         <cfif saleZEDByActualMonthSales.RecordCount GT 0>
                                            <!-- Actual Month Sales -->
                                            <cfchartseries type="line" itemcolumn="Actual Month Sales" seriescolor="##006600" >
                                                <cfloop query="saleZEDByActualMonthSales">
                                                    <!-- if column is not null print line -->
                                                    <cfset REQUEST.NullAmount = saleZEDByActualMonthSales.GetString( "Amount" )>
                                                    <cfif YesNoFormat(StructKeyExists( REQUEST, "NullAmount" ))>
                                                        <cfchartdata item="#Month#" value="#Amount#">
                                                    </cfif>
                                                </cfloop>  
                                            </cfchartseries>
                                         </cfif>
                                         
                                         <cfif saleZEDByActualYTDSales.RecordCount GT 0>
                                            <!-- Actual YTD Sales -->
                                            <cfchartseries type="line" itemcolumn="Actual YTD Sales" seriescolor="##00CC33" >
                                                <cfloop query="saleZEDByActualYTDSales">
                                                    <!-- if column is not null print line -->
                                                    <cfset REQUEST.NullAmount = saleZEDByActualYTDSales.GetString( "Amount" )>
                                                    <cfif YesNoFormat(StructKeyExists( REQUEST, "NullAmount" ))>
                                                        <cfchartdata item="#Month#" value="#Amount#">
                                                    </cfif>
                                                </cfloop>  
                                            </cfchartseries>
                                        </cfif>
                                        
                                        <cfif saleZEDByTargetCummulativeSales.RecordCount GT 0>
                                            <!-- Target Cummulative Sales -->
                                            <cfchartseries type="line" itemcolumn="Target Cummulative Sales" seriescolor="##330033" >
                                                <cfloop query="saleZEDByTargetCummulativeSales">
                                                    <!-- if column is not null print line -->
                                                    <cfset REQUEST.NullAmount = saleZEDByTargetCummulativeSales.GetString( "Amount" )>
                                                    <cfif YesNoFormat(StructKeyExists( REQUEST, "NullAmount" ))>
                                                        <cfchartdata item="#Month#" value="#Amount#">
                                                    </cfif>
                                                </cfloop>  
                                            </cfchartseries>
                                        </cfif>
                                        
                                        <cfif saleZEDByTargetMonthSales.RecordCount GT 0>
                                            <!-- Target Month Sales -->
                                            <cfchartseries type="line" itemcolumn="Target Month Sales" seriescolor="##FF3366" >
                                                <cfloop query="saleZEDByTargetMonthSales">
                                                    <!-- if column is not null print line -->
                                                    <cfset REQUEST.NullAmount = saleZEDByTargetMonthSales.GetString( "Amount" )>
                                                    <cfif YesNoFormat(StructKeyExists( REQUEST, "NullAmount" ))>
                                                        <cfchartdata item="#Month#" value="#Amount#">
                                                    </cfif>
                                                </cfloop>  
                                            </cfchartseries>
                                        </cfif>
                                        
                                        <cfif saleZEDByTargetYTDSales.RecordCount GT 0>
                                            <!-- Target YTD Sales -->
                                            <cfchartseries type="line" itemcolumn="Target YTD Sales" seriescolor="##FF0000" >
                                                <cfloop query="saleZEDByTargetYTDSales">
                                                    <!-- if column is not null print line -->
                                                    <cfset REQUEST.NullAmount = saleZEDByTargetYTDSales.GetString( "Amount" )>
                                                    <cfif YesNoFormat(StructKeyExists( REQUEST, "NullAmount" ))>
                                                        <cfchartdata item="#Month#" value="#Amount#">
                                                    </cfif>
                                                </cfloop>  
                                            </cfchartseries>
                                         </cfif>
                                    </cfchart> 
                                </td>
                            </tr>
                            <tr>
                            	<td colspan="2">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="100%">
                        <table  width="100%" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td colspan="2" align="left"><strong><i>SALES ANALYSIS PER PRODUCT GROUP</i></strong></td>
                            </tr>
                            <tr>
                            	<td colspan="2">&nbsp;</td>
                            </tr>
                            <tr>
                                <td width="50%">
                                    <cfif salesAnalysisPerCM.RecordCount GT 0>
                                        <cfchart format="flash" show3d="true" chartwidth="300" chartheight="300" pieslicestyle="solid"  
                                             showborder="no" title="Current Month" showlegend="yes" >
                                          <cfchartseries type="pie" query="salesAnalysisPerCM" valueColumn="Amount" itemColumn="Category" />
                                        </cfchart>     
                                    <cfelseif salesAnalysisPerCM.RecordCount EQ 0>
                                    	 Record(s) not found for Sales Analysis Per Category CM.
                                    </cfif>
                                </td>
                                <td width="50%">
									<cfif salesAnalysisPerYTD.RecordCount GT 0>  
                                        <cfchart format="flash" show3d="true" chartwidth="500" chartheight="500" pieslicestyle="sliced"  
                                             showborder="no" title="Year-to-Date" showlegend="yes" >
                                          <cfchartseries type="pie" query="salesAnalysisPerYTD" valueColumn="Amount" itemColumn="Category" />
                                        </cfchart>                                           
                                           
                                    <cfelseif salesAnalysisPerYTD.RecordCount EQ 0>
                                    	Record(s) not found for Sales Analysis Per Category YTD.
                                    </cfif>
                                </td>
                            </tr>
                            <tr>
                            	<td colspan="2">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="100%">
                        <table  width="100%" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td colspan="2" align="left"><strong><i>SALES ANALYSIS PER CHANNEL</i></strong></td>
                            </tr>
                            <tr>
                            	<td colspan="2">&nbsp;</td>
                            </tr>
                            <tr>
                                <td width="50%">
                                <cfif salesAnalysisPerChannelCM.RecordCount GT 0>
                                    <cfchart format="flash" show3d="true" chartwidth="300" chartheight="300" pieslicestyle="solid"  
                                         showborder="no" title="Current Month" showlegend="yes" >
                                       
                                        <cfchartseries type="pie" query="salesAnalysisPerChannelCM" valueColumn="Amount" itemColumn="Channel" />
                                    </cfchart>
                                <cfelseif salesAnalysisPerChannelCM.RecordCount EQ 0>
                                	Record(s) not found for Sales Analysis Per Channel CM.
                                </cfif>
                                </td>
                                <td width="50%">
                                <cfif salesAnalysisPerChannelYTD.RecordCount GT 0>
                                    <cfchart format="flash" show3d="true" chartwidth="300" chartheight="300" pieslicestyle="solid"  
                                         showborder="no" title="Year-to-Date" showlegend="yes" >
                                         
                                        <cfchartseries type="pie" query="salesAnalysisPerChannelYTD" valueColumn="Amount" itemColumn="Channel" />                                     
                                    </cfchart>
                                <cfelseif salesAnalysisPerChannelYTD.RecordCount EQ 0>
                                	Record(s) not found for Sales Analysis Per Channel YTD.
                                </cfif>
                                </td>
                            </tr>
                            <tr>
                            	<td colspan="2">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
        
        
        <td width="50%">
            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td width="100%">
                        <table  width="100%" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td colspan="2" align="left" ><strong><i>COLLECTIONS VS. RECEIVABLES</i></strong></td>
                            </tr>
                            <tr>
                            	<td colspan="2">&nbsp;</td>
                            </tr>
                            <tr>
                                <td colspan="2">
									<table width="100%" cellpadding="0" cellspacing="0" border="1">
                                    <cfoutput>
                                    	<cfloop from="12" to="0" step="-1" index="row">
                                        	<tr>
                                                <cfloop from="0" to="12"  index="col">
                                                    <cfscript>
														rowMonthValue = "&nbsp;";
														colMonthValue = "&nbsp;";
														printMonth = "&nbsp;";
														
														//row color
														bgcolor = "";
														
														//RECEIVABLES
														//GET ROW MONTH VALUE
														if(row>0 AND col==0)
														{
															rowMonthValue = Left(MonthAsString(row),3);
															printMonth = "<strong>" & rowMonthValue & "</strong>";
															bgcolor = "##CCCCCC";
														}		
														
														//COLLECTIONS
														//GET COL MONTH VALUE
														else if(row==0 AND col>0)
														{
															colMonthValue = Left(MonthAsString(col),3);
															printMonth = "<strong>" & colMonthValue & "</strong>";
															bgcolor = "##666666";
														}
														else if(row==0 AND col==0)
														{
															printMonth = "&nbsp;";
															bgcolor = "black";
														}
													</cfscript>
                                                   <cfloop query="collectionVsReceivables">
														<cfset REQUEST.NullCollectionAmount = collectionVsReceivables.GetString( "Amount" )>
                                                        <cfif YesNoFormat(StructKeyExists( REQUEST, "NullCollectionAmount" ))>
                                                        	<cfset dbRow = DatePart('m',ReceivablesMonth & " 21,2008")>
                                                            <cfset dbCol = DatePart('m',CollectionMonth & " 21,2008")>
                                                            
                                                            <cfif row EQ dbRow AND col EQ dbCol>
                                                            	<cfset printMonth = Amount>
                                                            </cfif>
                                                        </cfif>
                                                   </cfloop>  
                                                    <td bgcolor="#bgcolor#">
                                                   #printMonth# 
                                              
                                                    </td>
                                                </cfloop>
                                            </tr>
                                        </cfloop>
                                    </cfoutput>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                            	<td colspan="2">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="100%">
                        <table  width="100%" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td colspan="2" align="left"><strong><i>ACTUAL VS. TARGET SALES</i></strong></td>
                            </tr>
                            <tr>
                            	<td colspan="2">&nbsp;</td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center">
                                    <cfchart format="flash"
                                       xaxistitle="Month"
                                       yaxistitle="Amount" show3d="yes" chartwidth="500" chartheight="500" showlegend="yes" >
                                    
                                        <!-- Actual -->

                                        <cfchartseries type="bar" seriescolor="##0099FF" itemcolumn="Actual Sales" >                        
                                            <cfloop query="actualVsPlan">
												<!--- <cfset REQUEST.NullActualSales = actualVsPlan.GetString( "ActualSales" )>
                                                <cfif YesNoFormat(StructKeyExists( REQUEST, "NullActualSales" ))>    --->  
                                                	<cfchartdata item="#month#" value="#ActualSales#">  
                                               <!---  </cfif>   --->                                      
                                            </cfloop>  
                                        </cfchartseries>                                            
                                                                                
                                        <!-- Target -->

                                        <cfchartseries type="bar" seriescolor="##CC3333" itemcolumn="Target Sales">
                                            <cfloop query="actualVsPlan">
											<!--- 	<cfset REQUEST.NullTargetSales = actualVsPlan.GetString( "TargetSales" )>
                                                <cfif YesNoFormat(StructKeyExists( REQUEST, "NullTargetSales" ))> --->
                                                	<cfchartdata item="#month#" value="#TargetSales#">
                                                <!--- </cfif> --->
                                            </cfloop>
                                        </cfchartseries>
                                                                                
                                        <!-- Historical -->

                                        <cfchartseries type="bar" seriescolor="##FF9900" itemcolumn="Historical Sales">
                                            <cfloop query="actualVsPlan">
											<!--- 	<cfset REQUEST.NullHistoricalSales = actualVsPlan.GetString( "HistoricalSales" )>
                                                <cfif YesNoFormat(StructKeyExists( REQUEST, "NullHistoricalSales" ))> --->
                                                	<cfchartdata item="#month#" value="#HistoricalSales#">
                                          <!---       </cfif> --->
                                            </cfloop>
                                        </cfchartseries> 
                                        
                                    </cfchart>
                                </td>
                            </tr>
                            <tr>
                            	<td colspan="2">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="100%">
                        <table  width="100%" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td colspan="2" align="left"><strong><i>INVETORY ANALYSIS</i></strong></td>
                            </tr>
                            <tr>
                            	<td colspan="2">&nbsp;</td>
                            </tr>
                            <tr>
                                <td width="50%" valign="top">
                                	<table width="100%" cellpadding="0" cellspacing="0" border="0">
                                    	<tr>
                                        	<td>
                                            	<table cellpadding="0" cellspacing="0" border="1" width="100%" bordercolor="#000000">
                                                	<tr>
                                                    	<td width="50%" align="center"><strong>PRODUCT</strong></td>
                                                        <td width="50%">
                                                        	<table width="100%" cellpadding="0" cellspacing="0" border="1">
                                                            	<tr>
                                                                	<td height="24" colspan="2" align="center"><strong>TURNOVER</strong></td>
                                                                </tr>
                                                                <tr>
                                                                	<td width="50%" height="24" align="center">SALES</td>
                                                                    <td width="50%" align="center">INV</td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>                                                    
                                                </table> 
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td>
                                            	<table width="100%" cellpadding="0" cellspacing="0" border="1">
                                                    <cfoutput query="inventoryAnalysis">
                                                	<tr>
                                                    	<td height="25" align="center" nowrap="nowrap">#Category#</td>
                                                    <td align="center">#SalesQty#</td>
                                                        <td align="center">#InventoryQty#</td>
                                                    </tr>
                                                	<tr>
                                                	  <td height="5" colspan="3" align="center"></td>
                                                	  </tr>
                                                    </cfoutput>
                                                    
                                                </table>
                                            </td> 
                                        </tr>
                                    </table>
                                </td>
                                <td width="50%" valign="top">
                                	<table width="100%" cellpadding="0" cellspacing="0" border="0">
                                    	<tr>
                                        	<td height="23" valign="top">&nbsp;
                                           	
                                            </td>
                                        </tr>
                                    	<tr>
                                        	<td height="20" valign="top">&nbsp;
                                           	
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td>
                                                <cfchart format="flash"                                       
                                                   yaxistitle="Average" show3d="no" chartwidth="500" chartheight="500" showlegend="no" >
                                               
            
                                                    <cfchartseries type="horizontalbar" seriescolor="##0099FF" itemcolumn="Actual Sales" >                        
                                                        <cfloop query="inventoryAnalysis">
                                                            <cfset REQUEST.NullAve = inventoryAnalysis.GetString( "Average" )>
                                                            <cfif YesNoFormat(StructKeyExists( REQUEST, "NullAve" ))>    
                                                                <cfchartdata  value="#Average#">  
                                                            </cfif>                                         
                                                        </cfloop>  
                                                    </cfchartseries>  
                                                 </cfchart>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                            	<td colspan="2">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>