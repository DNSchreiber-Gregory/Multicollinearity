/* Example of Multicollinearity Findings */
libname health "C:\Program Files\SASHome\SASEnterpriseGuide\7.1\Sample\Data";

data health;
	set health.lipid;
run;

proc contents data=health;
	title 'Health Dataset with High Multicollinearity';
run;

/* Exploration of Skewness and Kurtosis */
proc univariate data= health;
	var age weight cholesterol triglycerides hdl ldl height skinfold
		systolicbp diastolicbp exercise coffee cholesterolloss;
	probplot age weight cholesterol triglycerides hdl ldl height skinfold
		systolicbp diastolicbp exercise coffee cholesterolloss / normal (mu=est sigma=est) square;
run;

/* Assess Pairwise Correlations of Continuous Variables */
proc corr data=health;
	var age weight cholesterol triglycerides hdl ldl height skinfold
		systolicbp diastolicbp exercise coffee cholesterolloss;
	title 'Health Predictors - Examination of Correlation Matrix';
run;

proc reg data=health;
	model cholesterolloss = age weight cholesterol triglycerides hdl ldl
		height skinfold systolicbp diastolicbp exercise coffee / vif tol collin;
	title 'Health Predictors - Multicollinearity Investigation of VIF and Tol';
run;

/* Lasso Selection */
proc glmselect data=health plots=all;
	model cholesterolloss = age weight cholesterol triglycerides hdl
		ldl height skinfold systolicbp diastolicbp exercise coffee / selection=lar (choose=cv stop=none) cvmethod=random(10);
	title 'Health - Lasso Regression Calculation';
run;

/* Ridge Regression Example */
proc reg data=health outvif plots(only)=ridge(unpack VIFaxis=log)
	outest=rrhealth ridge=0 to 0.10 by .002;
	model cholesterolloss = age weight cholesterol triglycerides hdl ldl
		height skinfold systolicbp diastolicbp exercise coffee; 
	plot / ridgeplot nomodel nostat;
	title 'Health - Ridge Regression Calculation';
run;

proc print data=rrhealth;
	title 'Health - Ridge Regression Results';
run;

proc reg data=health outvif plots(only)=ridge(unpack VIFaxis=log)
	outest=rrhealth ridge=0 to 0.002 by .00002;
	model cholesterolloss = age weight cholesterol triglycerides hdl ldl
		height skinfold systolicbp diastolicbp exercise coffee;
	plot / ridgeplot nomodel nostat;
	title 'Health - Ridge Regression Calculation';
run;

proc print data=rrhealth;
	title 'Health - Ridge Regression Results';
run;

proc reg data=health outvif plots(only)=ridge(unpack VIFaxis=log)
	outest=rrhealth_final ridge=.0001;
	model cholesterolloss = age weight cholesterol triglycerides hdl ldl
		height skinfold systolicbp diastolicbp exercise coffee;
	plot / ridgeplot nomodel nostat;
	title 'Health - Ridge Regression Calculation';
run;

proc print data=rrhealth_final;
	title 'Health - Ridge Regression Results';
run;

proc reg data=health outvif plots(only)=ridge(unpack VIFaxis=log)
	outest=rrhealth_final outseb ridge=.0001;
	model cholesterolloss = age weight cholesterol triglycerides hdl ldl
		height skinfold systolicbp diastolicbp exercise coffee;
	plot / ridgeplot nomodel nostat;
	title 'Health - Ridge Regression Calculation';
run;

proc print data=rrhealth_final;
	title 'Health - Ridge Regression Results';
run;

/* Elastic Net */
proc glmselect data=health plots=coefficients;
	model cholesterolloss = age weight cholesterol triglycerides hdl ldl height skinfold systolicbp diastolicbp exercise coffee /
	selection=elasticnet (steps=120 choose=cv) cvmethod=split(4);
	title 'Health - Elastic Net Regression Calculation';
run;

