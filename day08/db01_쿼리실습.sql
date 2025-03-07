-- 실무실습 계속

-- 서브쿼리 계속
/* 문제1 - 사원의 급여 정보 중 업무별(job) 최소 급여를 받는 사원의 이름, 성을 name으로 별칭, 업무, 급여, 입사일로 출력(21행)
*/
select concat(e1.first_name, ' ', e1.last_name) as 'name'
     , e1.job_id
     , e1.salary
     , e1.hire_date
  from employees as e1
 where (e1.job_id, e1.salary) in (select e.job_id
									   , min(e.salary) as salary
								    from employees as e
								   group by e.job_id);
 
 
-- 집합연산자 : 테이블 내용을 합쳐서 조회

-- 조건부 논리 표현식 제어 : CASE -> if문이랑 동일
/* 샘플문제1 - 프로젝트 성공으로 급여인상이 결정됨.
	사원현재 107명 19개 업무에 소속되어 근무중. 회사 업무 Distince job_id 5개 업무에서 일하는 사원.
    HR_REP(10), MK_REP(12), PR_REP(15), SA_REP(18), IT_PROG(20%) 5개 업무를 제외하고는 나머지는 동결(107개행)
*/
select employee_id
     , concat(first_name, ' ', last_name) as 'name'
     , job_id
     , salary
     , case job_id	when 'HR_REP' then salary * 1.10
					when 'MK_REP' then salary * 1.12
                    when 'PR_REP' then salary * 1.15
                    when 'SA_REP' then salary * 1.18
                    when 'IT_PROG' then salary * 1.20
                    else salary
       end as 'NewSalary'
  from employees;

/* 문제3 - 월별로 입사안 사원수가 아래와 같이 행별로 출력되도록 하시오. 12행
*/
-- 형변환 함수 cast(), convert() 
select cast('-09' as unsigned);  -- unsigned(양수만숫자형)
select convert('-09', signed);  -- signed(음수포함숫자형)
select convert(00009, char);
select convert('20250307', date);

-- 컬럼을 입사일 중 월만 추출해서 숫자로 변경
select convert(date_format(hire_date, '%m'), signed)
  from employees
 group by convert(date_format(hire_date, '%m'), signed);

-- case문 사용 1월부터 12월까지 expand
select case convert(date_format(hire_date, '%m'), signed) when 1 then count(*) else 0 end as '1월'  -- 1월 만들어서 나머지는 복사수정
     , case convert(date_format(hire_date, '%m'), signed) when 2 then count(*) else 0 end as '2월'
     , case convert(date_format(hire_date, '%m'), signed) when 3 then count(*) else 0 end as '3월'
     , case convert(date_format(hire_date, '%m'), signed) when 4 then count(*) else 0 end as '4월'
     , case convert(date_format(hire_date, '%m'), signed) when 5 then count(*) else 0 end as '5월'
     , case convert(date_format(hire_date, '%m'), signed) when 6 then count(*) else 0 end as '6월'
     , case convert(date_format(hire_date, '%m'), signed) when 7 then count(*) else 0 end as '7월'
     , case convert(date_format(hire_date, '%m'), signed) when 8 then count(*) else 0 end as '8월'
     , case convert(date_format(hire_date, '%m'), signed) when 9 then count(*) else 0 end as '9월'
     , case convert(date_format(hire_date, '%m'), signed) when 10 then count(*) else 0 end as '10월'
     , case convert(date_format(hire_date, '%m'), signed) when 11 then count(*) else 0 end as '11월'
     , case convert(date_format(hire_date, '%m'), signed) when 12 then count(*) else 0 end as '12월'     
  from employees
 group by convert(date_format(hire_date, '%m'), signed)
 order by convert(date_format(hire_date, '%m'), signed);


-- Group by 설정문제 해결
select @@sql_mode;
set session sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
/*
Error Code: 1055. 
Expression #2 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'hr.employees.hire_date' 
			which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by
*/


-- ROLLUP
/* 샘플 - 부서와 업무별 급여합계를 구하고 신년도 급여수준 레벨을 지정하려고 함.
			부서 번호와 업무를 기분으로 전해 행을 그룹별로 나누어 급여합계와 인원수를 출력(20개행)
*/
select department_id, job_id
     , concat('$', format(sum(salary), 0)) as 'Salary SUM'
     , count(employee_id) as 'COUNT EMPs'
  from employees
 group by department_id, job_id
 order by department_id;

-- 각 총계 
select department_id, job_id
     , concat('$', format(sum(salary), 0)) as 'Salary SUM'
     , count(employee_id) as 'COUNT EMPs'
  from employees
 group by department_id, job_id
  with rollup;  -- group by의 컬럼이 하나면 총계는 하나, 컬럼이 두개면 첫번째 컬럼별로 소계, 두 컬럼의 합산이 총계로

/* 문제1 - 이전문제를 활용, 집계결과가 아니면 (ALL-DEPTs)라고 출력, 업무에 대한 집계결과가 아니면(ALL-JOBs)를 출력
			rollup으로 만들어진 소계면 (ALL-JOBs), 총계면  (ALL-DEPTs)
*/
select case grouping(department_id) when 1 then '(ALL-DEPTs)' else ifnull(department_id, '부서없음') end as 'Dept#'
	 , case grouping(job_id) when 1 then '(ALL-JOBs)' else job_id end as 'Jobs'
     , concat('$', format(sum(salary), 0)) as 'Salary SUM'
     , count(employee_id) as 'COUNT EMPs'
     -- , grouping(department_id)   -- GROUP BY와 with rollup을 사용할 때 그룹핑이 어떻게 되는지 확인하는 함수
     -- , grouping(job_id)
     , format(avg(salary) * 12, 0) as 'Avg Ann_sal'
  from employees
 group by department_id, job_id
  with rollup; 

-- RANK
/* 샘플 - 분석함수 NTILE() 사용, 부서별 급여 합계를 구하시오. 급여가 제일 큰 것이 1, 제일 작은 것이 4가 되도록 등급을 나눔(12행)
*/
select department_id
     , sum(salary) as 'Sum Salary'
     , ntile (4) over (order by sum(salary) desc) as 'Bucket#'  -- 범위별로 등급 매기는 키워드
  from employees
 group by department_id;
 
/* 문제1 - 부서별 급여를 기준으로 내림차순 정렬하시오. 이때 다음 세가지 함수를 이용하여, 순위를 출력하시오(107행)
*/
select employee_id
     , last_name
     , salary
     , department_id
     , rank() over (partition by department_id order by salary desc) as 'Rank'   -- 1, 1, 3 순위매기기 rank
     , dense_rank() over (partition by department_id order by salary desc) as 'Dense_Rank'   -- 1, 1, 2 순위매기기 dense_rank
     , row_number() over (partition by department_id order by salary desc) as 'Row_Number' -- 그냥 행번호 매기기
  from employees
 order by department_id asc, salary desc;


