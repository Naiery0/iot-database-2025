-- Active: 1740616829322@@127.0.0.1@3306@madang
DELIMITER //
CREATE PROCEDURE BookInsertOrUpdate (
    IN myBookID         INTEGER,
    IN myBookName       VARCHAR(40),
    IN myPublisher      VARCHAR(40),
    IN myPrice          INTEGER
)
BEGIN
    /* 변수 선언 */
    DECLARE myCount INTEGER;
    -- 1 데이터가 존재하는 수를 파악하여 myCount 변수에 할당
    SELECT COUNT(*) INTO myCount
      FROM Book
     WHERE bookname LIKE CONCAT('%', myBookName,'%'); 

    -- 2 myCount가 0보다 크면 동일 도서가 존재함
    IF myCount > 0 THEN 
        SET SQL_SAFE_UPDATES = 0; /*DELETE, UPDATE시 safe모드 해제*/
        UPDATE `Book` SET price = myPrice
         WHERE bookname LIKE CONCAT('%', myBookName,'%'); 
    ELSE
        INSERT INTO Book 
        VALUES (myBookid, myBookName, myPublisher, myPrice);
    END IF;
END;
//
-- 1번째 실행
CALL BookInsertOrUpdate(33, '스포츠의 즐거움', '마당과학', 25000);

SELECT * FROM Book;


-- 2번째 실행
CALL BookInsertOrUpdate(33, '스포츠의 즐거움', '마당과학', 35000);