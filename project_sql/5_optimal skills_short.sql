/* What are the most optimal skills? Optimal means high-demand and high-paying.
•	Deliverable: top 5 optimal skills for data analysts.
•	Concentrate on remote positions with specified salaries.
•	This will be a combination of queries 3 and 4, which we will introduce as CTEs.
•	Adjustments: We will use the primary key to combine them (skill_id) and use it in the GROUP BY. 
•	Remove limits from the CTEs and ordering to speed up processing.
•	Also adjust the WHERE conditions to match.
•	Why? It identifies skills that provide job security (in-demand) and financial benefits (high-paying).
*/

SELECT ROUND((COUNT(skills_job_dim.job_id)/10) * (AVG(salary_year_avg)/200)/100, 0) AS optimum_metric,
    skills_dim.skill_id,
    skills_dim.skills,
    ROUND(AVG(salary_year_avg), 2) AS skill_avg_salary,     --Averages salaries for speciific skill
    COUNT(skills_job_dim.job_id) AS demand_count     --Counts the number of job that require that skill
FROM job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE job_title_short = 'Data Analyst'    -- This is for me as a European who can only work as a contractor.
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
    --    AND job_schedule_type = 'Contractor'    -- This is for me as a European who can only work as a contractor.
    --   AND job_title NOT LIKE '%Senior%' AND job_title NOT LIKE '%Principal%' AND job_title NOT LIKE '%Lead%'    -- Removing all jobs that would likely not be suited for a entry-level guy like me
GROUP BY skills_dim.skill_id
--HAVING COUNT(skills_job_dim.job_id) > 10     -- If we want to select only popular skills
ORDER BY optimum_metric DESC --, skill_avg_salary DESC, demand_count DESC
    
LIMIT 25;
