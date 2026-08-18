--IN THIS WE ARE GOING TO PERFORM THE QUERIES ON INSURANCE DATA 
--SQL SUBQUERIES


/* q) How many patients have claimed more than the average claim amount for patients
  who are smokers and have at least one child, and belong to the southeast region?
*/
USE data;
SELECT * FROM data.insurance_data
WHERE claim > (SELECT AVG(claim) 
               FROM data.insurance_data
               WHERE smoker='No' AND children=1 AND region='southeast');



/*
How many patients have claimed more than the average claim amount for patients who are not smokers and
 have a BMI greater than the average BMI for patients who have at least one child?   
*/
SELECT * FROM data.insurance_data
WHERE claim > (SELECT AVG(claim) FROM insurance_data
			   WHERE smoker='No' 
               AND bmi > (SELECT AVG(bmi) FROM insurance_data
						  WHERE  children >= 1));





/* q) How many patients have claimed more than the average claim amount for patients who have 
  a BMI greater than the average BMI for patients who are diabetic,
   have at least one child, and are from the southwest region?   
*/
SELECT COUNT(*) FROM data.insurance_data
WHERE claim > (SELECT AVG(claim) FROM insurance_data
			   WHERE bmi > (SELECT AVG(bmi) FROM insurance_data
							WHERE  children >= 1 AND diabetic='Yes' 
                            AND region='southeast' )); 




/* What is the difference in the average claim amount between patients who are smokers and 
 patients who are non-smokers, and have the same BMI and number of children?
*/
SELECT AVG(i2.claim-i1.claim) FROM insurance_data i1
JOIN insurance_data i2
ON i2.bmi=i1.bmi AND i2.children=i1.children AND i1.smoker != i2.smoker






