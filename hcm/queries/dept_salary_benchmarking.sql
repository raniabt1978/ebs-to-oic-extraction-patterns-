/**
 * Title: Employee Departmental Salary Benchmarking Extraction
 * Author: [Your Name]
 * Role: Principal OIC Specialist & Oracle EBS Technical Consultant
 * * Description: 
 * This query extracts date-effective employee salary data and compares it against 
 * departmental averages using Oracle analytical functions. 
 * * Architecture Note (OIC & AI Readiness):
 * This query is optimized for extraction via Oracle Integration Cloud (OIC) 
 * (e.g., exposed via ORDS, SOAP/REST wrapper, or BI Publisher Data Model). 
 * By pushing the analytical processing (AVG OVER) and transformation (CASE) 
 * down to the database layer, we reduce the payload size and memory overhead in OIC. 
 * The output structure provides clean, pre-calculated feature sets (dept_avg_sal, emp_sal_rank) 
 * ideal for ingestion into Oracle AI or analytics platforms for workforce predictive modeling.
 */

WITH main_query AS (
    SELECT  t1.full_name AS emp_full_name,
            t3.organization_id AS dept_id,
            t3.name AS dept_name,
            t5.proposed_salary_n AS emp_salary,
            -- Isolate the most recent salary proposal for the assignment
            ROW_NUMBER() OVER(PARTITION BY t5.assignment_id ORDER BY t5.change_date DESC) AS last_sal
    FROM per_all_people_f t1
    JOIN per_all_assignments_f t2 
      ON t1.person_id = t2.person_id
    JOIN hr_all_organization_units t3 
      ON t2.organization_id = t3.organization_id
    JOIN per_person_types t4 
      ON t1.person_type_id = t4.person_type_id
    JOIN per_pay_proposals t5 
      ON t5.assignment_id = t2.assignment_id
    -- Ensure only currently active records are processed
    WHERE SYSDATE BETWEEN t1.effective_start_date AND t1.effective_end_date
      AND SYSDATE BETWEEN t2.effective_start_date AND t2.effective_end_date
      AND t4.user_person_type = 'Employee'
)
SELECT emp_full_name,
       dept_name,
       emp_salary,
       -- Calculate department average dynamically without self-joins
       ROUND(AVG(emp_salary) OVER(PARTITION BY dept_id), 0) AS dept_avg_sal,
       -- Categorize for downstream logic/AI feature engineering
       CASE
        WHEN emp_salary > ROUND(AVG(emp_salary) OVER(PARTITION BY dept_id), 0) THEN 'Above Dept Average'
        WHEN emp_salary < ROUND(AVG(emp_salary) OVER(PARTITION BY dept_id), 0) THEN 'Below Dept Average'
        ELSE 'Equal to Dept Average'
       END AS emp_sal_rank
FROM main_query
WHERE last_sal = 1
ORDER BY dept_name,
         emp_salary DESC;