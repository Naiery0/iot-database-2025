-- Active: 1740616829322@@127.0.0.1@3306@madang
-- 인덱스
-- DDL로 인덱스 생성

-- 4-24 Book 테이블의 bookname에 인텍스 ix_book을 생성하시오
CREATE INDEX ix_Book ON Book(bookname);

-- 4-25 Book 테이블에 publisher, price를 인덱스 ix_Book2 생성하시오
CREATE INDEX ix_Book2 on Book(publisher, price)

-- 추가
SHOW INDEX FROM `Book`;

-- 인덱스가 제대로 동작하나
-- 실행계획(Explain Current Statement) - 인덱스나 조인 등에서 쿼리 중 어디에서 가장 처리비용이 많이 발생하는지
SELECT *
  FROM `Book`
 WHERE publisher = '대한미디어'
   AND price >= 30000;

-- 4-26 Book테이블 인덱스를 최적화하시오.
ANALYZE TABLE Book;

-- 4-27 쓸모없는 인덱스 삭제
DROP INDEX ix_Book2 ON Book;