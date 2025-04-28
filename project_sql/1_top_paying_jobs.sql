
/*
Tutorial question: What are the top-paying data engineer jobs?
- Identify the top 10 highest-paying Data Engineer roles that are available remotely
- Focus on job postings with specified salaries (remove nulls)
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
        jpf.job_posted_date,
        cd.link_google AS job_link
    FROM
        job_postings_fact AS jpf
    /*I used an INNER JOIN instead of LEFT
    due to not wanting jobs which are not 
    associated with a company */
    INNER JOIN
        company_dim AS cd ON cd.company_id = jpf.company_id
    WHERE
        jpf.job_title_short = 'Data Engineer' 
        AND jpf.job_location = 'Anywhere'
        AND jpf.salary_year_avg IS NOT NULL
)

SELECT *
FROM 
    remote_jobs 
ORDER BY 
    avg_yearly_salary DESC
LIMIT 10;

/*
Insights:
The salaries ranged from 242000$ per year to 325000$.

We can notice a pattern of outsourcing recruitment. 6 and probably 7 out of the top 10 jobs 
were advertised by recruiting companies and one platform. Twitch, Moveable Ink and
Meta were the three comapnies directly hiring and offering top salaries to
data engineers.
/*

Tutor's solution:

SELECT	
	job_id,
	job_title,
	job_location,
	job_schedule_type,
	salary_year_avg,
	job_posted_date,
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

*/




