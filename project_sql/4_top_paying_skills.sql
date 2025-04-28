/*
Tutorial question: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Engineer positions
- Focus on roles with specified salary regardless of location
- Why? It reveals how different skills impact salary levels for Data Engineers and
    helps identify the most financially rewarding skills to acquire or improve
*/

--My solution without looking at the tutor's:

SELECT
    sd.skills AS skill,
    ROUND (AVG(jpf.salary_year_avg), 0) AS salary_per_skill
FROM 
    job_postings_fact AS jpf
INNER JOIN
    skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
INNER JOIN
    skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer' AND jpf.salary_year_avg IS NOT NULL
GROUP BY
    skill
ORDER BY 
    salary_per_skill DESC
LIMIT 10;

/*
Insights:
Intrestingly, none of the top 10 skills with the highest
average salary were amognst the skills required by
the top 10 highest-paying remote data engineer jobs in 2023.

Also, none of them fell in the most demanded skills
category.
*/


/*
Tutor's solution:

SELECT
    skills,
    ROUND (AVG(salary_year_avg), 0) as avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY 
    avg_salary DESC
LIMIT 25;

*/
