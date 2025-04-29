/*
Tutorial question: What skills are required for the top-paying data
engineer jobs?
- Use the top 10 highest-paying Data Engineer roles from the top_paying_jobs 
(first) query
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain 
skills, helping job seekers understand which skills to develop that align with
top salaries
*/


--My solution without looking at the tutor's:

WITH remote_jobs AS (
    SELECT
        jpf.job_id,
        jpf.job_title,
        jpf.job_location,
        jpf.job_schedule_type,
        ROUND(jpf.salary_year_avg, 0) AS avg_yearly_salary,
        cd.name AS company_name,
        jpf.job_posted_date
    FROM
        job_postings_fact AS jpf
    INNER JOIN
        company_dim AS cd ON cd.company_id = jpf.company_id
    WHERE
        jpf.job_title_short = 'Data Engineer'
        AND jpf.job_location = 'Anywhere'
        AND jpf.salary_year_avg IS NOT NULL
    ORDER BY 
        avg_yearly_salary DESC
    LIMIT 10
)

SELECT 
    sd.skills AS skill,
    remote_jobs.*
FROM 
    remote_jobs
INNER JOIN 
    skills_job_dim AS sjd ON sjd.job_id = remote_jobs.job_id
INNER JOIN 
    skills_dim AS sd ON sd.skill_id = sjd.skill_id;

/* 
Insights:
Python, Spark, Kafka, and Hadoop were the most prevalent skills found
in the job postings for the top 10 highest-paying remote data engineer roles in 2023.
/*


/*
Tutor's solution:

WITH top_paying_jobs AS (
    SELECT	
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND 
        job_location = 'Anywhere' AND 
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC; 

*/

   
  


