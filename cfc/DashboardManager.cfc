<cfcomponent>

	<cffunction name="createDynamicSelect" access="public" returntype="string">
    	<cfargument name="name" required="yes" type="string">
        <cfargument name="qry" required="yes" type="string">
        <cfargument name="selectedValue" required="no" type="string">        
        <cfargument name="cssValue" required="no" type="string">
        <cfargument name="visible" required="no" type="boolean">  
        <cfargument name="onChange" required="no" type="string">      

        	<cfset style = "">
            
            <cfif visible eq false>
				<cfset style = "display:none">
            </cfif>
        
        
			<cfset startSelect = "<select class='#cssValue#' name='#name#' style='#style#' onchange='#Arguments.onChange#'><option value='0'>Please Select</option>">
            <cfset endSelect = "</select>">
            <cfset wholeSelect = ""> 
            <cfset option = ""> 
            <cfset SELECTED = "">     
        
            <cfquery name="qryName" datasource="#Application.DS#">
                #PreserveSingleQuotes(Arguments.qry)#
            </cfquery>
            <cfloop query="qryName">
            	<cfif selectedValue NEQ "">
					<cfif selectedValue EQ qryName.DataValueField>
                        <cfset SELECTED  = "selected">
                    <cfelse>
                        <cfset SELECTED  = "">
                    </cfif>
                </cfif>
                
            	<cfset option = option & "<option #SELECTED# value='#qryName.DataValueField#'>#qryName.DataTextField#</option>"> 
            </cfloop>
         	
            <cfset wholeSelect = startSelect & option & endSelect>
        
        <cfreturn wholeSelect>
    </cffunction>
    
	<cffunction name="GetActualVsTargetSales" access="public" returntype="query">
		<cfargument name="currentMonthValue" required="yes" type="numeric">

        <cfstoredproc procedure="spSelectActualVsTargetSales" datasource="#Application.DS#">
            <cfprocparam dbvarname="intCurrentMonthValue" cfsqltype="cf_sql_integer" 
               value="#Arguments.currentMonthValue#" type="in">
            <cfprocresult name="rsActualVsTargetSales">
        </cfstoredproc>
        
        <cfreturn rsActualVsTargetSales>
	</cffunction>
    
	<cffunction name="GetCollectionVsReceivables" access="public" returntype="query">
		<cfargument name="year" required="yes" type="numeric">
        
		<cfstoredproc procedure="spSelectCollectionVsReceivables" datasource="#Application.DS#">
        	<cfprocparam dbvarname="intYear" cfsqltype="cf_sql_smallint" value="#Arguments.year#" type="in">
            <cfprocresult name="rsCollectionVsReceivables">
        </cfstoredproc>

		<cfreturn rsCollectionVsReceivables>
	</cffunction>
    
	<cffunction name="GetInventoryAnalysis" access="public" returntype="query">
		<cfargument name="currentMonthValue" required="yes" type="numeric">

        <cfstoredproc procedure="spSelectInventoryAnalysis" datasource="#Application.DS#">
            <cfprocparam dbvarname="intCurrentMonthValue" cfsqltype="cf_sql_integer" 
               value="#Arguments.currentMonthValue#" type="in">
            <cfprocresult name="rsInventoryAnalysis">
        </cfstoredproc>
        
        <cfreturn rsInventoryAnalysis>
	</cffunction>
    
	<cffunction name="GetSalesAnalysisPerCategoryCM" access="public" returntype="query">
		<cfargument name="currentMonthValue" required="yes" type="numeric">

        <cfstoredproc procedure="spSelectSalesAnalysisPerCategoryCM" datasource="#Application.DS#">
            <cfprocparam dbvarname="intCurrentMonthValue" cfsqltype="cf_sql_integer" 
               value="#Arguments.currentMonthValue#" type="in">
            <!--- <cfprocparam dbvarname="" cfsqltype="" variable="" type="out"> --->
            <cfprocresult name="rsSalesAnalysisPerCategoryCM">
        </cfstoredproc>
        
        <cfreturn rsSalesAnalysisPerCategoryCM>
	</cffunction>
    
	<cffunction name="GetSalesAnalysisPerCategoryYTD" access="public" returntype="query">
		<cfargument name="year" required="yes" type="numeric">
        
		<cfstoredproc procedure="spSelectSalesAnalysisPerCategoryYTD" datasource="#Application.DS#">
        	<cfprocparam dbvarname="intYear" cfsqltype="cf_sql_smallint" value="#Arguments.year#" type="in">
            <cfprocresult name="rsSalesAnalysisPerCategoryYTD">
        </cfstoredproc>

		<cfreturn rsSalesAnalysisPerCategoryYTD>
	</cffunction>
    
	<cffunction name="GetSalesAnalysisPerChannelCM" access="public" returntype="query">
		<cfargument name="currentMonthValue" required="yes" type="numeric">

        <cfstoredproc procedure="spSelectSalesAnalysisPerChannelCM" datasource="#Application.DS#">
            <cfprocparam dbvarname="intCurrentMonthValue" cfsqltype="cf_sql_integer" 
               value="#Arguments.currentMonthValue#" type="in">
            <cfprocresult name="rsSalesAnalysisPerChannelCM">
        </cfstoredproc>
        
        <cfreturn rsSalesAnalysisPerChannelCM>
	</cffunction>
    
	<cffunction name="GetSalesAnalysisPerChannelYTD" access="public" returntype="query">
		<cfargument name="year" required="yes" type="numeric">
        
		<cfstoredproc procedure="spSelectSalesAnalysisPerChannelYTD" datasource="#Application.DS#">
        	<cfprocparam dbvarname="intYear" cfsqltype="cf_sql_smallint" value="#Arguments.year#" type="in">
            <cfprocresult name="rsSalesAnalysisPerChannelYTD">
        </cfstoredproc>

		<cfreturn rsSalesAnalysisPerChannelYTD>
	</cffunction>
    
 	<cffunction name="GetSalesZEDChart" access="public" returntype="query">
		<cfargument name="currentMonthValue" required="yes" type="numeric">
        
        <cfstoredproc procedure="spSelectSalesZedChart" datasource="#Application.DS#">
            <cfprocparam dbvarname="intCurrentMonthValue" cfsqltype="cf_sql_integer" 
               value="#Arguments.currentMonthValue#" type="in">
            <cfprocresult name="rsSalesZedChart">
        </cfstoredproc>
        
        <cfreturn rsSalesZedChart>
	</cffunction>   
    
    <!-- ZED CHARTS DATA -->
    <cffunction name="GetSaleZEDByActualCummulativeSales" access="public" returntype="query">
    	<cfargument name="currentMonthValue" required="yes" type="numeric">
        
        <cfscript>
			rsSalesZEDChart = GetSalesZEDChart(Arguments.currentMonthValue);
		</cfscript>
        
        <cfquery name="rsReturn" dbtype="query">
        	SELECT * FROM rsSalesZEDChart
            WHERE Type = 'ActualCummulativeSales'
        </cfquery>
        
        <cfreturn rsReturn>
    </cffunction>
    
    <cffunction name="GetSaleZEDByActualMonthSales" access="public" returntype="query">
    	<cfargument name="currentMonthValue" required="yes" type="numeric">
        
        <cfscript>
			rsSalesZEDChart = GetSalesZEDChart(Arguments.currentMonthValue);
		</cfscript>
        
        <cfquery name="rsReturn" dbtype="query">
        	SELECT * FROM rsSalesZEDChart
            WHERE Type = 'ActualMonthSales'
        </cfquery>
        
        <cfreturn rsReturn>
    </cffunction>
    
    <cffunction name="GetSaleZEDByActualYTDSales" access="public" returntype="query">
    	<cfargument name="currentMonthValue" required="yes" type="numeric">
        
        <cfscript>
			rsSalesZEDChart = GetSalesZEDChart(Arguments.currentMonthValue);
		</cfscript>
        
        <cfquery name="rsReturn" dbtype="query">
        	SELECT * FROM rsSalesZEDChart
            WHERE Type = 'ActualYTDSales'
        </cfquery>
        
        <cfreturn rsReturn>
    </cffunction> 
    
    <cffunction name="GetSaleZEDByTargetCummulativeSales" access="public" returntype="query">
    	<cfargument name="currentMonthValue" required="yes" type="numeric">
        
        <cfscript>
			rsSalesZEDChart = GetSalesZEDChart(Arguments.currentMonthValue);
		</cfscript>
        
        <cfquery name="rsReturn" dbtype="query">
        	SELECT * FROM rsSalesZEDChart
            WHERE Type = 'TargetCummulativeSales'
        </cfquery>
        
        <cfreturn rsReturn>
    </cffunction> 
    
    <cffunction name="GetSaleZEDByTargetMonthSales" access="public" returntype="query">
    	<cfargument name="currentMonthValue" required="yes" type="numeric">
        
        <cfscript>
			rsSalesZEDChart = GetSalesZEDChart(Arguments.currentMonthValue);
		</cfscript>
        
        <cfquery name="rsReturn" dbtype="query">
        	SELECT * FROM rsSalesZEDChart
            WHERE Type = 'TargetMonthSales'
        </cfquery>
        
        <cfreturn rsReturn>
    </cffunction> 
    
    <cffunction name="GetSaleZEDByTargetYTDSales" access="public" returntype="query">
    	<cfargument name="currentMonthValue" required="yes" type="numeric">
        
        <cfscript>
			rsSalesZEDChart = GetSalesZEDChart(Arguments.currentMonthValue);
		</cfscript>
        
        <cfquery name="rsReturn" dbtype="query">
        	SELECT * FROM rsSalesZEDChart
            WHERE Type = 'TargetYTDSales'
        </cfquery>
        
        <cfreturn rsReturn>
    </cffunction> 
    
</cfcomponent>