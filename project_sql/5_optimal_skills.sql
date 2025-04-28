/*
Tutorial question: What are the most optimal skills to learn (aka it's in 
high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for 
Data Engineer roles
- Concentrate on remote positions with specified salaries
- Why? Target skills that offer job security (high demand) and financial 
benefits (high salaries), offering strategic insights for career development
*/


--My solution without looking at the tutor's:

WITH optimal_skills AS (
    SELECT
        sd.skills,
        COUNT (sjd.job_id) AS job_count,
        ROUND (AVG(jpf.salary_year_avg), 0) AS salary_per_skill
    FROM 
        job_postings_fact AS jpf
    INNER JOIN
        skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
    INNER JOIN
        skills_dim AS sd ON sjd.skill_id = sd.skill_id
    WHERE
        jpf.job_title_short = 'Data Engineer' AND jpf.job_work_from_home = TRUE
        AND jpf.salary_year_avg IS NOT NULL
    GROUP BY
        sd.skills
)

SELECT 
    *,
    DENSE_RANK() OVER (ORDER BY job_count DESC) AS job_count_rank,
    DENSE_RANK() OVER (ORDER BY salary_per_skill DESC) AS salary_rank,
    ROUND ((DENSE_RANK() OVER (ORDER BY job_count DESC) + DENSE_RANK() OVER (ORDER BY salary_per_skill DESC)) / 2.0, 0) AS avg_rank
FROM
    optimal_skills
ORDER BY 
    avg_rank ASC
LIMIT 10;

/* 
Insights and explanations:
Kafka was the most optimal skill to learn for remote data 
engineer jobs in 2023. Mongo, rust, perl, neo4j, and assembly
were not highly demanded, but knowing them paid off.

I decided to find the most optimal skill(s) by ranking 
them on demand (the job_count column) and salary, then 
summing and averaging these ranks. The lower the
average rank, the more optimal the skill.

I deviated from the tutorial question a bit,
because a skill being optimal does not necessarily mean
both high salary and high demand. It's the combination
of the two.
    
The tutor's approach differs greatly from mine, but
both are more than valid. My
approach offers instant answers, while the tutor's requires
further interpretation. I am not saying that my approach beats
a world-renowned SQL expert's, I am just opining 
how each could be used.
*/

/*
Tutor's solution:

-- Identifies skills in high demand for Data Analyst roles
-- Use Query #3

WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' 
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True 
    GROUP BY
        skills_dim.skill_id
), 
-- Skills with high average salaries for Data Analyst roles
-- Use Query #4
average_salary AS (
    SELECT 
        skills_job_dim.skill_id,
        ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True 
    GROUP BY
        skills_job_dim.skill_id
)
-- Return high demand and high salaries for 10 skills 
SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN  average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE  
    demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;

-- Tutor "rewriting the same query more concisely":
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;

/*
