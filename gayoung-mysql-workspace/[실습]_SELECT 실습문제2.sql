/* ## SELECT(Basic) 실습문제 - chundb ## */
use chundb;

-- 아래의 select문들을 실행하여 각 테이블에 어떤 컬럼과 어떤 데이터가 담겨있는지 파악하고 진행하시오.
SELECT * FROM tb_department;      -- 학과
SELECT * FROM tb_student;         -- 학생
SELECT * FROM tb_professor;       -- 교수
SELECT * FROM tb_class;           -- 과목
SELECT * FROM tb_class_professor; -- 과목별교수 
SELECT * FROM tb_grade;           -- 성적

-- 1. 춘 기술대학교의 학과 이름과 계열을 표시하시오. 단, 출력 헤더는 "학과 명", "계열"으로 표시하도록 한다.
SELECT 
    DEPARTMENT_NAME '학과 명'
  , CATEGORY 계열
FROM 
    tb_department;

-- 2. 학생이름과 주소지를 표시하시오. 단, 출력 헤더는 "학생 이름", "주소지"로 하고, 
--    정렬은 이름으로 오름차순 표시하도록 한다.

SELECT
    STUDENT_NAME AS "학생 이름"
  , STUDENT_ADDRESS AS 주소지
FROM tb_student
ORDER BY STUDENT_NAME;

-- 3. 학과의 학과 정원을 다음과 같은 형태로 화면에 출력한다.
SELECT 
    CONCAT(DEPARTMENT_NAME, '의 정원은 ', CAPACITY, '명 입니다.')
FROM 
    tb_department
;


-- 4. 도서관에서 대출 도서 장기 연체자들을 찾아 이름을 게시하고자 한다. 
--    그 대상자들의 학번이 다음과 같을 때 대상자들을 찾는 적절한 sql 구문을 작성하시오.
--    A513079, A513090, A513091, A513110, A513119
SELECT 
    STUDENT_NAME
FROM 
    tb_student
WHERE
    STUDENT_NO IN ('A513079', 'A513090', 'A513091', 'A513110', 'A513119')
ORDER BY
    STUDENT_NAME DESC
;


-- 5. 입학정원이 20 명 이상 30 명 이하인 학과들의 학과 이름과 계열을 출력하시오.
SELECT
    DEPARTMENT_NAME
  , CATEGORY
FROM 
    tb_department
WHERE
    CAPACITY BETWEEN 20 AND 30
;

-- 7. 혹시 전산상의 착오로 학과가 지정되어 있지 않은 학생이 있는지 확인하고자 한다.
--    어떠한 sql 문장을 사용하면 될 것인지 작성하시오.

SELECT
    *
FROM
    tb_student
WHERE ISNULL(DEPARTMENT_NO);

-- 8. 수강신청을 하려고 한다. 선수과목 여부를 확인해야 하는데, 선수과목이 존재하는
--    과목들은 어떤 과목인지 과목번호를 조회해보시오.
SELECT 
    CLASS_NO
FROM
    tb_class
WHERE 
     NOT ISNULL(PREATTENDING_CLASS_NO);

-- 9. 춘 대학에는 어떤 계열(category)들이 있는지 조회해보시오.
SELECT DISTINCT
    CATEGORY
FROM
    tb_department
;

-- 10. 19 학번 전주 거주자들의 모임을 만들려고 한다. 휴학한 사람들은 제외하고, 재학중인 학생들의 
--     학번, 이름, 주민번호를 출력하는 구문을 작성하시오.

SELECT 
    STUDENT_NO
  , STUDENT_NAME
  , STUDENT_SSN
FROM
    tb_student
WHERE
    STUDENT_ADDRESS LIKE ('전주%')
    AND ABSENCE_YN = 'N'
    AND ENTRANCE_DATE LIKE ('2017%')
;
    

