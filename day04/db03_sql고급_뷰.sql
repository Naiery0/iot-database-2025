-- Active: 1740616829322@@127.0.0.1@3306@madang
-- 뷰
-- DDL CREATE로 뷰를 생성

CREATE VIEW v_orders
    AS
SELECT o.orderid
     , c.custid
     , c.name
     , b.bookid
     , b.bookname
     , b.price
     , o.saleprice
     , o.orderdate
  FROM `Customer` AS c, Book AS b, Orders AS o
 WHERE c.custid = o.custid
   AND b.bookid = o.bookid;


-- 뷰 실행 - 위의 조인 쿼리
-- SQL 테이블로 할 수 있는 쿼리는 다 실행 가능 
SELECT *
  FROM v_orders
 WHERE name = '장미란';

-- 4-20 주소에 '대한민국'을 포함하는 고객들로 구성된 뷰를 만들고 조회하시오.
-- 뷰의 이름은 ww_Customer 설정합니다.
CREATE VIEW vw_Customer
    AS
SELECT *
  FROM `Customer`
 WHERE address LIKE '%대한민국%'; 

SELECT * FROM `vw_Customer`;

-- 추가, 뷰로 insert할 수 있다.. update, delete 다 가능
-- 단, 뷰의 테이블이 하나여야 한다. 관계에서 자식테이블의 뷰는 insert 불가 
INSERT INTO `vw_Customer`
VALUES (7, '손흥민', '영국 런던', '010-9999-0000');


-- 4-23 vw_Customer를 삭제하라.
DROP VIEW vw_Customer;