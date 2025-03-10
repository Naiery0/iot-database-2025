-- bookstbl
select * from bookstbl;

-- bivtbl
select * from divtbl;

-- membertbl
select * from membertbl;

-- rentabltbl
select * from rentaltbl;


-- 문제 1번
SELECT Email, Mobile, Names, Addr
  FROM membertbl;
  
-- 문제 2번
SELECT NAMES AS '도서명'
     , Author AS '저자'
     , ISBN
     , Price AS '정가'
  FROM bookstbl
 ORDER BY ISBN;
 
-- 문제 3번
SELECT m.names AS '비대여자명'
     , m.Levels AS '등급'
     , m.Addr AS '주소'
     , r.rentalDate AS '대여일'
  FROM membertbl AS m LEFT JOIN rentaltbl AS r
    ON m.Idx = r.memberIdx
 WHERE m.Idx NOT IN (SELECT r.memberIdx FROM rentaltbl AS r)
 ORDER BY m.Levels, m.Names;
 
-- 문제 4번
SELECT CASE GROUPING(d.Names) WHEN 1 THEN '--합계--' ELSE ifnull(d.Division, '장르없음') END AS '장르' 
     , CONCAT(FORMAT(SUM(b.price), 0), '원')
  FROM divtbl AS d, bookstbl AS b
 WHERE d.Division = b.Division
 GROUP BY d.Names
  WITH ROLLUP;
  