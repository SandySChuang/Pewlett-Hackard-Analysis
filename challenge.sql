--Challenge Part 1
-- Number of titles retiring
SELECT ti.emp_no, ce.first_name, ce.last_name, ti.title, ti.from_date, s.salary
INTO title_retiring
FROM titles AS ti
INNER JOIN current_emp AS ce
	ON (ti.emp_no = ce.emp_no)
INNER JOIN salaries AS s
	ON (ti.emp_no = s.emp_no);

-- Find duplicates
SELECT emp_no, first_name, last_name, count(*)
FROM title_retiring
GROUP BY emp_no, first_name, last_name
HAVING count(*) >1;

-- View duplicate rows
SELECT * FROM
	(SELECT *, count(*)
	OVER
		(PARTITION BY
			emp_no, first_name, last_name
		) AS count
	FROM title_retiring) tableWITHCount
	WHERE tableWITHCount.count > 1;
	
-- Remove duplicates
SELECT emp_no, first_name, last_name, title, from_date, salary
INTO most_recent_title_retiring
FROM (SELECT emp_no, first_name, last_name, title, from_date, salary,
	 	ROW_NUMBER() OVER
	 (PARTITION BY (emp_no, first_name, last_name) ORDER BY from_date DESC) rn
	 	FROM title_retiring
	 ) tmp WHERE rn = 1;

-- Most recent title frequency count
SELECT from_date, title, COUNT(emp_no)
INTO most_recent_title_retire_cnt
FROM most_recent_title_retiring
GROUP BY (from_date, title)
ORDER BY from_date DESC;

-- Find duplicates
SELECT emp_no, first_name, last_name, count(*)
FROM title_retiring
GROUP BY emp_no, first_name, last_name
HAVING count(*) >1;

-- View duplicate rows
SELECT * FROM
	(SELECT *, count(*)
	OVER
		(PARTITION BY
			emp_no, first_name, last_name
		) AS count
	FROM title_retiring) tableWITHCount
	WHERE tableWITHCount.count > 1;
	
-- Remove duplicates
SELECT emp_no, first_name, last_name, title, from_date, salary
INTO most_recent_title_retiring
FROM (SELECT emp_no, first_name, last_name, title, from_date, salary,
	 	ROW_NUMBER() OVER
	 (PARTITION BY (emp_no, first_name, last_name) ORDER BY from_date DESC) rn
	 	FROM title_retiring
	 ) tmp WHERE rn = 1;

-- Most recent title frequency count
SELECT from_date, title, COUNT(emp_no)
INTO most_recent_title_retire_cnt
FROM most_recent_title_retiring
GROUP BY (from_date, title)
ORDER BY from_date DESC;

