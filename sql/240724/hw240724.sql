USE hr;

-- 1. 모든 사원의 이름, 부서번호, 부서 이름을 조회하세요
SELECT e.first_name, d.department_id, d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id;

-- 2. 부서번호 80 에 속하는 모든 업무의 고유 목록을 작성하고 부서의 위치를 출력하세요
SELECT concat(l.street_address, ', ', l.city, ', ', c.country_name) as 부서위치
FROM departments d, locations l, countries c
WHERE d.location_id = l.location_id AND c.country_id = l.country_id AND d.department_id = 80;

-- 3. 커미션을 받는 사원의 이름, 부서 이름, 위치번호와 도시명을 조회하세요
SELECT e.first_name as 사원명, d.department_name as 부서명, l.location_id as 위치번호, c.country_name as 도시명
FROM employees e, departments d, locations l, countries c
WHERE e.department_id = d.department_id AND d.location_id = l.location_id AND l.country_id = c.country_id AND e.commission_pct IS NOT NULL;

-- 4. 이름에 a(소문자)가 포함된 모든 사원의 이름과 부서명을 조회하세요
SELECT concat(e.first_name, ' ', e.last_name) as 사원명, d.department_id as 부서번호, d.department_name as 부서명
FROM employees e, departments d
WHERE e.department_id = d.department_id AND (e.first_name LIKE '%a%' OR e.last_name LIKE '%a%');

-- 5. 'Toronto'에서 근무하는 모든 사원의 이름, 업무, 부서 번호 와 부서명을 조회하세요
SELECT e.first_name as 사원명, j.job_title as 업무, d.department_id as 부서번호, d.department_name as 부서명
FROM employees e, departments d, locations l, jobs j
WHERE e.department_id = d.department_id AND e.job_id = j.job_id AND l.location_id = d.location_id AND l.city='Toronto';

-- 6. 사원의 이름 과 사원번호를 관리자의 이름과 관리자 아이디와 함께 표시하고 각각의 컬럼명을 Employee, Emp#, Manager, Mgr#으로 지정하세요
SELECT e1.first_name as 'Employee', e1.employee_id as 'Emp#', e2.first_name as 'Manager', e2.employee_id as 'Mgr#'
FROM employees e1, employees e2
WHERE e1.manager_id = e2.employee_id; 

-- 7. 사장인 'King'을 포함하여 관리자가 없는 모든 사원을 조회하세요 (사원번호를 기준으로 정렬하세요)
SELECT *
FROM employees
WHERE manager_id IS NULL
ORDER BY employee_id;

-- 8. 지정한 사원의 이름, 부서 번호와 지정한 사원과 동일한 부서에서 근무하는 모든 사원을 조회하세요
SELECT e1.first_name as 사원명, e1.department_id as 부서번호
FROM employees e1, employees e2
WHERE e1.department_id = e2.department_id AND e2.employee_id = 104;

-- 9. JOB_GRADRES 테이블을 생성하고 모든 사원의 이름, 업무, 부서이름, 급여, 급여등급을 조회하세요
SELECT e.first_name 사원명, j.job_title 업무, d.department_name 부서명, e.salary 급여, jg.grade_level 급여등급
FROM employees e, jobs j, departments d, job_grades jg
WHERE e.department_id = d.department_id AND e.job_id = j.job_id AND e.salary BETWEEN jg.lowest_sal AND jg.highest_sal;

