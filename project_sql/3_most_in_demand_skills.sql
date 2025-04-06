/* What are the most in-demand skills for analysts?
•	Deliverable: top 5 in-demand skills for data analysts.
•	Why? It highlights the top skills demanded by employers, so we can develop those skills.
*/

SELECT skills,
    COUNT(skills_job_dim.job_id) AS demand_count     --Counts the number of job that require that skill
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE (salary_year_avg IS NOT NULL) 
    AND (job_work_from_home = TRUE) 
    AND (job_schedule_type = 'Contractor')    -- This is for me as a European who can only work as a contractor.
    AND (job_title_short IN ('Data Analyst', 'Data Scientist'))
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;

/*Appended are the results of the SQL query above in .json format.
[
  {
    "skills": "sql",
    "demand_count": "7291"
  },
  {
    "skills": "excel",
    "demand_count": "4611"
  },
  {
    "skills": "python",
    "demand_count": "4330"
  },
  {
    "skills": "tableau",
    "demand_count": "3745"
  },
  {
    "skills": "power bi",
    "demand_count": "2609"
  }
]*/