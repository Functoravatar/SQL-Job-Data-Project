/* What are the top skills based on salary?
•	Deliverable: top 5 in-demand skills for data analysts.
•	Look at average salary for each skill for data analyst positions
•	Focus on roles with specified salary, regardless of location and later for remote.
•	Why? It reveals the most financially rewarding skills to acquire.
*/

SELECT skills,
    ROUND(AVG(salary_year_avg), 2) AS skill_avg_salary     --Counts the number of job that require that skill
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE job_title_short = 'Data Analyst'    -- This is for me as a European who can only work as a contractor.
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
--    AND job_schedule_type = 'Contractor'    -- This is for me as a European who can only work as a contractor.
--   AND job_title NOT LIKE '%Senior%' AND job_title NOT LIKE '%Principal%' AND job_title NOT LIKE '%Lead%'    -- Removing all jobs that would likely not be suited for a entry-level guy like me
GROUP BY skills
ORDER BY skill_avg_salary DESC
LIMIT 25;

/* Appended are the results of the SQL query above in .json format.
[
  {
    "skills": "pyspark",
    "skill_avg_salary": "208172.25"
  },
  {
    "skills": "bitbucket",
    "skill_avg_salary": "189154.50"
  },
  {
    "skills": "couchbase",
    "skill_avg_salary": "160515.00"
  },
  {
    "skills": "watson",
    "skill_avg_salary": "160515.00"
  },
  {
    "skills": "datarobot",
    "skill_avg_salary": "155485.50"
  },
  {
    "skills": "gitlab",
    "skill_avg_salary": "154500.00"
  },
  {
    "skills": "swift",
    "skill_avg_salary": "153750.00"
  },
  {
    "skills": "jupyter",
    "skill_avg_salary": "152776.50"
  },
  {
    "skills": "pandas",
    "skill_avg_salary": "151821.33"
  },
  {
    "skills": "elasticsearch",
    "skill_avg_salary": "145000.00"
  },
  {
    "skills": "golang",
    "skill_avg_salary": "145000.00"
  },
  {
    "skills": "numpy",
    "skill_avg_salary": "143512.50"
  },
  {
    "skills": "databricks",
    "skill_avg_salary": "141906.60"
  },
  {
    "skills": "linux",
    "skill_avg_salary": "136507.50"
  },
  {
    "skills": "kubernetes",
    "skill_avg_salary": "132500.00"
  },
  {
    "skills": "atlassian",
    "skill_avg_salary": "131161.80"
  },
  {
    "skills": "twilio",
    "skill_avg_salary": "127000.00"
  },
  {
    "skills": "airflow",
    "skill_avg_salary": "126103.00"
  },
  {
    "skills": "scikit-learn",
    "skill_avg_salary": "125781.25"
  },
  {
    "skills": "jenkins",
    "skill_avg_salary": "125436.33"
  },
  {
    "skills": "notion",
    "skill_avg_salary": "125000.00"
  },
  {
    "skills": "scala",
    "skill_avg_salary": "124903.00"
  },
  {
    "skills": "postgresql",
    "skill_avg_salary": "123878.75"
  },
  {
    "skills": "gcp",
    "skill_avg_salary": "122500.00"
  },
  {
    "skills": "microstrategy",
    "skill_avg_salary": "121619.25"
  }
]
*/