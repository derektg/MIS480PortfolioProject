/*CREATE ANALYSIS DATASET*/

PROC IMPORT DATAFILE='/folders/myfolders/MIS480/ChipotleAnalysisDatav2.csv'
	OUT=mis480.MIS480_Chipotle_Data
	DBMS=CSV
	REPLACE;
RUN;

/*ORDER TOTAL HISTOGRAM*/

ods graphics / reset width=6.4in height=4.8in imagemap;

PROC SGPLOT DATA=mis480.MIS480_Chipotle_Data;
	TITLE HEIGHT=12pt "Order Total Distribution";
	HISTOGRAM ordertotal / FILLATTRS=(color=CX0e69f1
		TRANSPARENCY=0.5) DATALABEL FILLTYPE=SOLID DATASKIN=matte;
	YAXIS GRID LABEL="Percent of Orders";
	XAXIS LABEL="Order Total ($)";
RUN;

/*LINE ITEM TOTAL HISTOGRAM*/

ods graphics / reset width=6.4in height=4.8in imagemap;

PROC SGPLOT DATA=mis480.MIS480_Chipotle_Data;
	TITLE HEIGHT=12pt "Line Item Total Distribution";
	HISTOGRAM lineitemtotal / FILLATTRS=(color=green
		TRANSPARENCY=0.5) DATALABEL FILLTYPE=SOLID DATASKIN=matte;
	YAXIS GRID LABEL="Percent of Orders";
	XAXIS LABEL="Line Item Total ($)";
RUN;

/*ORDER TOTAL HISTOGRAM (Steak)*/

ods graphics / reset width=6.4in height=4.8in imagemap;

PROC SGPLOT DATA=mis480.MIS480_Chipotle_Data(where=
	(item_name="Steak Burrito" or item_name="Steak Soft Tacos" or item_name="Steak Bowl" or item_name="Steak Crispy Tacos" or item_name="Steak Salad Bowl" or item_name="Steak Salad")
	);
	TITLE HEIGHT=12pt "Order Total Distribution (Steak)";
	HISTOGRAM ordertotal / FILLATTRS=(color=red
		TRANSPARENCY=0.5) DATALABEL FILLTYPE=SOLID DATASKIN=matte;
	YAXIS GRID LABEL="Percent of Orders";
	XAXIS LABEL="Order Total ($)";
RUN;

/*ORDER TOTAL HISTOGRAM (Chicken)*/

ods graphics / reset width=6.4in height=4.8in imagemap;

PROC SGPLOT DATA=mis480.MIS480_Chipotle_Data(where=
	(item_name="Chicken Burrito" or item_name="Chicken Soft Tacos" or item_name="Chicken Bowl" or item_name="Chicken Crispy Tacos" or item_name="Chicken Salad Bowl" or item_name="Chicken Salad")
	);
	TITLE HEIGHT=12pt "Order Total Distribution (Chicken)";
	HISTOGRAM ordertotal / FILLATTRS=(color=yellow
		TRANSPARENCY=0.5) DATALABEL FILLTYPE=SOLID DATASKIN=matte;
	YAXIS GRID LABEL="Percent of Orders";
	XAXIS LABEL="Order Total ($)";
RUN;

/* CHICKEN & STEAK SUMMARY STATISTICS*/

ods noproctitle;
ods graphics / imagemap=on;

PROC MEANS DATA=MIS480.MIS480_CHIPOTLE_DATA(where=
	(item_name="Steak Burrito" or item_name="Steak Soft Tacos" or item_name="Steak Bowl" or item_name="Steak Salad Bowl" or item_name="Chicken Burrito" or item_name="Chicken Soft Tacos" or item_name="Chicken Bowl" or item_name="Chicken Salad Bowl")
	) chartype mean std median n vardef=df qmethod=os;
	var beans rice cheese sourcream guacamole lettuce fajitavegetables 
		lineitemtotal ordertotal;
	class item_name;
run;