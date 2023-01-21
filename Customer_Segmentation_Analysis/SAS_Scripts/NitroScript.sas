*Set Path;
%let path=/folders/myfolders/hanshikagupta/SAS/;

libname user "/folders/myfolders/hanshikagupta/SAS/";

*Load and Store data in workspace;
proc import datafile = '/folders/myfolders/hanshikagupta/SAS/data_c.csv'
out = user.data
dbms = csv
replace;
run;

proc print data= user.data;
run;

proc means data=user.data n nmiss min max range mean median mode var std;
run;

proc cluster data=user.data method=SINGLE;
var SmartPhoneUsagePeriod UsagePeriod NumApps Brand Color CameraQuality BatteryLife OS Price ValueForMoney Recom_Frnd_Fly Trends PromotionsAvailable Call_Text PriceRange PhoneDistraction;
id Id;
run;

proc tree;
run;

proc cluster data=user.data method=ward;
var SmartPhoneUsagePeriod UsagePeriod NumApps Brand Color CameraQuality BatteryLife OS Price ValueForMoney Recom_Frnd_Fly Trends PromotionsAvailable Call_Text PriceRange PhoneDistraction;
id Id;
run;

proc tree ncl=4 out=user.cluster noprint;
id id;
run;

proc freq data=user.cluster;
table cluster;
run;

proc sort data=user.data; by id; run;
proc sort data=user.cluster; by id ; run;

data user.data_2;
merge user.data user.cluster;
by id;
run;

DATA user.data_TRICKED;
SET user.data_2; 
CLUSTER=1;
RUN;

DATA user.data_3; SET user.data_2 user.data_TRICKED;
RUN; 

PROC TTEST DATA=user.data_3;
var SmartPhoneUsagePeriod UsagePeriod NumApps Brand Color CameraQuality BatteryLife OS Price ValueForMoney Recom_Frnd_Fly Trends PromotionsAvailable Call_Text PriceRange PhoneDistraction;
class cluster;
where cluster = 1 or cluster = 3;
run;

proc export data=user.data_2
   outfile='/folders/myfolders/hanshikagupta/SAS/clusteringResults.csv'
   dbms=csv
   replace;
run;

