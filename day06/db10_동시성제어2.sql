-- 동시성 제어

START TRANSACTION;

SELECT * FROM Book;
  
UPDATE Book SET
	   price = 48000
 WHERE bookid = 98;

COMMIT;

