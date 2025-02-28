-- Active: 1740616829322@@127.0.0.1@3306@madang
-- 저장프로시저1
-- Book 테이블에 하나의 row를 추가하는 프로시저
DELIMITER //
CREATE PROCEDURE InsertBook(
    IN myBookID         INTEGER,
    IN myBookName       VARCHAR(40),
    IN myPublisher      VARCHAR(40),
    IN myPrice          INTEGER
)
BEGIN
    INSERT INTO Book (bookid, bookname, publisher, price)
    VALUES (myBookId, myBookName, myPublisher, myPrice);
END;
//

-- 프로시저 호출
CALL `InsertBook`(31, 'BTS PhotoAlbum', '하이브', 300000);

SELECT * FROM `Book`;



-- 프로시저 삭제
DROP PROCEDURE `InsertBook`;