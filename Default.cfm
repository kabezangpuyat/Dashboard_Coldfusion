<cfchart format="png" scaleFrom="-1" scaleTo="1" chartWidth="600" chartHeight="300" name="mygraph"> 
		<cfchartseries seriescolor="ff9900" type="horizontalbar" query="myquery1" serieslabel="mylabel" valueColumn="myvalues" itemColumn="mychoices" />   
        <cfchartseries seriescolor="cc0000" type="horizontalbar" query="myquery2" serieslabel="mylabel" valueColumn="myvalues" itemColumn="mychoices" />   
        <cfchartseries seriescolor="99ffcc" type="horizontalbar" query="myquery3" serieslabel="mylabel" valueColumn="myvalues" itemColumn="mychoices" />   
        <cfchartseries seriescolor="009900" type="horizontalbar" query="myquery4" serieslabel="mylabel" valueColumn="myvalues" itemColumn="mychoices" />   
</cfchart> 