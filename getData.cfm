<!---<cfloop from="2005" to="2008" index="y">

	<cfloop index="mon" from="1" to="12">
	<cfset tmpdate = "#y#- #mon# - 01" >
		<cfquery datasource="#Application.DS#">
			INSERT INTO `months` (`Year`, `Month`, `MonthValue`, `EnrollmentDate`)
			select #y#, '#Dateformat(tmpdate,"mmmm")#', #y##numberformat(mon,"00")#  , now()
		</cfquery>
	</cfloop>
</cfloop>--->


<cfparam name="tmpCuurentYear" default="#Year(now())#">
<cfparam name="tmpCuurentMonth" default="#Month(now())#">
<cfparam name="tmpCuurentDay" default="#Month(now())#">

<cfparam name="MaxDate" type="date" default="#now()#">

<cfset tmpMinYear = tmpCuurentYear - 5>

<cfset MinDate = tmpMinYear & "-" & tmpCuurentMonth & "-" & tmpCuurentDay>

<!---ACTUAL SALES--->
<cfquery datasource="#Application.DS#">
	truncate table actualsales
</cfquery>
<cfquery name="x" datasource="#Application.DBEMSSource#">

insert into #Application.DS#.actualsales(monthid, channelid, categoryid, channel, category, amount, enrollmentdate)

select  cast(m.id as char), channelid,categoryid, v.Name,  category, round(sum(netamount),3) netamount, now()
from
(

select
            date_format(si.txndate,'%Y') `year`, date_format(si.txndate,'%M') `month`, c.id customerid, cat.id categoryid, cat.name category,
            sum((((sid.totalamount * (1 - s.discount1 /100)) * (1 - s.discount2/100)) * (1 - s.discount3/100))) netamount,
            ifnull((select v.id from customerdetails cd inner join `field` f on f.id = cd.fieldid and cd.fieldid = 6 left join `value` v on cd.valueid = v.id where cd.customerid = c.id),0) channelid
            from si si
            inner join sidetails sid on sid.siid = si.id and sid.uomid = 5 and si.txnstatusid =2  and si.txndate >= <cfqueryparam cfsqltype="cf_sql_date" value="#MinDate#"> and si.txndate <= <cfqueryparam cfsqltype="cf_sql_date" value="#MaxDate#">
            inner join product p on p.id = sid.productid
            inner join dr dr on dr.id = si.reftxnid
            inner join so s on s.id = dr.reftxnid
            inner join customer c on c.id = si.customerid
            inner join category cat on cat.id = p.categoryid
            group by date_format(si.txndate,'%Y'), date_format(si.txndate,'%M'), c.id, cat.id
union all
        select
            date_format(si.txndate,'%Y') `year`, date_format(si.txndate,'%M') `month`, c.id customerid, cat.id categoryid, cat.name category,
            sum((((sid.totalamount * (1 - s.discount1 /100)) * (1 - s.discount2/100)) * (1 - s.discount3/100))) netamount,
            ifnull((select v.id from customerdetails cd inner join `field` f on f.id = cd.fieldid and cd.fieldid = 6 left join `value` v on cd.valueid = v.id where cd.customerid = c.id),0) channel
        from si si
            inner join sidetails sid on sid.siid = si.id and sid.uomid = 1 and si.txnstatusid= 2 and si.txndate >= <cfqueryparam cfsqltype="cf_sql_date" value="#MinDate#"> and si.txndate <= <cfqueryparam cfsqltype="cf_sql_date" value="#MaxDate#">
            inner join product p on p.id = sid.productid
            inner join dr dr on dr.id = si.reftxnid
            inner join so s on s.id = dr.reftxnid
            inner join customer c on c.id = si.customerid
            inner join category cat on cat.id = p.categoryid
            group by date_format(si.txndate,'%Y'), date_format(si.txndate,'%M'), c.id, cat.id

union all

    select
            date_format(cr.txndate,'%Y') `year`, date_format(cr.txndate,'%M') `month`, c.id customerid, cat.id categoryid, cat.name category,
            - sum(((((crd.qty * crd.unitprice_si) * (1 - s.discount1 /100)) * (1 - s.discount2/100)) * (1 - s.discount3/100))) netamount,
            ifnull((select v.id from customerdetails cd inner join `field` f on f.id = cd.fieldid and cd.fieldid = 6 left join `value` v on cd.valueid = v.id where cd.customerid = c.id),0) channel
            from si
            inner join custret cr on cr.siid = si.id
            inner join custretdetails crd on crd.crid = cr.id and crd.uomid = 5 and si.txnstatusid = 2 and si.txndate >= <cfqueryparam cfsqltype="cf_sql_date" value="#MinDate#"> and  si.txndate <= <cfqueryparam cfsqltype="cf_sql_date" value="#MaxDate#">
            inner join dr d on d.id = si.reftxnid
            inner join so s on s.id = d.reftxnid
            inner join customer c on c.id = si.customerid
            inner join product p on p.id = crd.productid
            inner join category cat on cat.id = p.categoryid
            group by date_format(cr.txndate,'%Y'), date_format(cr.txndate,'%M'), c.id, cat.id
    union all
    select
            date_format(cr.txndate,'%Y') `year`, date_format(cr.txndate,'%M') `month`, c.id customerid, cat.id categoryid, cat.name category,
            - sum(((((crd.qty * crd.unitprice_si) * (1 - s.discount1 /100)) * (1 - s.discount2/100)) * (1 - s.discount3/100))) netamount,
            ifnull((select v.id from customerdetails cd inner join `field` f on f.id = cd.fieldid and cd.fieldid = 6 left join `value` v on cd.valueid = v.id where cd.customerid = c.id),0) channel
            from si
            inner join custret cr on cr.siid = si.id
            inner join custretdetails crd on crd.crid = cr.id and crd.uomid = 1 and si.txnstatusid = 2 and si.txndate >= <cfqueryparam cfsqltype="cf_sql_date" value="#MinDate#"> and  si.txndate <= <cfqueryparam cfsqltype="cf_sql_date" value="#MaxDate#">
            inner join dr d on d.id = si.reftxnid
            inner join so s on s.id = d.reftxnid
            inner join customer c on c.id = si.customerid
            inner join product p on p.id = crd.productid
            inner join category cat on cat.id = p.categoryid
            group by date_format(cr.txndate,'%Y'), date_format(cr.txndate,'%M'), c.id, cat.id

union all

    select distinct
            date_format(cr.txndate,'%Y') `year`, date_format(cr.txndate,'%M') `month`, c.id customerid, cat.id categoryid, cat.name category,
            - (crd.qty * pps.unitprice) netamount,
            ifnull((select v.id from customerdetails cd inner join `field` f on f.id = cd.fieldid and cd.fieldid = 6 left join `value` v on cd.valueid = v.id where cd.customerid = c.id),0) channel
            from custretmisc cr
            inner join custretmiscdetails crd on crd.crid = cr.id and cr.txnstatusid = 2 and crd.uomid = 5 and cr.txndate >= <cfqueryparam cfsqltype="cf_sql_date" value="#MinDate#"> and  cr.txndate <= <cfqueryparam cfsqltype="cf_sql_date" value="#MaxDate#">
            inner join product p on p.id = crd.productid
            inner join customer c on c.id = cr.customerid
            inner join category cat on cat.id = p.categoryid
            inner join productprofileselling pps on pps.productid =crd.productid and pps.uomid = crd.uomid
           group by date_format(cr.txndate,'%Y'), date_format(cr.txndate,'%M'), c.id, cat.id
    union all
    select distinct
            date_format(cr.txndate,'%Y') `year`, date_format(cr.txndate,'%M') `month`, c.id customerid, cat.id categoryid, cat.name category,
            -(crd.qty * pps.unitprice) netamount,
            ifnull((select v.ID from customerdetails cd inner join `field` f on f.id = cd.fieldid and cd.fieldid = 6 left join `value` v on cd.valueid = v.id where cd.customerid = c.id),0) channel
            from custretmisc cr
            inner join custretmiscdetails crd on crd.crid = cr.id and cr.txnstatusid = 2 and crd.uomid = 1 and cr.txndate >= <cfqueryparam cfsqltype="cf_sql_date" value="#MinDate#"> and  cr.txndate <= <cfqueryparam cfsqltype="cf_sql_date" value="#MaxDate#">
            inner join product p on p.id = crd.productid
            inner join customer c on c.id = cr.customerid
            inner join category cat on cat.id = p.categoryid
            inner join productprofileselling pps on pps.productid =crd.productid and pps.uomid = crd.uomid
            group by date_format(cr.txndate,'%Y'), date_format(cr.txndate,'%M'), c.id, cat.id

) x
left join ems_dashboard.months m on m.`year` = x.`year` and m.`month` = x.`month`
inner join `value` v on v.ID = x.ChannelID
group by m.ID, x.`year`, x.`month`, categoryid, channelid
</cfquery>

<!---TARGET SALES--->
<cfquery datasource="#Application.DS#">
	truncate targetsales
</cfquery>

<cfquery name="xd" datasource="#Application.DBSFASource#">
	INSERT INTO #Application.DS#.targetsales(MonthID, Amount, EnrollmentDate) 
	select mo.ID, round(Target,3), now() 
	from (
		select date_format(cyc.StartDate,'%Y') `Year`, date_format(cyc.StartDate,'%M') `Month`, sum(ico.QuantityPerCase * s.UnitPricePerCase) Target
		from sku s
		inner join inventorycontrolobjective ico on s.ID = ico.SKUID
		inner join cycle cyc on cyc.ID = ico.CycleID
		Group by  date_format(cyc.StartDate,'%Y') , date_format(cyc.StartDate,'%M')
		) x 
	inner join #Application.DS#.months mo on mo.`Year` = x.`Year` and mo.`Month` = x.`Month`
	group by mo.ID
</cfquery>

<!---INVENTORY--->
<cfquery datasource="#Application.DS#">
	truncate inventory
</cfquery>

<cfquery datasource="#Application.DBEMSSource#">
INSERT INTO #Application.DS#.inventory(MonthID, CategoryID, Category, SalesQty, InventoryQty, EnrollmentDate) 
select m.id, x.CategoryID, x.Category, sum(Qty)SalesQty, ie.EndBalance, now()
from
(
select
            date_format(si.txndate,'%Y') `year`, date_format(si.txndate,'%M') `month`, cat.id categoryid, cat.name category,
            sum(ppb.Multiplier * sid.Qty) Qty
            from si si
            inner join sidetails sid on sid.siid = si.id and sid.uomid = 5 and si.txnstatusid =2 and si.txndate >= <cfqueryparam cfsqltype="cf_sql_date" value="#MinDate#"> and si.txndate <= <cfqueryparam cfsqltype="cf_sql_date" value="#MaxDate#"> 
            inner join productprofilebuying ppb on ppb.UOMID = sid.UOMID and ppb.ProductID = sid.ProductID
            inner join product p on p.id = sid.productid
            inner join category cat on cat.id = p.categoryid
            group by cat.id,date_format(si.txndate,'%Y'), date_format(si.txndate,'%M')
union all
        select
            date_format(si.txndate,'%Y') `year`, date_format(si.txndate,'%M') `month`, cat.id categoryid, cat.name category,
            sum(ppb.Multiplier * sid.Qty) Qty
        from si si
            inner join sidetails sid on sid.siid = si.id and sid.uomid = 1 and si.txnstatusid= 2 and si.txndate >= <cfqueryparam cfsqltype="cf_sql_date" value="#MinDate#"> and si.txndate <= <cfqueryparam cfsqltype="cf_sql_date" value="#MaxDate#">
            inner join productprofilebuying ppb on ppb.UOMID = sid.UOMID and ppb.ProductID = sid.ProductID
            inner join product p on p.id = sid.productid
            inner join category cat on cat.id = p.categoryid
            group by date_format(si.txndate,'%Y'), date_format(si.txndate,'%M'), cat.id
union all

    select
            date_format(cr.txndate,'%Y') `year`, date_format(cr.txndate,'%M') `month`, cat.id categoryid, cat.name category,
            - sum(crd.Multiplier * crd.Qty) Qty
            from si
            inner join custret cr on cr.siid = si.id
            inner join custretdetails crd on crd.crid = cr.id and crd.uomid = 5 and si.txnstatusid = 2 and si.txndate >= <cfqueryparam cfsqltype="cf_sql_date" value="#MinDate#"> and si.txndate <= <cfqueryparam cfsqltype="cf_sql_date" value="#MaxDate#">
            inner join product p on p.id = crd.productid
            inner join category cat on cat.id = p.categoryid
            group by date_format(cr.txndate,'%Y'), date_format(cr.txndate,'%M'), cat.id
    union all
    select
            date_format(cr.txndate,'%Y') `year`, date_format(cr.txndate,'%M') `month`, cat.id categoryid, cat.name category,
            - sum(crd.Multiplier * crd.Qty) Qty
            from si
            inner join custret cr on cr.siid = si.id
            inner join custretdetails crd on crd.crid = cr.id and crd.uomid = 1 and si.txnstatusid = 2 and si.txndate >= <cfqueryparam cfsqltype="cf_sql_date" value="#MinDate#"> and si.txndate <= <cfqueryparam cfsqltype="cf_sql_date" value="#MaxDate#">
            inner join product p on p.id = crd.productid
            inner join category cat on cat.id = p.categoryid
            group by date_format(cr.txndate,'%Y'), date_format(cr.txndate,'%M'), cat.id
union all

    select distinct
            date_format(cr.txndate,'%Y') `year`, date_format(cr.txndate,'%M') `month`, cat.id categoryid, cat.name category,
            - sum(pps.Multiplier * crd.Qty) Qty
            from custretmisc cr
            inner join custretmiscdetails crd on crd.crid = cr.id and cr.txnstatusid = 2 and crd.uomid = 5 and cr.txndate >= <cfqueryparam cfsqltype="cf_sql_date" value="#MinDate#"> and cr.txndate <= <cfqueryparam cfsqltype="cf_sql_date" value="#MaxDate#">
            inner join product p on p.id = crd.productid
            inner join category cat on cat.id = p.categoryid
            inner join productprofileselling pps on pps.productid =crd.productid and pps.uomid = crd.uomid
           group by date_format(cr.txndate,'%Y'), date_format(cr.txndate,'%M'), cat.id
    union all
    select distinct
            date_format(cr.txndate,'%Y') `year`, date_format(cr.txndate,'%M') `month`, cat.id categoryid, cat.name category,
            - sum(pps.Multiplier * crd.Qty) Qty
            from custretmisc cr
            inner join custretmiscdetails crd on crd.crid = cr.id and cr.txnstatusid = 2 and crd.uomid = 1 and cr.txndate >= <cfqueryparam cfsqltype="cf_sql_date" value="#MinDate#"> and cr.txndate <= <cfqueryparam cfsqltype="cf_sql_date" value="#MaxDate#">
            inner join product p on p.id = crd.productid
            inner join customer c on c.id = cr.customerid
            inner join category cat on cat.id = p.categoryid
            inner join productprofileselling pps on pps.productid =crd.productid and pps.uomid = crd.uomid
            group by date_format(cr.txndate,'%Y'), date_format(cr.txndate,'%M'), cat.id

) x
left join #Application.DS#.months m on m.`year` = x.`year` and m.`month` = x.`month`

inner join (

	select distinct 
        cat.ID CategoryID, cat.Name,
		ifnull(A.BegBal, 0) BeginningBalance,
		ifnull(B.bbQty, 0) BegBal1,
		ifnull(A.BegBal, 0) + ifnull(B.bbQty, 0) BeginBalance,
		(ifnull(A.BegBal, 0) + ifnull(B.bbQty, 0)) + (ifnull(C.RunTot, 0)) EndBalance
	from category cat
	left join (select  
            cat.ID CategoryID, cat.Name CategoryName,
			sum(s.QtyIn) QtyIn,
			sum(s.QtyOut) QtyOut
		from StockLog s 
        inner join product pd on pd.ID = s.ProductID
        inner join category cat on cat.id = pd.categoryID
		and month(s.TxnDate)= <cfqueryparam cfsqltype="cf_sql_integer" value="#tmpCuurentMonth#">  and year(s.TxnDate) = <cfqueryparam cfsqltype="cf_sql_integer" value="#tmpCuurentYear#">
        where pd.Status = 1 
		group by cat.ID) d on d.CategoryID = cat.ID
	left join (select 	
				cat.ID CategoryID, cat.Name CategoryName,
				sum(QtyIn) - sum(QtyOut) BegBal 
			from StockLog s
            inner join product pd on pd.ID = s.ProductID
            inner join category cat on cat.id = pd.categoryID
			and cast(concat(year(TxnDate), '-', month(TxnDate), '-01') as datetime) < '#tmpCuurentYear#-#tmpCuurentMonth#-01'
            where pd.Status = 1 
			group by cat.ID) A on A.CategoryID = cat.ID
	left join (select 	
				cat.ID CategoryID, cat.Name CategoryName,				
				sum(BeginningQty) bbQty 
			from InventoryBeginningBalance bb
            inner join product pd on pd.ID = bb.ProductID
            inner join category cat on cat.id = pd.categoryID
            where pd.Status = 1 
			group by cat.ID) B on B.CategoryID = cat.ID
	left join (select 	
				cat.ID CategoryID, cat.Name CategoryName,
				sum(QtyIn) - sum(QtyOut) RunTot
			from StockLog s
            inner join product pd on pd.ID = s.ProductID
            inner join category cat on cat.id = pd.categoryID
			where 
			month(TxnDate)= <cfqueryparam cfsqltype="cf_sql_integer" value="#tmpCuurentMonth#">  and year(TxnDate)= <cfqueryparam cfsqltype="cf_sql_integer" value="#tmpCuurentYear#"> and pd.Status = 1 
			group by cat.ID) C on C.CategoryID = cat.ID

) ie on ie.CategoryID = x.CategoryID
group by x.`year`, x.`month`, x.categoryid
</cfquery>

<!---COLLECTION--->
<cfquery datasource="#Application.DS#">
	truncate collectionreceivables
</cfquery>

<!---<cfloop from="2005" to="2008" index="y">

	<cfloop index="mon" from="1" to="12">
	<cfset tmpdate = "#y#- #mon# - 01" >
		<cfquery datasource="#Application.DS#">
			INSERT INTO `months` (`Year`, `Month`, `MonthValue`, `EnrollmentDate`)
			select #y#, '#Dateformat(tmpdate,"mmmm")#', #y##numberformat(mon,"00")#  , now()
		</cfquery>
	</cfloop>
</cfloop>--->


<cfparam name="tmpCuurentYear" default="#Year(now())#">
<cfparam name="tmpCuurentMonth" default="#Month(now())#">
<cfparam name="tmpCuurentDay" default="#Month(now())#">

<cfparam name="MaxDate" type="date" default="#now()#">

<cfset tmpMinYear = tmpCuurentYear - 5>

<cfset MinDate = tmpMinYear & "-" & tmpCuurentMonth & "-" & tmpCuurentDay>

<!---ACTUAL SALES--->

<!---COLLECTION--->
<cfquery datasource="#Application.DS#">
	truncate collectionreceivables
</cfquery>

<cfquery name="rsActualSales" datasource="#Application.DS#">
	select m.ID MOnthID, ifnull(sum(a.Amount),0) Amount
	from months m
    left join actualsales a on a.MonthID = m.ID
	group by m.ID
</cfquery>
<cfoutput query="rsActualSales">
<cfquery name="rsCollection" datasource="#Application.DBEMSSource#">
		select m.ID ReceivablesMonthID, x.TotalAmt Payment, m2.ID CollectionMonthID
		from 
		(
			select date_format(si.txndate,'%Y') `SIYear`, date_format(si.txndate,'%M') `SIMonth`,date_format(o.txndate,'%Y') CollectionYear, date_format(o.txndate,'%M') CollectionMonth, sum(o.TotalAmt) TotalAmt
			from `OR` o 
			inner join ordetails od on od.ORID = o.ID 
			inner join SI si on si.ID = od.RefTxnID 
			group by date_format(si.txndate,'%Y'), date_format(si.txndate,'%M'),date_format(o.txndate,'%Y'), date_format(o.txndate,'%M') 
		) x
		inner join #Application.DS#.months m on m.`Year` = x.`SIYear` and m.`Month` = x.SIMonth
		inner join #Application.DS#.months m2 on m2.`Year` = x.`CollectionYear` and m2.`Month` = x.CollectionMonth
		where m.ID = #rsActualSales.MonthID#
		order by SIYear,SIMonth,CollectionYear,CollectionMonth desc
</cfquery>

	<cfset RunningReceivables = rsActualSales.Amount>

	<cfloop query="rsCollection">
		<cfset RunningReceivables = RunningReceivables - Payment>
			<cfif RunningReceivables GT 0>
		<cfquery name="rsCollection" datasource="#Application.DS#">
					INSERT INTO collectionreceivables(ReceivablesMonthID, CollectionMonthID, Amount, EnrollmentDate) 
						select #ReceivablesMonthID#, #CollectionMonthID#, round(#RunningReceivables#, 3), now()
			</cfquery>
		</cfif>
	</cfloop>
	<cfset RunningReceivables = 0>
</cfoutput>

	
</cfquery>
<cfoutput query="rsActualSales">
<cfquery name="rsCollection" datasource="#Application.DBEMSSource#">
		select m.ID ReceivablesMonthID, x.TotalAmt Payment, m2.ID CollectionMonthID
		from 
		(
			select date_format(si.txndate,'%Y') `SIYear`, date_format(si.txndate,'%M') `SIMonth`,date_format(o.txndate,'%Y') CollectionYear, date_format(o.txndate,'%M') CollectionMonth, sum(o.TotalAmt) TotalAmt
			from `OR` o 
			inner join ordetails od on od.ORID = o.ID 
			inner join SI si on si.ID = od.RefTxnID 
			group by date_format(si.txndate,'%Y'), date_format(si.txndate,'%M'),date_format(o.txndate,'%Y'), date_format(o.txndate,'%M') 
		) x
		inner join #Application.DS#.months m on m.`Year` = x.`SIYear` and m.`Month` = x.SIMonth
		inner join #Application.DS#.months m2 on m2.`Year` = x.`CollectionYear` and m2.`Month` = x.CollectionMonth
		where m.ID = #rsActualSales.MonthID#
		order by SIYear,SIMonth,CollectionYear,CollectionMonth desc
</cfquery>

	<cfset RunningReceivables = rsActualSales.Amount>

	<cfloop query="rsCollection">
		<cfset RunningReceivables = RunningReceivables - Payment>
			<cfif RunningReceivables GT 0>
		<cfquery name="rsCollection" datasource="#Application.DS#">
					INSERT INTO collectionreceivables(ReceivablesMonthID, CollectionMonthID, Amount, EnrollmentDate) 
						select #ReceivablesMonthID#, #CollectionMonthID#, round(#RunningReceivables#, 3), now()
			</cfquery>
		</cfif>
	</cfloop>
	<cfset RunningReceivables = 0>
</cfoutput>

	