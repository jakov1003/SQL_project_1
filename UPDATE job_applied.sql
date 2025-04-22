UPDATE job_applied
SET contact = 'Erlich Bachman'
WHERE job_id = 1;

UPDATE job_applied
SET contact = 'Dinesh Chugtai'
WHERE job_id = 2;

UPDATE job_applied
SET contact = 'Bertram Gilfoyle'
WHERE job_id = 3;

UPDATE job_applied
SET contact = 'Jian Yang'
WHERE job_id = 4;

UPDATE job_applied
SET contact = 'Big Head'
WHERE job_id = 5;

select * FROM job_applied

ALTER TABLE job_applied
RENAME COLUMN contact to contact_name;

select * from job_applied

ALTER TABLE job_applied
ALTER COLUMN contact_name TYPE TEXT;

select * from job_applied

ALTER TABLE job_applied
DROP COLUMN contact_name;

SELECT * FROM job_applied

DROP TABLE job_applied;


