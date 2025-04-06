/* Question: What are the top-paying data analyst jobs?
•	Deliverable: top 10 highest-paying Data Analyst roles that are available remotely.
•	Focus on job postings with specified salaries, because how else...? 
*   Also, focus on postings that are contract work (as I live in Europe) and lie within reach as an entry-level Data Analyst.
•	Why? Aims to highlight the top-paying opportunities for Data Analysts, offering insights into employment options and location flexibility.
*/
SELECT
    job_id,
    job_title,
    company_dim.name,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM job_postings_fact
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE (salary_year_avg IS NOT NULL) 
    AND (job_work_from_home = TRUE) 
    AND (job_schedule_type = 'Contractor')    -- This is for me as a European who can only work as a contractor.
    AND (job_title_short IN ('Data Analyst', 'Data Scientist'))
--    AND job_title NOT LIKE '%Senior%' AND job_title NOT LIKE '%Principal%' AND job_title NOT LIKE '%Lead%'    -- Removing all jobs that would likely not be suited for a entry-level guy like me
ORDER BY salary_year_avg DESC
LIMIT 10;
