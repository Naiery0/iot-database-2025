-- WorkBook : SQL Practice
/* 샘플 - Employee에서 사원번호, 이름, 급여, 업무, 입사일, 상사의 사원 번호를 출력하시오
          이때 이름과 성을 연결하여 Full Name이라는 별칭으로 출력하시오 (107행)
*/
use hr;

-- SELECT * FROM hr.employees;

/* 문제 1 - employee에서 사원의 성과 이름을 Name, 업무는 Job, 급여는 Salary, 연봉에 $100 보너스를 추가해서 계산한 Increased Ann_Salary
			급여에 $100 보너스를 추가해서 Increased Salary 별칭으로 출력하시오 */
            
select concat(first_name, ' ', last_name) as 'Name'
	 , job_id as 'Job'
     , salary as 'Salary'
     , (salary * 12) + 100 as 'Increased Ann_Salary'
     , (salary + 100) * 12 as 'Increased Salary'
  from employees;
  
/* 2 - Employees 에서 모든 사원의 last_name과 연봉을 '이름: 1 Year Salary = $연봉' 형식으로 출력하고, 1 Year Salary 라는 별칭을 붙이시오.
*/
select concat(last_name, ': 1 Year Salary = $',  (salary * 12)) as '1 Year Salary'
  from employees;
  
  
/* 3 - 부서에 담당하는 업무를 한 번씩만 출력하시오
*/
select distinct department_id, job_id
  from employees;


-- where, order by
/* 샘플 - hr부서 예산 편성 문제로 급여 정보 보고서를 작성한다. employees에서 salary가 7000$ ~ 10000$ 범위 이외의 사람의
          성과 이름을 Name으로 해서 급여가 작은 순으로 출력하시오
*/

SELECT CONCAT(first_name, ' ',last_name) as 'Name'
     , salary
  FROM employees
 WHERE salary NOT BETWEEN 7000 and 10000
 ORDER BY salary;


/* 1- 사원의 last_name 중 e나 o 글자를 포함한 사원을 출력하시오. 이때 컬럼 명은 e AND o Name이라고 출력하시오
*/
SELECT last_name as 'e AND o Name'
  FROM employees
 WHERE last_name like '%e%' and last_name like '%o%';


/* 2 - 현재 날짜 타입을 날짜함수를 통해 확인, 1995년 5월 20일 ~ 1996년 5월 20일 사이 입사한 사원의 이름 Name으로 별칭을 쓰고,
       사원번호, 고용일자를 출력하시오. 단 입사일이 빠른 순으로 정렬하시오.
*/
SELECT date_add(SYSDATE(), INTERVAL 9 hour) as 'sysdate()';

desc employees;

SELECT last_name as 'name'
     , employee_id
     , hire_date
  FROM employees
 where hire_date BETWEEN '1995-05-20' and '1996-05-20' -- date타입은 문자열처럼 조건연산을 해도 된다
 ORDER BY hire_date;

-- 단일행 함수 및 변환 함수
/* 1 - 이름이 s로 끝나는 각 사원의 업무를 아래의 예와 같이 출력하고자 함.
       머리글은 Employee Jobs로 표시할 것 */

SELECT CONCAT(first_name, ' ', last_name, ' is a ', upper(job_id)) as 'Employee Jobs'
  FROM employees
 WHERE last_name like '%s'; 

/* 3 - 사원의 성과 이름을 Name으로 별칭, 입사일, 입사한 요일을 출력하시오. 이때, 주(week) 시작인 일요일부터 출력되도록 정렬*/
SELECT CONCAT(first_name, ' ', last_name) as 'Name'
     , hire_date
     , DATE_FORMAT(hire_date, '%W') as 'Day of the week' 
  FROM employees
 ORDER BY DATE_FORMAT(hire_date, '%w') asc;

-- 집계함수
/* 1 - 사원이 소속된 부서별 급여 합계, 급여 평균, 급여 최댓값, 급여 최솟값을 집계.
       출력값은 여섯자리와 세자리 구분기호, $표시 포함, 부서번호를 오름차순
       단, 부서에 소속되지 않는 사원은 정보에서 제외, 출력 시 머리글은 아래처럼 별칭으로 처리
*/

SELECT department_id as 부서
     , CONCAT('$', FORMAT(round(SUM(salary), 0), 0)) as '급여 합계'
     , CONCAT('$', FORMAT(round(AVG(salary), 1), 1)) as '급여 평균' -- round(컬럼, 1), 소수점 1자리에서 반올림, format(값, 1) 소수점표현 및 1000단위 , 표시
     , CONCAT('$', FORMAT(round(MAX(salary), 0), 0)) as '급여 최댓값'
     , CONCAT('$', FORMAT(round(MIN(salary), 0), 0)) as '급여 최솟값'
  FROM employees
 WHERE department_id is NOT NULL 
 GROUP BY department_id;

-- 조인
/* 2 - job_grades 테이블을 사용, 각 사원의 급여에 따른 급여등급을 보고한다. 이름과 성을 name으로, 업무, 부서명, 입사일, 급여, 급여등급을 출력(106)
*/

desc job_grades;
desc employees;

SELECT *
  from departments as d, employees as e
 WHERE d.department_id = e.department_id;

SELECT CONCAT(e.first_name, ' ', e.last_name) as 'name'
     , e.job_id
     , d.department_name
     , e.hire_date
     , e.salary
     , (SELECT grade_level from job_grades WHERE e.salary BETWEEN lowest_sal and highest_sal) as '급여등급'
  from departments as d, employees as e
 WHERE d.department_id = e.department_id
 ORDER BY e.salary DESC;
-- 서브쿼리 테스트
SELECT * 
  from job_grades
 WHERE 10000 BETWEEN lowest_sal and highest_sal;

/* 3 - 각 사원의 상사와의 관계를 이용, 보고서 작성을 하려고 한다
       예를 보고 출력하시오 */
SELECT CONCAT(e2.first_name, ' ', e2.last_name) as 'employee'
     , 'report to'
     , CONCAT(e1.first_name, ' ', e1.last_name) as 'manager' 
  FROM employees as e1 RIGHT JOIN employees as e2
    ON e1.employee_id = e2.manager_id; 


-- 서브쿼리
/* 3 - 사원들의 지역별 근무현황을 조회. 도시 이름이 영문 'O'로 시작하는 지역에 살고
       사번, 이름, 업무, 입사일 출력
*/
SELECT e.employee_id, e.first_name, j.job_title, e.hire_date, l.city
  FROM employees as e, jobs as j, departments as d, locations as l
 WHERE e.department_id = d.department_id and e.job_id = j.job_id and l.location_id = d.location_id
   AND d.location_id = (SELECT location_id from locations WHERE city like 'O%');