SELECT s.student_id, s.name, s.email, b.batch_name, e.enrolled_at AS admission_date
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN batches b ON e.batch_id = b.batch_id
WHERE e.status = 'active';

SELECT student_id, name, email 
FROM students 
WHERE email IS NULL 
   OR email = '' 
   OR email NOT LIKE '%@%.%';

SELECT problem_id, title, max_score 
FROM problems 
WHERE max_score <= 100;

SELECT submission_id, student_id, problem_id, language, submitted_at 
FROM submissions 
ORDER BY submitted_at DESC 
LIMIT 20;

SELECT DISTINCT s.submission_id, s.student_id, s.problem_id, tr.status
FROM submissions s
JOIN test_results tr ON s.submission_id = tr.submission_id
WHERE tr.status NOT IN ('passed', 'success', 'Successful');

SELECT sub.submission_id, s.name AS student_name, p.title AS problem_title, 
       sub.language, tr.status, p.max_score AS score, sub.submitted_at
FROM submissions sub
JOIN students s ON sub.student_id = s.student_id
JOIN problems p ON sub.problem_id = p.problem_id
LEFT JOIN test_results tr ON sub.submission_id = tr.submission_id;

SELECT s.student_id, s.name, e.batch_id, e.status AS enrollment_status
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id;

SELECT c.course_id, c.title, COUNT(e.student_id) AS total_enrolled_students
FROM courses c
LEFT JOIN batches b ON c.course_id = b.course_id
LEFT JOIN enrollments e ON b.batch_id = e.batch_id
GROUP BY c.course_id, c.title;

SELECT tr.test_result_id, sub.submission_id, s.name AS student_name, 
       p.title AS problem_title, tr.status AS test_case_status
FROM test_results tr
JOIN submissions sub ON tr.submission_id = sub.submission_id
JOIN students s ON sub.student_id = s.student_id
JOIN problems p ON sub.problem_id = p.problem_id;

SELECT DISTINCT s.student_id, s.name, s.email, b.batch_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN batches b ON e.batch_id = b.batch_id
WHERE s.student_id NOT IN (
    SELECT DISTINCT sub.student_id 
    FROM submissions sub
);

SELECT tr.status, COUNT(*) AS total_submissions
FROM test_results tr
GROUP BY tr.status;

SELECT p.problem_id, p.title, AVG(p.max_score) AS average_calculated_score
FROM problems p
JOIN submissions sub ON p.problem_id = sub.problem_id
GROUP BY p.problem_id, p.title;

SELECT s.student_id, s.name, COUNT(sub.submission_id) AS attempt_count
FROM students s
JOIN submissions sub ON s.student_id = sub.student_id
GROUP BY s.student_id, s.name
HAVING COUNT(sub.submission_id) > 5;

SELECT p.problem_id, p.title,
       (SUM(CASE WHEN tr.status IN ('passed', 'success') THEN 1 ELSE 0 END) * 100.0 / COUNT(tr.test_result_id)) AS success_rate
FROM problems p
JOIN submissions sub ON p.problem_id = sub.problem_id
JOIN test_results tr ON sub.submission_id = tr.submission_id
GROUP BY p.problem_id, p.title
HAVING success_rate < 40.0;

SELECT p.problem_id, p.title, COUNT(sub.submission_id) AS total_attempts
FROM problems p
JOIN submissions sub ON p.problem_id = sub.problem_id
GROUP BY p.problem_id, p.title
ORDER BY total_attempts DESC
LIMIT 10;

SELECT s.student_id, s.name
FROM students s
JOIN submissions sub ON s.student_id = sub.student_id
GROUP BY s.student_id, s.name
HAVING AVG(100) > (SELECT AVG(100) FROM problems);

SELECT problem_id, title 
FROM problems
WHERE problem_id NOT IN (SELECT DISTINCT problem_id FROM submissions);

SELECT s.student_id, s.name, s.email
FROM students s
WHERE s.student_id IN (SELECT student_id FROM enrollments)
  AND s.student_id NOT IN (SELECT student_id FROM submissions);

SELECT student_id, name 
FROM students 
WHERE student_id IN (
    SELECT student_id 
    FROM submissions 
    WHERE language LIKE '%Python%'
    
    INTERSECT
    
    SELECT student_id 
    FROM submissions 
    WHERE language LIKE '%Java%'
);

SELECT DISTINCT max_score 
FROM problems 
ORDER BY max_score DESC 
LIMIT 1 OFFSET 1;
