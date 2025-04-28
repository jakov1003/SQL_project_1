# Introduction
My project from the [Learn SQL in 4 Hours tutorial](https://www.youtube.com/watch?v=7mz73uXD9DA). The task was to explore a data-related job postings dataset from 2023, focusing on one particular role. I went with the data engineer role, while the tutor explored data analyst roles. 

I answered the questions from the tutorial without looking at the tutor's solutions.

If you would like to take a more in-depth look at my queries, you can do that [here](/project_sql/).
# Shortened Questions
- 1. What are the top-paying data engineer jobs?
- 2. What skills are required for these top-paying jobs?
- 3. What skills are most in demand for data engineers?
- 4. What skills are associated with higher salaries?
- 5. What are the most optimal skills to learn?

(These questions are in the present tense, but I (mostly) used the past tense when writing insights due to possible changes in the job market from 2023.)

# Tools I Used
- **SQL**
- **PostgreSQL**
- **Visual Studio Code**
- **Git & Github** (for version control and sharing) 

# The Analysis

### 1.Top Paying Remote Data Engineer Jobs in 2023

```sql
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
    due to not wanting jobs that are not 
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
```
## Insights:

- **Salaries:** the average salaries ranged from 242 000$ to 325 000$
- **Outsourced recruitment:** 6 and probably 7 out of the top 10 jobs were advertised by recruiting companies and one platform 
- **No intermediaries:** Twitch, Moveable Ink and
Meta were the three companies directly hiring and offering top salaries to data engineers.

### 2.Skills for Top-Paying Remote Data Engineer Jobs in 2023

```sql
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
    skills_dim AS sd ON sd.skill_id = sjd.skill_id
```  
## Insights:
- **Top skills in top 10 remote DE jobs:** Python, Spark, Kafka, Hadoop

## 3.Most in-demand skills for data engineers in 2023
This query focused on all jobs, and not just the highest-paying remote roles.

```sql
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
``` 
**Insights:**

- **Most demanded skills:** SQL, Python, AWS, Azure, Spark
- **Different levels, different requirements:** Kafka and Hadoop were among the most sought-after skills in the top 10
highest-paying remote DE jobs, but ranked 7th and 8th by demand
in all data engineer job postings in 2023.

## 4. Skills with the Highest Average Salary

This query, once again, explored all DE roles and not just remote jobs.

```sql
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
``` 
**Insights:**

- **Average does not mean top of the line:** Interestingly, none of the top 10 skills with the highest
average salary were among the skills required by
the top 10 highest-paying remote data engineer jobs in 2023. Also, none of them fell in the most demanded skills
category.

## 5.Most Optimal Skill
I previously shortened or completely omitted the tutorial question from the README code because it was unnecessary. However, the full version is necessary for context here.

``` sql
/*
Tutorial question: What are the most optimal skills to learn (aka it's in 
high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for 
Data Engineer roles
- Concentrate on remote positions with specified salaries
- Why? Target skills that offer job security (high demand) and financial 
benefits (high salaries), offering strategic insights for career development
*/

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
``` 
## Insights and explanations:
- **I wanna work from home:** Kafka was the most optimal skill to learn for remote data 
engineer jobs in 2023. 
- **Learning niche skills:** Mongo, rust, perl, neo4j and assembly
were not highly demanded, but knowing them paid off.

- **Method:** I decided to find the most optimal skill(s) by ranking 
them on demand (the job_count column) and salary, then 
summing and averaging these ranks. The lower the
average rank, the more optimal the skill. My approach differs greatly from the tutor's, but we both got valuable insights

- **My understanding:** I deviated from the tutorial question a bit,
because a skill being optimal does not necessarily mean
both high salary and high demand. It's the combination
of the two.
