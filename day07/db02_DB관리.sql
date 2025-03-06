-- 데이터베이스 관리
show databases;
-- information_schema, performance_schema, mysql 등은 시스템 매라서 개발지,DRA 사용하는 게 아님
use madang;
-- 하나의 DB내 존재하는 테이블을 확인
show tables;
-- 테이블의 구조
desc madang. NewBook;
select * from v_orders;

-- 사용자 추가
-- madang 데이터베이스만 접근할 수 있는 사용자 madang 생성
-- 내부접속용
create user madang@localhost identified by 'madang';
-- 외부접속용
create user madang@'%' identified by 'madang';

-- DCL: grant, revoke
-- 데이터 삽입, 조회, 수정 권한만 부여
GRANT select, insert, UPDATE on madang.* to madang@localhost with grant option;
GRANT select, insert, UPDATE on madang.* to madang@'%' with grant option;
flush privileges;

-- 사용자 madang에게 madang DB를 사용할 수 있는 모든 권한 부여
GRANT ALL on madang.* to madang@localhost with grant option;
GRANT ALL on madang.* to madang@'%' with grant option;
flush privileges;

-- 권한해제
-- madang 사용자의 권한 중 select 권한만 제거
revoke SELECT on madang.* from madang@localhost;
revoke all PRIVILEGES on madang.* from madang@localhost;
