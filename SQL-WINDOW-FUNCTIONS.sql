-- Q1) What are the top 5 patients with the highest insurance claim?

USE data;

SELECT PatientID,
       MAX(claim) OVER(PARTITION BY PatientID) AS 'max_claims'
FROM data.insurance_data
ORDER BY max_claims DESC
LIMIT 5;


-- Q2) What is the average insurance claim for patients based on the number of children they have?

SELECT children, avg_claims, row_num
FROM (
    SELECT *,
           AVG(claim) OVER(PARTITION BY children) AS 'avg_claims',
           ROW_NUMBER() OVER(PARTITION BY children) AS 'row_num'
    FROM insurance_data
) t
WHERE t.row_num = 1;


-- Q3) What are the maximum and minimum insurance claims for each region?

SELECT t.MAX_CLAIM, t.MIN_CLAIM, t.row_num
FROM (
    SELECT MAX(claim) OVER(PARTITION BY region) AS 'MAX_CLAIM',
           MIN(claim) OVER(PARTITION BY region) AS 'MIN_CLAIM',
           ROW_NUMBER() OVER(PARTITION BY region ORDER BY claim DESC) AS 'row_num'
    FROM insurance_data
) t
WHERE t.row_num = 1;


-- Q4) How many patients are there in each age group, and how does this vary by smoking status?

SELECT *,
       SUM(count) OVER(PARTITION BY age)
FROM (
    SELECT smoker,
           age,
           COUNT(*) OVER(PARTITION BY age) AS 'count',
           ROW_NUMBER() OVER(PARTITION BY age) AS 'row_num'
    FROM insurance_data
) t
WHERE row_num = 1
ORDER BY smoker DESC;


-- Q5) What is the difference between each patient's claim and the first claim in the dataset?

SELECT *,
       ROUND(claim - FIRST_VALUE(claim) OVER(), 2)
FROM insurance_data;


-- Q6) What is the absolute difference between each patient's claim and the average claim for their number of children?

SELECT *,
       ABS(claim - AVG(claim) OVER(PARTITION BY children))
FROM insurance_data;


-- Q7) Who has the highest BMI in each region?

SELECT t.grp_rank, t.PatientID, bmi
FROM (
    SELECT *,
           RANK() OVER(PARTITION BY region ORDER BY bmi DESC) AS grp_rank,
           ROW_NUMBER() OVER(PARTITION BY region ORDER BY bmi DESC) AS row_num
    FROM insurance_data
) t
WHERE t.grp_rank = 1;


-- Q8) What is the absolute difference between each patient's claim and the first claim in their region, ordered by BMI?

SELECT *,
       ABS(claim - FIRST_VALUE(claim)
           OVER(PARTITION BY region ORDER BY bmi DESC))
FROM insurance_data;


-- Q9) What is the difference between each patient's claim and the maximum claim for their region and smoking status?

SELECT *,
       MAX(claim) OVER(PARTITION BY region, smoker) - claim
FROM insurance_data;


-- Q10) What is the maximum BMI among the next three older age records?

SELECT *,
       MAX(bmi) OVER(
           ORDER BY age DESC
           ROWS BETWEEN 1 FOLLOWING AND 3 FOLLOWING
       ) AS max_bmi_of3
FROM insurance_data;


-- Q11) What is the average insurance claim of the previous two records?

SELECT *,
       AVG(claim) OVER(
           ROWS BETWEEN 2 PRECEDING AND 1 PRECEDING
       ) AS last_of2_avg
FROM insurance_data;


-- Q12) What was the first insurance claim for each region and gender among patients
-- with a BMI between 25 and 30 who are not diabetic?

SELECT t.first_claim, t.row_num
FROM (
    SELECT FIRST_VALUE(claim)
           OVER(PARTITION BY region, gender ORDER BY age ASC) AS 'first_claim',
           ROW_NUMBER()
           OVER(PARTITION BY region, gender) AS 'row_num'
    FROM insurance_data
    WHERE bmi BETWEEN 25 AND 30
      AND diabetic = 'No'
) t
WHERE t.row_num = 1;


-- Q13) What percentage of patients are smokers for each age group?
SELECT *,COUNT(CASE WHEN smoker ='Yes' THEN 1 END) OVER(PARTITION BY age)/COUNT(smoker) OVER(PARTITION BY age) 
FROM data.insurance_data;


-- Q14) What is the difference between each patient's claim and the first claim in the dataset?
SELECT *,claim-FIRST_VALUE(claim) OVER()
FROM data.insurance_data;


-- Q15) How does each patient's claim compare with the average claim of patients having the same number of children?
SELECT *,AVG(claim) OVER(PARTITION BY children)-claim
FROM data.insurance_data;


-- Q16) What is the maximum BMI and dense rank of patients within each region?
SELECT *,MAX(bmi) OVER(PARTITION BY region),
DENSE_RANK() OVER(PARTITION BY region)
FROM data.insurance_data;


-- Q17) What is the difference between the claim of each patient and the claim associated with the maximum BMI in their region?
SELECT t1.claim-t2.claim FROM data.insurance_data t1
JOIN (SELECT PatientID,age,claim,MAX(bmi) OVER(PARTITION BY region) FROM data.insurance_data) t2
ON t1.PatientI-t2.PatientID;


-- Q18) What is the difference between each patient's claim and the first claim in their region when ordered by BMI in descending order?
SELECT *,claim-FIRST_VALUE(claim) OVER(PARTITION BY region ORDER BY bmi DESC ) AS 'analysed_claim' 
FROM data.insurance_data;


-- Q19) What is the difference between the highest claim and each patient's claim for each region, BMI, and smoking status?
SELECT FIRST_VALUE(claim) OVER(PARTITION BY region,bmi,smoker ORDER BY claim DESC)-claim AS 'analysed_claim'
FROM data.insurance_data
ORDER BY 'analysed_claim' DESC;


-- Q20) What is the maximum claim among the current patient and the next two patients?
SELECT *, MAX(claim) OVER(ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING ) FROM data.insurance_data;


-- Q21) What is the average claim for the current patient and the previous two patients?
SELECT *, AVG(claim) OVER(ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) FROM data.insurance_data;


-- Q22) What is the first claim for each region and gender among patients with a BMI between 25 and 30 who are not diabetic?
SELECT *,FIRST_VALUE(claim) OVER(PARTITION BY region,gender) FROM data.insurance_data
WHERE bmi BETWEEN 25 AND 30 AND diabetic='No'
ORDER BY age;
