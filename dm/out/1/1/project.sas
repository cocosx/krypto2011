PROC IMPORT OUT=src
            DATAFILE= "C:\dm\src.csv" 
            DBMS=CSV REPLACE;
	 GETNAMES=YES;
     DATAROW=2; 
RUN;

*ods tagsets.colorlatex file="c:\dm\color.tex" stylesheet="sas.sty"(url="sas");
*ods rtf file="c:\dm\desc1.doc";
*ods pdf file="c:\dm\desc.pdf";


*ods tagsets.colorlatex close;
*ods rtf close;
*ods pdf close;


/* Tot_mthly_debt_exp, DTI_Ratio */

proc sql;
SELECT count(*) FROM WORK.src WHERE Tot_mthly_debt_exp=0;
quit;

proc sql;
SELECT count(*) FROM WORK.src WHERE DTI_Ratio=0;
quit;


proc sql;
SELECT mean(Tot_mthly_debt_exp/Ln_Orig) FROM WORK.src WHERE Tot_mthly_debt_exp ne 0;
quit;

proc sql;
UPDATE WORK.src SET Tot_mthly_debt_exp = 0.016045*Ln_Orig WHERE Tot_mthly_debt_exp = 0;
quit;

proc sql;
UPDATE WORK.src SET DTI_Ratio = Tot_mthly_debt_exp / Tot_mthly_incm;
quit;


/* orig_apprd_val_amt */ 
proc sql;
SELECT count(*) FROM WORK.src WHERE orig_apprd_val_amt=0;
quit;


proc sql;
SELECT mean(orig_apprd_val_amt/pur_prc_amt) FROM WORK.src WHERE orig_apprd_val_amt ne 0;
quit;

proc sql;
UPDATE WORK.src SET orig_apprd_val_amt =  1.059314*pur_prc_amt WHERE orig_apprd_val_amt = 0;
quit;

/* kategorizace */
proc rank data=WORK.src groups=10 out=WORK.cat;
var Bo_Age 
	Ln_Orig
	Orig_LTV_Ratio_Pct
	Credit_score
	Tot_mthly_debt_exp
	Tot_mthly_incm
	orig_apprd_val_amt
	pur_prc_amt
	DTI_ratio
	Median_state_inc;
run;

/*proc sql;
SELECT Bo_Age FROM WORK.src WHERE Credit_score gt 900.0;
quit;*/

/*proc sql;
SELECT Bo_Age FROM WORK.cat;
quit;*/


*ods rtf file="C:\dm\logit.doc";
*ods pdf file="c:\dm\logit.pdf";
proc logistic data=WORK.cat;
  model OUTCOME=
   	First_home 
   	UPB_Appraisal
   	Bo_Age 
	Ln_Orig
	Orig_LTV_Ratio_Pct
	Credit_score
	Tot_mthly_debt_exp
	Tot_mthly_incm
	orig_apprd_val_amt
	pur_prc_amt
	DTI_ratio
	Median_state_inc	
  /selection=stepwise slentry=0.6 slstay=0.1;
  score out=WORK.cat_score;
run;
*ods pdf close;
*ods rtf close;
/*ods 
proc sql;
SELECT * FROM WORK.cat_score;
run;*/

proc export data=WORK.cat_score
   outfile='c:\dm\score.csv'
   dbms=csv
   replace;
run;

/*proc corr data=WORK.cat;
var Bo_Age
	First_home;	
run;*/

/*proc sql;
SELECT mean(Bo_Age) from WORK.src where first_home=1;
quit;

proc sql;
SELECT mean(Bo_Age) from WORK.src where first_home=0;
quit;*/
