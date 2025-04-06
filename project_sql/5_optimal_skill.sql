/* What are the most optimal skills? Optimal means high-demand and high-paying.
•	Deliverable: top 5 optimal skills for data analysts.
•	Concentrate on remote positions with specified salaries.
•	This will be a combination of queries 3 and 4, which we will introduce as CTEs.
•	Adjustments: We will use the primary key to combine them (skill_id) and use it in the GROUP BY. 
•	Remove limits from the CTEs and ordering to speed up processing.
•	Also adjust the WHERE conditions to match.
•	Why? It identifies skills that provide job security (in-demand) and financial benefits (high-paying).
*/

WITH skill_demand AS (
    SELECT skills_dim.skill_id,
        skills_dim.skills,
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
),  
    skill_salary AS (
    SELECT skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 2) AS skill_avg_salary     --Averages salaries for speciific skill
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE job_title_short = 'Data Analyst'    -- This is for me as a European who can only work as a contractor.
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    --    AND job_schedule_type = 'Contractor'    -- This is for me as a European who can only work as a contractor.
    --   AND job_title NOT LIKE '%Senior%' AND job_title NOT LIKE '%Principal%' AND job_title NOT LIKE '%Lead%'    -- Removing all jobs that would likely not be suited for a entry-level guy like me
    GROUP BY skills_job_dim.skill_id
    )

SELECT ROUND((demand_count/10) * (skill_avg_salary/200)/100, 0) AS optimum_metric, --some weighted product of the demand and salary
    skill_demand.skills,
    demand_count,       -- if you put the skill_demand here, you get a vector ()
    skill_avg_salary
FROM skill_demand
INNER JOIN skill_salary ON skill_salary.skill_id = skill_demand.skill_id
ORDER BY optimum_metric DESC  --,demand_count DESC, skill_avg_salary DESC
LIMIT 25;

/* Appended are the results of the SQL query above in .json format.
[
  {
    "optimum_metric": "190",
    "skills": "sql",
    "demand_count": "398",
    "skill_avg_salary": "97237.16"
  },
  {
    "optimum_metric": "117",
    "skills": "python",
    "demand_count": "236",
    "skill_avg_salary": "101397.22"
  },
  {
    "optimum_metric": "114",
    "skills": "tableau",
    "demand_count": "230",
    "skill_avg_salary": "99287.65"
  },
  {
    "optimum_metric": "109",
    "skills": "excel",
    "demand_count": "256",
    "skill_avg_salary": "87288.21"
  },
  {
    "optimum_metric": "70",
    "skills": "r",
    "demand_count": "148",
    "skill_avg_salary": "100498.77"
  },
  {
    "optimum_metric": "54",
    "skills": "power bi",
    "demand_count": "110",
    "skill_avg_salary": "97431.30"
  },
  {
    "optimum_metric": "30",
    "skills": "sas",
    "demand_count": "63",
    "skill_avg_salary": "98902.37"
  },
  {
    "optimum_metric": "30",
    "skills": "sas",
    "demand_count": "63",
    "skill_avg_salary": "98902.37"
  },
  {
    "optimum_metric": "22",
    "skills": "powerpoint",
    "demand_count": "58",
    "skill_avg_salary": "88701.09"
  },
  {
    "optimum_metric": "21",
    "skills": "looker",
    "demand_count": "49",
    "skill_avg_salary": "103795.30"
  },
  {
    "optimum_metric": "17",
    "skills": "snowflake",
    "demand_count": "37",
    "skill_avg_salary": "112947.97"
  },
  {
    "optimum_metric": "17",
    "skills": "word",
    "demand_count": "48",
    "skill_avg_salary": "82576.04"
  },
  {
    "optimum_metric": "17",
    "skills": "azure",
    "demand_count": "34",
    "skill_avg_salary": "111225.10"
  },
  {
    "optimum_metric": "16",
    "skills": "oracle",
    "demand_count": "37",
    "skill_avg_salary": "104533.70"
  },
  {
    "optimum_metric": "16",
    "skills": "aws",
    "demand_count": "32",
    "skill_avg_salary": "108317.30"
  },
  {
    "optimum_metric": "15",
    "skills": "sql server",
    "demand_count": "35",
    "skill_avg_salary": "97785.73"
  },
  {
    "optimum_metric": "13",
    "skills": "sheets",
    "demand_count": "32",
    "skill_avg_salary": "86087.79"
  },
  {
    "optimum_metric": "12",
    "skills": "go",
    "demand_count": "27",
    "skill_avg_salary": "115319.89"
  },
  {
    "optimum_metric": "11",
    "skills": "hadoop",
    "demand_count": "22",
    "skill_avg_salary": "113192.57"
  },
  {
    "optimum_metric": "10",
    "skills": "flow",
    "demand_count": "28",
    "skill_avg_salary": "97200.00"
  },
  {
    "optimum_metric": "10",
    "skills": "javascript",
    "demand_count": "20",
    "skill_avg_salary": "97587.00"
  },
  {
    "optimum_metric": "10",
    "skills": "jira",
    "demand_count": "20",
    "skill_avg_salary": "104917.90"
  },
  {
    "optimum_metric": "9",
    "skills": "spss",
    "demand_count": "24",
    "skill_avg_salary": "92169.68"
  },
  {
    "optimum_metric": "9",
    "skills": "vba",
    "demand_count": "24",
    "skill_avg_salary": "88783.29"
  },
  {
    "optimum_metric": "7",
    "skills": "databricks",
    "demand_count": "10",
    "skill_avg_salary": "141906.60"
  }
]
*/