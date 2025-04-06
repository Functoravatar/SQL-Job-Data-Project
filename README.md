# Introduction
This project looks at job market data for tech jobs. We analyze various metrics, trying to identify what jobs pay the most, what skills are in high demand in this market, and what skills most strongly influence salaries.

We did this using 5 SQL queries. You can find them here: [project folder](/Job%20Data%20Project/project_sql)  

# Background
This is my first data analysis project and it is based on Luke Barousse's YouTube tutorial (Thanks you!). The data used in this project also comes from his [course web site](https://lukebarousse.com/sql), which I highly recommend for anyone interested in this topic.

I made some modifications to his queries since my situation is obviously different. For instance, living in Europe, I can only consider remote job that are contract based. 

The questions I wanted to answer with SQL were the following:
1. What are the top-paying data analyst jobs?
2. What skills are required for the top-paying data analyst jobs?
3. What are the most in-demand skills for analysts?
4. What are the top skills based on salary?
5. What are the most optimal (high-demand and high-paying) skills?


# Tools

- **SQL**: The programming language permitting me to write queries
- **PostgreSQL**: The data base management system
- **Visual Studio Code**: The programming environment for SQL. It actually serves as an environment for many languages, including C++, python, and many others
- **Git and GitHub**: The online repository you are currently reading this on. It allows me to store and showcase projects. It is also a tool for version control and collaboration. I am hoping that this is the first of many projects I will put up here.


# Analysis
Each query is designed to answer one of the questions about the data analyst ob market posed above.

### 1. What are the top-paying data analyst jobs?

**Deliverable**

The top 10 highest-paying data analyst  or data science roles that are available remotely.

**Considerations**
- job postings with specified salaries (i.e. not NULL)
- jobs that are remote
- jobs that are contract work

**Reason why** 

This query highlights the top-paying opportunities for data analysts and data scientists, offering insights into employment options and location flexibility.

**Procedure**

List average annual salary for data analysts and scientists in descending order after filtering for remote and contract work.

**Code**
```sql
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
    AND (job_schedule_type = 'Contractor')
    AND (job_title_short IN ('Data Analyst', 'Data Scientist'))
ORDER BY salary_year_avg DESC
LIMIT 10;
```

**Insights**

- The top-paying jobs are mostly data scientist jobs (lead and principal, but also regular).
- Salaries range from 137,500 to 210,000.
- The companies offering these jobs include Harnham, Kelly Science, Mackin Talent, Telus, Ascendion, Insight Global, MatchPoint Solutions and ALMPG Staffing.

### 2. What skills are required for the top-paying data analyst jobs?

**Deliverable**

The skills required for the top 10 highest-paying remote data analyst or data science roles

**Considerations**
- job postings with specified salaries (i.e. not NULL)
- jobs that are remote
- jobs that are contract work

**Reason why** 

It highlights the top skills required to obtain high-paying roles, enabling us to know what skills to develop.

**Procedure**

Use the query from question 1 as a CTE and used it to list the skills associated with these highest-paying jobs.

**Code**
```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        company_dim.name AS company_name,
        salary_year_avg
    FROM job_postings_fact
    LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
    WHERE (salary_year_avg IS NOT NULL) 
    AND (job_work_from_home = TRUE) 
    AND (job_schedule_type = 'Contractor')
    AND (job_title_short IN ('Data Analyst', 'Data Scientist'))
    ORDER BY salary_year_avg DESC
    LIMIT 10
    )

SELECT top_paying_jobs.*,
    skills_dim.skills AS skill_name
FROM top_paying_jobs
INNER JOIN skills_job_dim ON skills_job_dim.job_id = top_paying_jobs.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
```

**Insights**

The top skills required for the top-paying jobs are SQL, Python, R, Go, and Python.

![Top Skills](assets\902a38c0.png)

### 3. What are the most in-demand skills for analysts?

**Deliverables** 

The top 5 in-demand skills for data analysts and data scientists.

**Considerations**
- job postings with specified salaries (i.e. not NULL)
- jobs that are remote
- jobs that are contract work

**Reason why**

It highlights the skills most often demanded by employers, again a good indicator of what skills best to develop.

**Procedure**

Calculate the average annual salary associated with each skill and listed them in descending order by salary.

**Code**
```sql
SELECT skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE (salary_year_avg IS NOT NULL) 
    AND (job_work_from_home = TRUE) 
    AND (job_schedule_type = 'Contractor')
    AND (job_title_short IN ('Data Analyst', 'Data Scientist'))
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;
```

**Insights**

The list of the top 5 in-demand skills for data analysis and data science jobs is: 
1. SQL
2. Python
3. R
4. Tableau
5. PowerBI

### 4. What are the top skills based on salary?

**Deliverable**

The top 25 most-demanded skills for data analysts and data scientists.

**Considerations**
- Look at average salary for each skill for data analyst and data scientists positions
- Focus on remote roles with specified salaries

**Reason why** 

It reveals the most financially rewarding skills to acquire.

**Procedure**

Calculate average salary for each skill for data analysts or scientists and list skills ordered by average salary.

**Code**
```sql
SELECT skills,
    ROUND(AVG(salary_year_avg), 2) AS skill_avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE job_title_short IN ('Data Analyst', 'Data Scientist')
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
    AND job_schedule_type = 'Contractor'GROUP BY skills
ORDER BY skill_avg_salary DESC
LIMIT 25;
```

**Insights**

The first five on the list of the best-paid skills for data analystst and scientists are:


|    | Skill  | Salary avg. |
|----|--------|-------------|
| 1. | Go     |  $210,000   |
| 2. | node.js|  $156,107   |
| 3. | GCP    |  $156,107   |
| 4. | Vue    |  $156,107   |
| 5. | MySQL  |  $156,107   |


This list is quite different from the list of most in-demand skills. A lot of them are niche skills for cloud-based applications.

### 5. What are the most optimal (high-demand and high-paying) skills?

**Deliverable**

The top 25 optimal skills for data analysts.

**Considerations**
- Concentrate on remote positions with specified salaries.
- This is a combination of queries 3 and 4
- I defined optimum as a weighted product of the two individual factors (in-demand and high-paying). The weights serve to emphasize in-demand over high-paying, since the very high-paying skill were often niche skills with a very small market, not suitable for beginners like me.

**Reason why**

It identifies skills that provide job security (in-demand) and financial benefits (high-paying).

**Procedure**

Combined the results from queries 3 and 4, using them as CTEs (and also in a shorter direct method) and then calculating the optimum metric, then listed the associated skills in descending order based on this metric.

**Code**
```sql
SELECT ROUND((COUNT(skills_job_dim.job_id)/10) * (AVG(salary_year_avg)/200)/100, 0) AS optimum_metric,
    skills_dim.skill_id,
    skills_dim.skills,
    ROUND(AVG(salary_year_avg), 2) AS skill_avg_salary
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE job_title_short IN ('Data Analyst', 'Data Scientist')
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
    AND job_schedule_type = 'Contractor'
GROUP BY skills_dim.skill_id
ORDER BY optimum_metric DESC
LIMIT 25;
```

**Insights**

The first five on this list are 

 1. Python
 2. SQL
 3. R
 4. Azure
 5. AWS

 This list, of course, depands on the respective weights assigned to in-demand vs high-paying.

# Learnings

In addition to the insights garnered from this project, the process of creating it helped me learn a variety of concepts and tools, such as 

- SQL
- PostgreSQL
- VS Code
- GitHub

# Conclusions

### Closing skills

Learning data analysis and data science is quite a hourney. In addition to the actual analytics, it also requires learning about programming environments and languages. It makes me appreciate all the more all the tutorials and courses one can find online these days.
