-- Problem 5 : What are the most optimal skills to learn
-- in most demand and highest paying for Data Analyst roles?

-- Identifies skills in high demand for Data Analyst roles
-- Use Query #3 (but modified)


With skills_demand As (
  SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
  FROM
    job_postings_fact
    INNER JOIN
      skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN
      skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
  WHERE
    -- Filters job titles for 'Data Analyst' roles
    job_postings_fact.job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True -- optional to filter for remote jobs
  GROUP BY
    skills_dim.skill_id, 
    skills_dim.skills
), Average_Salary AS (
  SELECT
    skills_dim.skill_id,
    ROUND(AVG(job_postings_fact.salary_year_avg),2) AS avg_salary
  FROM
    job_postings_fact
    INNER JOIN
      skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN
      skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
  WHERE
    job_postings_fact.job_title_short = 'Data Analyst' 
    AND job_postings_fact.salary_year_avg IS NOT NULL 
    -- AND job_work_from_home = True  -- optional to filter for remote jobs
  GROUP BY
    skills_dim.skill_id, 
    skills_dim.skills
)

-- Return high demand and high salaries for 10 skills 
SELECT
  skills_demand.skills,
  skills_demand.demand_count,
  ROUND(average_salary.avg_salary, 2) AS avg_salary --ROUND to 2 decimals 
FROM
  skills_demand
	INNER JOIN
	  average_salary ON skills_demand.skill_id = average_salary.skill_id
-- WHERE demand_count > 10
ORDER BY
  demand_count DESC, 
	avg_salary DESC
LIMIT 10 --Limit 25
; 
