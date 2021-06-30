<cfapplication  name="SAFI_DASHBOARD"
			    applicationtimeout="10"
                sessiontimeout="20"
                clientmanagement="yes">



        <cflock scope="application" type="exclusive" timeout="10">
                <!--- Do initializations --->
                <cfset Application.ReadOnlyData.Company = "safi_dashboard">
                <cfset Application.initialized_safi = "yes">
				<cfset Application.DS = "ems_dashboard">
                <cfset Application.DBEMSSource = "ems_safi_dev">
                <cfset Application.DBSFASource = "sfa_dev">
        </cflock>                