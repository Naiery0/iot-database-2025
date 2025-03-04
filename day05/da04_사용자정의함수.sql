bookidBook-- 사용자 정의 함수
-- 저장프로시저와 유사. RETURNS, RETURN 키워드가 차이남
-- SET GLOBAL log_bin_trust_function_creators = 1;
-- 함수 생성 에러 해결
DELIMITER //
CREATE FUNCTION fnc_Interest(
    price INTEGER
) RETURNS INTEGER
BEGIN
    DECLARE myInterest INTEGER;
    -- 가격이 3만원 이상이면 10%, 아니면 5%
    IF price >= 30000 THEN SET myInterest = price * 0.1;
    ELSE SET myInterest = price * 0.05;
    END IF;
    RETURN myInterest;
END;

SELECT custid, orderid, saleprice, fnc_Interest(saleprice) AS '이익금'
FROM `Orders`;