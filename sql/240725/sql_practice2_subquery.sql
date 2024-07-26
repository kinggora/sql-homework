USE hr;
-- [문제 1] HR 부서의 어떤 사원은 급여정보를 조회하는 업무를 맡고 있다.
-- Tucker(last_name) 사원보다 급여를 많이 받고 있는 사원의 성과 이름(Name으로 별칭), 업무, 급여를 출력하시오
SELECT concat(first_name, ' ', last_name) as Name, job_title as Jobs, e.salary as Salary
FROM employees e, jobs j
WHERE e.job_id = j.job_id AND e.salary > (SELECT salary FROM employees WHERE last_name = 'Tucker' LIMIT 1);

-- [문제 2] 사원의 급여 정보 중 업무별 최소 급여를 받고 있는 사원의 성과 이름(Name으로 별칭), 업무, 급여, 입사일을 출력하시오
SELECT concat(e.first_name, ' ', e.last_name) Name, job_title 업무, e.salary 급여, e.hire_date 입사일
FROM employees e JOIN jobs j
ON e.job_id = j.job_id
WHERE e.salary = (
	SELECT MIN(salary)
	FROM employees
	WHERE job_id = e.job_id
);

-- [문제 3] 소속 부서의 평균 급여보다 많은 급여를 받는 사원에 대하여 사원의 성과 이름(Name으로 별칭), 급여, 부서번호, 업무를 출력하시오
SELECT concat(e.first_name, ' ', e.last_name) as Name, e.salary as 급여, e.department_id as 부서번호, j.job_title as 업무
FROM employees e, jobs j
WHERE e.job_id = j.job_id AND e.salary > (SELECT avg(salary) FROM employees GROUP BY department_id HAVING department_id = e.department_id)
ORDER BY department_id;

-- SELECT department_id, avg(salary)
-- FROM employees
-- GROUP BY department_id
-- order by department_id;
-- SELECT concat(e.first_name, ' ', e.last_name) as Name, salary, department_id
-- FROM employees e
-- order by department_id;

-- [문제 4] 사원들의 지역별 근무 현황을 조회하고자 한다. 도시 이름이 영문 'O' 로 시작하는 지역에 살고 있는 사원의 사번, 이름, 업무, 입사일을 출력하시오
-- SELECT l.location_id
-- FROM locations l
-- WHERE l.city LIKE 'o%';

SELECT e.employee_id 사번, concat(e.first_name, ' ', e.last_name) 이름, j.job_title 업무, e.hire_date 입사일
FROM employees e, departments d, jobs j
WHERE e.department_id = d.department_id AND e.job_id = j.job_id AND d.location_id IN (
	SELECT l.location_id
	FROM locations l
	WHERE l.city LIKE 'o%'
);

-- [문제 5] 모든 사원의 소속부서 평균연봉을 계산하여 사원별로 성과 이름(Name으로 별칭), 업무, 급여, 부서번호, 부서 평균연봉(Department Avg Salary로 별칭)을 출력하시오
SELECT concat(e.first_name, ' ', e.last_name) 이름, j.job_title 업무, e.salary 급여, e.department_id 부서번호, (
	SELECT avg(em.salary * 12)
	FROM departments d, employees em
    WHERE d.department_id = em.department_id AND d.department_id = e.department_id
)  'Department Avg Salary'
FROM employees e, jobs j
WHERE e.job_id = j.job_id;

-- [문제 6] ‘Kochhar’의 급여보다 많은 사원의 정보를 사원번호,이름,담당업무,급여를 출력하시오.
SELECT e.employee_id 사원번호, concat(e.first_name, ' ', e.last_name) 이름, j.job_title 담당업무, e.salary 급여
FROM employees e, jobs j
WHERE e.job_id = j.job_id AND e.salary > (
	SELECT salary
	FROM employees
	WHERE first_name = 'Kochhar' OR last_name = 'Kochhar'
);

-- [문제 7] 급여의 평균보다 적은 사원의 사원번호,이름,담당업무,급여,부서번호를 출력하시오
SELECT avg(salary) FROM employees; -- 급여 평균
SELECT e.employee_id 사원번호, concat(e.first_name, ' ', e.last_name) 이름, j.job_title 담당업무, e.salary 급여, e.department_id 부서번호
FROM employees e, jobs j
WHERE e.job_id = j.job_id AND e.salary < (SELECT avg(salary) FROM employees)
ORDER BY e.salary DESC;

-- [문제 8] 100번 부서의 최소 급여보다 최소 급여가 많은 다른 모든 부서를 출력하시오
SELECT d.department_id 부서번호, d.department_name 부서명, MIN(e.salary) 최소급여
FROM departments d JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_id
HAVING MIN(e.salary) > (
	SELECT MIN(e.salary)
	FROM departments d JOIN employees e
	ON d.department_id = e.department_id
	WHERE d.department_id = 100
);

-- [문제 9] 업무별로 최소 급여를 받는 사원의 정보를 사원번호,이름,업무,부서번호를 출력하시오. 출력시 업무별로 정렬하시오
SELECT MIN(salary)
	FROM employees
	GROUP BY job_id; -- 업무별 최소 급여
SELECT e.employee_id 사원번호, concat(e.first_name, ' ', e.last_name) 이름, j.job_title 업무, e.department_id 부서번호
FROM employees e, jobs j
WHERE e.job_id = j.job_id AND e.salary = (
	SELECT MIN(salary)
	FROM employees
    WHERE job_id = e.job_id
);

-- [문제 10] 100번 부서의 최소 급여보다 최소 급여가 많은 다른 모든 부서를 출력하시오.
SELECT MIN(salary)
FROM employees
WHERE department_id = 100;
SELECT MIN(e.salary), d.department_id
FROM employees e, departments d
WHERE e.department_id = d.department_id
GROUP BY d.department_id
HAVING MIN(e.salary) > (
	SELECT MIN(salary)
	FROM employees
	WHERE department_id = 100
);

-- [문제 11] 업무가 SA_MAN 사원의 정보를 이름,업무,부서명,근무지를 출력하시오.
SELECT concat(e.first_name, ' ', e.last_name) 이름, e.job_id 업무, d.department_name 부서명, l.location_id 근무지
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id AND d.location_id = l.location_id AND e.employee_id IN (
	SELECT employee_id
	FROM employees
	WHERE job_id = 'SA_MAN'
);

-- [문제 12] 가장 많은 부하직원을 갖는 MANAGER의 사원번호와 이름을 출력하시오
SELECT employee_id 사원번호, concat(first_name, ' ', last_name) 이름
FROM employees
WHERE employee_id IN (
	SELECT employee_id
	FROM employees
	GROUP BY manager_id
    HAVING COUNT(employee_id) = (
		SELECT COUNT(employee_id)
		FROM employees
		GROUP BY manager_id
		ORDER BY COUNT(employee_id) DESC LIMIT 1
	)
);

-- [문제 13] 사원번호가 123인 사원과 업무가 같고 사원번호가 192인 사원의 급여(SAL))보다 많은 사원의 사원번호,이름,직업,급여를 출력하시오
SELECT job_id FROM employees WHERE employee_id = 123; -- ST_MAN
SELECT salary FROM employees WHERE employee_id = 192; -- 4000.00

SELECT employee_id 사원번호, concat(e.first_name, ' ', e.last_name) 이름, j.job_title 직업, e.salary 급여
FROM employees e JOIN jobs j
ON e.job_id = j.job_id
WHERE e.job_id = (SELECT job_id FROM employees WHERE employee_id = 123) AND e.salary > (SELECT salary FROM employees WHERE employee_id = 192);


-- [문제 14] 50번 부서에서 최소 급여를 받는 사원보다 많은 급여를 받는 사원의 사원번호,이름,업무,입사일자,급여,부서번호를 출력하시오. 단 50번 부서의 사원은 제외합니다.
SELECT MIN(salary)
FROM employees
WHERE department_id = 50; -- 2100.00

SELECT e.employee_id 사원번호, concat(e.first_name, ' ', e.last_name) 이름, j.job_title 업무, e.hire_date 입사일자, e.salary 급여, e.department_id 부서번호
FROM employees e JOIN jobs j
ON e.job_id = j.job_id
WHERE e.department_id <> 50 AND e.salary > (
	SELECT MIN(salary)
	FROM employees
	WHERE department_id = 50
)
ORDER BY e.salary;

-- [문제 15] (50번 부서의 최고 급여)를 받는 사원 보다 많은 급여를 받는 사원의 사원번호,이름,업무,입사일자,급여,부서번호를 출력하시오. 단 50번 부서의 사원은 제외합니다.
SELECT MAX(salary)
FROM employees
WHERE department_id = 50; -- 2100.00

SELECT e.employee_id 사원번호, concat(e.first_name, ' ', e.last_name) 이름, j.job_title 업무, e.hire_date 입사일자, e.salary 급여, e.department_id 부서번호
FROM employees e JOIN jobs j
ON e.job_id = j.job_id
WHERE e.department_id <> 50 AND e.salary > (
	SELECT MAX(salary)
	FROM employees
	WHERE department_id = 50
)
ORDER BY e.salary;