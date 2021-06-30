<cfcomponent
output="false"
hint="I provide application settings and event handlers.">
<!--- Define application settings. --->
<cfset THIS.Name = "SubSessionTesting" />
<cfset THIS.ApplicationTimeout = CreateTimeSpan( 0, 1, 0, 0 ) />
<cfset THIS.SessionManagement = true />
<cfset THIS.SessionTimeout = CreateTimeSpan( 0, 5, 30, 0) />
<cfset THIS.SetClientCookies = true /> 
<cfset THIS.ClientStorage = "registry"/> 
<cfdump var="#Applica#"
<cffunction name="onApplicationStart">
   
	<!--- Set the Application variables if they aren't defined. --->
    <!--- Initialize local app_is_initialized flag to false. --->
    <cfset app_is_initialized = False>
    <!--- Get a read-only lock. --->
        <cflock scope="application" type="exclusive" timeout=10>
                <!--- Do initializations --->
                <cfset Application.ReadOnlyData.Company = "safi_dashboard">
                <cfset Application.initialized_safi = "yes">
                <cfset Application.DS = "safi_dashboard">
    
        </cflock>
    
   <cfreturn True>
</cffunction>

<cffunction name="OnSessionStart" access="public" returntype="void" output="false" hint="I fire when a session starts.">
     
    <cfcookie name="CFID" value="#SESSION.CFID#" />
    <cfcookie name="CFTOKEN" value="#SESSION.CFTOKEN#" />
     
    <!--- Store date the session was created. --->
    <cfset SESSION.DateInitialized = Now() />
     
    <!--- Return out. --->
    <cfreturn />
</cffunction>

<cffunction name="OnSessionEnd" access="public" returntype="void" output="false" hint="I fire when a session starts.">
	<cfargument name="sessionScope" type="struct" required="true">  
	<cfargument name="appScope" type="struct" required="false">       
<!---
    <cfset test="delete from 'session' WHERE AccountID = #Arguments.SessionScope.GBBUserID#	"/>
    <cflog text="OnSessionEnd log : #test#" log="Application" type="Error">
--->
    <!--- Return out. --->
   
    
    <cfset StructClear(SESSION)>

</cffunction>

 
</cfcomponent>