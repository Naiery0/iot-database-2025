-- 08 트랜잭션
-- 테이블 생성
CREATE TABLE Bank (
    name VARCHAR(40) PRIMARY KEY,
    balance INT
);

-- 데이터 추가
INSERT INTO Bank VALUES ('박지성', 1000000), ('김연아', 1000000);

-- 트랜잭션은 업무 논리적 단위(All or Nothing)
-- START TRTANSACTION; 
-- 성공 시, COMMIT; | 실패 시, ROLLBACK;
START TRANSACTION;
-- 박지성 계좌를 읽어온다
SELECT * FROM `Bank` WHERE name = '박지성';
-- 김연아 계좌를 읽어온다
SELECT * FROM `Bank` WHERE name = '김연아';

-- 박지성 계좌에서 10000원 인출
UPDATE `Bank` SET
       balance = balance - 10000
 WHERE name = '박지성';

UPDATE `Bank` SET
       balance = balance + 10000
 WHERE name = '김연아';

-- 트랜잭션 종료
COMMIT;
ROLLBACK;
