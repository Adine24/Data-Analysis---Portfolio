--Telecom Churn Analysis--

-- View Table Data --
SELECT * FROM [Telecom_Customers_Churn];

------- creating a copy of datasets --------
SELECT * INTO tele_churn FROM [Telecom_Customers_Churn];

----- checking datatypes -----
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'tele_churn';

-- altering column datatypes -- 
ALTER TABLE tele_churn
ALTER COLUMN tenure INT;

------- Exploratory Data Analysis -------

--Customer Count--
CREATE VIEW customer_count AS
SELECT count(*) AS customers
FROM tele_churn;

--Churn Distribution--
WITH churn_count AS (
	SELECT 
	Churn, 
	count(*) AS ch_count,
	AVG(tenure) AS avg_tenure,
	ROUND(AVG(MonthlyCharges),2) AS avg_mth_charge 
	FROM tele_churn
	GROUP BY Churn
)
SELECT 
	Churn, 
	ch_count, 
	ROUND(((ch_count*1.0/customers) * 100),2) AS gender_perct,
	avg_tenure,
	avg_mth_charge
FROM churn_count ch
CROSS JOIN customer_count c;


----Customer Demographics----

--Gender Distribution--
WITH gender_count AS (
	SELECT 
	gender, 
	count(*) AS g_count,
	AVG(tenure) AS avg_tenure,
	ROUND(AVG(MonthlyCharges),2) AS avg_mth_charge,
	ROUND(SUM(TotalCharges),2) AS total_charges
	FROM tele_churn
	GROUP BY gender
)
SELECT 
	gender, 
	g_count, 
	ROUND(((g_count*1.0/customers) * 100),2) AS gender_perct,
	avg_tenure,
	avg_mth_charge,
	total_charges
FROM gender_count g
CROSS JOIN customer_count c;

--Churn by Gender Demographic--
SELECT 
    gender,
    AVG(CASE WHEN Churn = 'Yes' THEN tenure END) AS AvgTenure_churn,
    AVG(CASE WHEN Churn = 'No' THEN tenure END) AS AvgTenure_Active,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN MonthlyCharges END),2) AS AvgCharges_Churn,
    ROUND(AVG(CASE WHEN Churn = 'No' THEN MonthlyCharges END),2) AS AvgCharges_Active
FROM tele_churn
GROUP BY gender;


--Senior Citizen Distribution--
WITH senior_count AS (
	SELECT 
	SeniorCitizen, 
	count(*) AS snr_count,
	AVG(tenure) AS avg_tenure,
	ROUND(AVG(MonthlyCharges),2) AS avg_mth_charge,
	ROUND(SUM(TotalCharges),2) AS total_charges
	FROM tele_churn
	GROUP BY SeniorCitizen
)
SELECT 
	CASE 
        WHEN SeniorCitizen = 1 THEN 'Senior' 
        ELSE 'Young-in'
    END AS display_name,
	snr_count, ROUND(((snr_count*1.0/customers) * 100),2) AS snr_citz_perct,
	avg_tenure,
	avg_mth_charge,
	total_charges
FROM senior_count s
CROSS JOIN customer_count c;


--Churn by snr_citizen Demographic--
SELECT 
    CASE 
        WHEN SeniorCitizen = 1 THEN 'Senior' 
        ELSE 'Young-in'
    END AS display_name,
    AVG(CASE WHEN Churn = 'Yes' THEN tenure END) AS AvgTenure_churn,
    AVG(CASE WHEN Churn = 'No' THEN tenure END) AS AvgTenure_Active,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN MonthlyCharges END),2) AS AvgCharges_Churn,
    ROUND(AVG(CASE WHEN Churn = 'No' THEN MonthlyCharges END),2) AS AvgCharges_Active
FROM tele_churn
GROUP BY SeniorCitizen;


--Partner Distribution--
WITH partner_count AS (
	SELECT 
	Partner, 
	count(*) AS p_count,
	AVG(tenure) AS avg_tenure,
	ROUND(AVG(MonthlyCharges),2) AS avg_mth_charge,
	ROUND(SUM(TotalCharges),2) AS total_charges
	FROM tele_churn
	GROUP BY partner
)
SELECT 
	Partner, 
	p_count, 
	ROUND(((p_count*1.0/customers) * 100),2) AS partner_perct,
	avg_tenure,
	avg_mth_charge,
	total_charges
FROM partner_count p
CROSS JOIN customer_count c;


--Churn by Partner Demographic--
SELECT 
    Partner,
    AVG(CASE WHEN Churn = 'Yes' THEN tenure END) AS AvgTenure_churn,
    AVG(CASE WHEN Churn = 'No' THEN tenure END) AS AvgTenure_Active,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN MonthlyCharges END),2) AS AvgCharges_Churn,
    ROUND(AVG(CASE WHEN Churn = 'No' THEN MonthlyCharges END),2) AS AvgCharges_Active
FROM tele_churn
GROUP BY Partner;


--Dependents Distribution--
WITH dep_count AS (
	SELECT 
	Dependents, 
	count(*) AS dp_count,
	AVG(tenure) AS avg_tenure,
	ROUND(AVG(MonthlyCharges),2) AS avg_mth_charge,
	ROUND(SUM(TotalCharges),2) AS total_charges
	FROM tele_churn
	GROUP BY Dependents
)
SELECT 
	Dependents, 
	dp_count, 
	ROUND(((dp_count*1.0/customers) * 100),2) AS dp_perct,
	avg_tenure,
	avg_mth_charge,
	total_charges
FROM dep_count dp
CROSS JOIN customer_count c;


--Churn by Dependents Demographic--
SELECT 
    Dependents,
    AVG(CASE WHEN Churn = 'Yes' THEN tenure END) AS AvgTenure_churn,
    AVG(CASE WHEN Churn = 'No' THEN tenure END) AS AvgTenure_Active,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN MonthlyCharges END),2) AS AvgCharges_Churn,
    ROUND(AVG(CASE WHEN Churn = 'No' THEN MonthlyCharges END),2) AS AvgCharges_Active
FROM tele_churn
GROUP BY Dependents;

--Tenure details--
SELECT 
	MIN(tenure) AS min_tenure,
	AVG(tenure) AS average_tenure,
	MAX(tenure) AS max_tenure
FROM tele_churn;

--Tenure Distribution--
WITH binned_data AS (
    SELECT 
        CASE 
            WHEN tenure = 0 THEN 'Less than a Month'
            WHEN tenure BETWEEN 1 AND 12 THEN 'One Year (1-12)'
            WHEN tenure BETWEEN 13 AND 24 THEN 'Two Years (13-24)'
			WHEN tenure BETWEEN 25 AND 36 THEN 'Three Years (25-36)'
			WHEN tenure BETWEEN 37 AND 48 THEN 'Four Years (37-48)'
			WHEN tenure BETWEEN 49 AND 60 THEN 'Five Years (49-60)'
            ELSE 'Six Years+ (Over 60)' 
        END AS value_range,
        tenure
    FROM tele_churn
)
SELECT 
    value_range, 
    COUNT(*) AS count
FROM binned_data
GROUP BY value_range
ORDER BY MIN(tenure);

--Churn by Tenure Distribution--
WITH binned_data AS (
    SELECT 
        CASE 
            WHEN tenure = 0 THEN 'Less than a Month'
            WHEN tenure BETWEEN 1 AND 12 THEN 'One Year (1-12)'
            WHEN tenure BETWEEN 13 AND 24 THEN 'Two Years (13-24)'
            WHEN tenure BETWEEN 25 AND 36 THEN 'Three Years (25-36)'
            WHEN tenure BETWEEN 37 AND 48 THEN 'Four Years (37-48)'
            WHEN tenure BETWEEN 49 AND 60 THEN 'Five Years (49-60)'
            ELSE 'Six Years+ (Over 60)' 
        END AS value_range,
        Churn,
        MonthlyCharges,
		TotalCharges
    FROM tele_churn
)
SELECT 
    value_range,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN MonthlyCharges END), 2) AS AvgCharges_Churn,
    ROUND(AVG(CASE WHEN Churn = 'No' THEN MonthlyCharges END), 2) AS AvgCharges_Active,
	ROUND(SUM(TotalCharges),2) AS total_charges
FROM binned_data
GROUP BY value_range;



--PhoneService Distribution--
WITH phoneService_count AS (
	SELECT 
	PhoneService, 
	count(*) AS ps_count,
	AVG(tenure) AS avg_tenure,
	ROUND(AVG(MonthlyCharges),2) AS avg_mth_charge 
	FROM tele_churn
	GROUP BY PhoneService
)
SELECT 
	PhoneService, 
	ps_count, 
	ROUND(((ps_count*1.0/customers) * 100),2) AS phoneService_perct,
	avg_tenure,
	avg_mth_charge
FROM phoneService_count ps
CROSS JOIN customer_count c;


--Churn by PhoneService Demographic--
SELECT 
    PhoneService,
    AVG(CASE WHEN Churn = 'Yes' THEN tenure END) AS AvgTenure_churn,
    AVG(CASE WHEN Churn = 'No' THEN tenure END) AS AvgTenure_Active,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN MonthlyCharges END),2) AS AvgCharges_Churn,
    ROUND(AVG(CASE WHEN Churn = 'No' THEN MonthlyCharges END),2) AS AvgCharges_Active
FROM tele_churn
GROUP BY PhoneService;


--MultipleLines Distribution--
WITH MultipleLines_count AS (
	SELECT 
	MultipleLines, 
	count(*) AS ml_count,
	AVG(tenure) AS avg_tenure,
	ROUND(AVG(MonthlyCharges),2) AS avg_mth_charge 
	FROM tele_churn
	GROUP BY MultipleLines
)
SELECT 
	MultipleLines, 
	ml_count, 
	ROUND(((ml_count*1.0/customers) * 100),2) AS ml_perct,
	avg_tenure,
	avg_mth_charge
FROM MultipleLines_count ps
CROSS JOIN customer_count c;


--Churn by MultipleLines Demographic--
SELECT 
    MultipleLines,
    AVG(CASE WHEN Churn = 'Yes' THEN tenure END) AS AvgTenure_churn,
    AVG(CASE WHEN Churn = 'No' THEN tenure END) AS AvgTenure_Active,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN MonthlyCharges END),2) AS AvgCharges_Churn,
    ROUND(AVG(CASE WHEN Churn = 'No' THEN MonthlyCharges END),2) AS AvgCharges_Active
FROM tele_churn
GROUP BY MultipleLines;


--Internet service Distribution--
WITH intServ_count AS (
	SELECT 
	InternetService, 
	count(*) AS is_count,
	AVG(tenure) AS avg_tenure,
	ROUND(AVG(MonthlyCharges),2) AS avg_mth_charge 
	FROM tele_churn
	GROUP BY InternetService
)
SELECT 
	InternetService, 
	is_count, 
	ROUND(((is_count*1.0/customers) * 100),2) AS is_perct,
	avg_tenure,
	avg_mth_charge
FROM intServ_count ps
CROSS JOIN customer_count c;


--Churn by Internet service Demographic--
SELECT 
    InternetService,
    AVG(CASE WHEN Churn = 'Yes' THEN tenure END) AS AvgTenure_churn,
    AVG(CASE WHEN Churn = 'No' THEN tenure END) AS AvgTenure_Active,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN MonthlyCharges END),2) AS AvgCharges_Churn,
    ROUND(AVG(CASE WHEN Churn = 'No' THEN MonthlyCharges END),2) AS AvgCharges_Active
FROM tele_churn
GROUP BY InternetService;



--OnlineSecurity Distribution--
WITH OnSec_count AS (
	SELECT 
	OnlineSecurity, 
	count(*) AS os_count,
	AVG(tenure) AS avg_tenure,
	ROUND(AVG(MonthlyCharges),2) AS avg_mth_charge 
	FROM tele_churn
	GROUP BY OnlineSecurity
)
SELECT 
	OnlineSecurity, 
	os_count, 
	ROUND(((os_count*1.0/customers) * 100),2) AS is_perct,
	avg_tenure,
	avg_mth_charge
FROM OnSec_count ps
CROSS JOIN customer_count c;


--Churn by OnlineSecurity Demographic--
SELECT 
    OnlineSecurity,
    AVG(CASE WHEN Churn = 'Yes' THEN tenure END) AS AvgTenure_churn,
    AVG(CASE WHEN Churn = 'No' THEN tenure END) AS AvgTenure_Active,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN MonthlyCharges END),2) AS AvgCharges_Churn,
    ROUND(AVG(CASE WHEN Churn = 'No' THEN MonthlyCharges END),2) AS AvgCharges_Active
FROM tele_churn
GROUP BY OnlineSecurity;


--OnlineBackup Distribution--
WITH OnBkp_count AS (
	SELECT 
	OnlineBackup, 
	count(*) AS ob_count,
	AVG(tenure) AS avg_tenure,
	ROUND(AVG(MonthlyCharges),2) AS avg_mth_charge 
	FROM tele_churn
	GROUP BY OnlineBackup
)
SELECT 
	OnlineBackup, 
	ob_count, 
	ROUND(((ob_count*1.0/customers) * 100),2) AS ob_perct,
	avg_tenure,
	avg_mth_charge
FROM OnBkp_count ps
CROSS JOIN customer_count c;


--Churn by OnlineBackup Demographic--
SELECT 
    OnlineBackup,
    AVG(CASE WHEN Churn = 'Yes' THEN tenure END) AS AvgTenure_churn,
    AVG(CASE WHEN Churn = 'No' THEN tenure END) AS AvgTenure_Active,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN MonthlyCharges END),2) AS AvgCharges_Churn,
    ROUND(AVG(CASE WHEN Churn = 'No' THEN MonthlyCharges END),2) AS AvgCharges_Active
FROM tele_churn
GROUP BY OnlineBackup;


--DeviceProtection Distribution--
WITH devp_count AS (
	SELECT 
	DeviceProtection, 
	count(*) AS dp_count,
	AVG(tenure) AS avg_tenure,
	ROUND(AVG(MonthlyCharges),2) AS avg_mth_charge 
	FROM tele_churn
	GROUP BY DeviceProtection
)
SELECT 
	DeviceProtection, 
	dp_count, 
	ROUND(((dp_count*1.0/customers) * 100),2) AS dp_perct,
	avg_tenure,
	avg_mth_charge
FROM devp_count ps
CROSS JOIN customer_count c;


--Churn by DeviceProtection Demographic--
SELECT 
    DeviceProtection,
    AVG(CASE WHEN Churn = 'Yes' THEN tenure END) AS AvgTenure_churn,
    AVG(CASE WHEN Churn = 'No' THEN tenure END) AS AvgTenure_Active,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN MonthlyCharges END),2) AS AvgCharges_Churn,
    ROUND(AVG(CASE WHEN Churn = 'No' THEN MonthlyCharges END),2) AS AvgCharges_Active
FROM tele_churn
GROUP BY DeviceProtection;



--TechSupport Distribution--
WITH TechS_count AS (
	SELECT 
	TechSupport, 
	count(*) AS ts_count,
	AVG(tenure) AS avg_tenure,
	ROUND(AVG(MonthlyCharges),2) AS avg_mth_charge 
	FROM tele_churn
	GROUP BY TechSupport
)
SELECT 
	TechSupport, 
	ts_count, 
	ROUND(((ts_count*1.0/customers) * 100),2) AS ts_perct,
	avg_tenure,
	avg_mth_charge
FROM TechS_count ts
CROSS JOIN customer_count c;


--Churn by TechSupport Demographic--
SELECT 
    TechSupport,
    AVG(CASE WHEN Churn = 'Yes' THEN tenure END) AS AvgTenure_churn,
    AVG(CASE WHEN Churn = 'No' THEN tenure END) AS AvgTenure_Active,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN MonthlyCharges END),2) AS AvgCharges_Churn,
    ROUND(AVG(CASE WHEN Churn = 'No' THEN MonthlyCharges END),2) AS AvgCharges_Active
FROM tele_churn
GROUP BY TechSupport;


--StreamingTV Distribution--
WITH stream_count AS (
	SELECT 
	StreamingTV, 
	count(*) AS st_count,
	AVG(tenure) AS avg_tenure,
	ROUND(AVG(MonthlyCharges),2) AS avg_mth_charge 
	FROM tele_churn
	GROUP BY StreamingTV
)
SELECT 
	StreamingTV, 
	st_count, 
	ROUND(((st_count*1.0/customers) * 100),2) AS st_perct,
	avg_tenure,
	avg_mth_charge
FROM stream_count sc
CROSS JOIN customer_count c;


--Churn by StreamingTV Demographic--
SELECT 
    StreamingTV,
    AVG(CASE WHEN Churn = 'Yes' THEN tenure END) AS AvgTenure_churn,
    AVG(CASE WHEN Churn = 'No' THEN tenure END) AS AvgTenure_Active,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN MonthlyCharges END),2) AS AvgCharges_Churn,
    ROUND(AVG(CASE WHEN Churn = 'No' THEN MonthlyCharges END),2) AS AvgCharges_Active
FROM tele_churn
GROUP BY StreamingTV;


--StreamingMovies Distribution--
WITH streamM_count AS (
	SELECT 
	StreamingMovies, 
	count(*) AS sm_count,
	AVG(tenure) AS avg_tenure,
	ROUND(AVG(MonthlyCharges),2) AS avg_mth_charge 
	FROM tele_churn
	GROUP BY StreamingMovies
)
SELECT 
	StreamingMovies, 
	sm_count, 
	ROUND(((sm_count*1.0/customers) * 100),2) AS sm_perct,
	avg_tenure,
	avg_mth_charge
FROM streamM_count sm
CROSS JOIN customer_count c;


--Churn by StreamingMovies Demographic--
SELECT 
    StreamingMovies,
    AVG(CASE WHEN Churn = 'Yes' THEN tenure END) AS AvgTenure_churn,
    AVG(CASE WHEN Churn = 'No' THEN tenure END) AS AvgTenure_Active,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN MonthlyCharges END),2) AS AvgCharges_Churn,
    ROUND(AVG(CASE WHEN Churn = 'No' THEN MonthlyCharges END),2) AS AvgCharges_Active
FROM tele_churn
GROUP BY StreamingMovies;


--Contract Distribution--
WITH contract_count AS (
	SELECT 
	Contract, 
	count(*) AS ct_count,
	AVG(tenure) AS avg_tenure,
	ROUND(AVG(MonthlyCharges),2) AS avg_mth_charge 
	FROM tele_churn
	GROUP BY Contract
)
SELECT 
	Contract, 
	ct_count, 
	ROUND(((ct_count*1.0/customers) * 100),2) AS ct_perct,
	avg_tenure,
	avg_mth_charge
FROM contract_count ct
CROSS JOIN customer_count c;


--Churn by Contract Demographic--
SELECT 
    Contract,
    AVG(CASE WHEN Churn = 'Yes' THEN tenure END) AS AvgTenure_churn,
    AVG(CASE WHEN Churn = 'No' THEN tenure END) AS AvgTenure_Active,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN MonthlyCharges END),2) AS AvgCharges_Churn,
    ROUND(AVG(CASE WHEN Churn = 'No' THEN MonthlyCharges END),2) AS AvgCharges_Active
FROM tele_churn
GROUP BY Contract;



--PaperlessBilling Distribution--
WITH paper_count AS (
	SELECT 
	PaperlessBilling, 
	count(*) AS pb_count,
	AVG(tenure) AS avg_tenure,
	ROUND(AVG(MonthlyCharges),2) AS avg_mth_charge 
	FROM tele_churn
	GROUP BY PaperlessBilling
)
SELECT 
	PaperlessBilling, 
	pb_count, 
	ROUND(((pb_count*1.0/customers) * 100),2) AS pb_perct,
	avg_tenure,
	avg_mth_charge
FROM paper_count ct
CROSS JOIN customer_count c;


--Churn by PaperlessBilling Demographic--
SELECT 
    PaperlessBilling,
    AVG(CASE WHEN Churn = 'Yes' THEN tenure END) AS AvgTenure_churn,
    AVG(CASE WHEN Churn = 'No' THEN tenure END) AS AvgTenure_Active,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN MonthlyCharges END),2) AS AvgCharges_Churn,
    ROUND(AVG(CASE WHEN Churn = 'No' THEN MonthlyCharges END),2) AS AvgCharges_Active
FROM tele_churn
GROUP BY PaperlessBilling;


--PaymentMethod Distribution--
WITH pay_count AS (
	SELECT 
	PaymentMethod, 
	count(*) AS pm_count,
	AVG(tenure) AS avg_tenure,
	ROUND(AVG(MonthlyCharges),2) AS avg_mth_charge 
	FROM tele_churn
	GROUP BY PaymentMethod
)
SELECT 
	PaymentMethod, 
	pm_count, 
	ROUND(((pm_count*1.0/customers) * 100),2) AS pm_perct,
	avg_tenure,
	avg_mth_charge
FROM pay_count ct
CROSS JOIN customer_count c;


--Churn by PaymentMethod Demographic--
SELECT 
    PaymentMethod,
    AVG(CASE WHEN Churn = 'Yes' THEN tenure END) AS AvgTenure_churn,
    AVG(CASE WHEN Churn = 'No' THEN tenure END) AS AvgTenure_Active,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN MonthlyCharges END),2) AS AvgCharges_Churn,
    ROUND(AVG(CASE WHEN Churn = 'No' THEN MonthlyCharges END),2) AS AvgCharges_Active
FROM tele_churn
GROUP BY PaymentMethod;



-------------Test----------------

SELECT * FROM tele_churn;