/*
Tutorial question: What are the most in-demand skills for data engineers?
- Identify top 5 in-demand skills for a data engineer
- Focus on all job postings
Result: provide insights into the most valuable skills for job seekers
(I'd perhaps pair most with "in-demand" instead of "valuable") 
*/

--My solution without looking at the tutor's:

SELECT
    sd.skills,
    COUNT(sjd.job_id) AS job_count
FROM 
    job_postings_fact AS jpf
INNER JOIN
    skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
INNER JOIN
    skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
GROUP BY
    sd.skills
ORDER BY
    job_count DESC
LIMIT 5;

/* 
Insights:
SQL, Python, AWS, Azure and Spark were the 5 most in-demand
skills for data engineers in 2023. This differs from the
top 10 highest-paying remote data engineer jobs. 

Kafka and Hadoop were amognst the most sought-after skills in the top 10
highest-paying remote DE jobs, but ranked 7th and 8th by demand
in all data engineer job postings in 2023.
/*


/*
Tutor's solution:

SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count 
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_work_from_home = True
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5 

/*
