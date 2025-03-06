-- 기존 테이블 삭제
DROP TABLE IF exists NewBook;

-- 새 테이블 생성
CREATE Table NewBook(
    bookid INT AUTO_INCREMENT PRIMARY KEY,
    bookname VARCHAR(100),
    publisher VARCHAR(100),
    price INT
);

-- 500만 건 더미데이터 생성 설정
SET session cte_max_recursion_depth = 5000000;

-- 더미데이터 생성
INSERT INTO NewBook (bookname, publisher, price)
WITH RECURSIVE cte (n) as
(
    SELECT 1
    union all
    select n+1 from cte where n < 5000000
)
SELECT CONCAT('Book', LPAD(n, 7, '0')) -- book0000001
     , CONCAT('Comp', LPAD(n, 7, '0'))
     , FLOOR(3000 + rand() * 30000) as price -- 책가격
  FROM cte;   


-- select count(*) from `NewBook`
--  WHERE price BETWEEN 20000 and 25000;
select count(*) from `NewBook`
 WHERE price in (8377, 14567, 24500, 33000, 5600, 6700, 15000);

-- 인덱스 생성
CREATE INDEX idx_book on NewBook(price);