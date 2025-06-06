/* ## SELECT(종합) 실습문제 - chundb ## */
use chundb;

-- 1. 학생이름과 주소지를 표시하시오. 단, 출력 헤더는 "학생 이름", "주소지"로 하고, 정렬은 이름으로 오름차순 표시하도록 한다.
/*
    학생 이름 | 주소지
    -------------------------------------------------------------------
    감현제	  | 서울강서등촌동691-3부영@102-505
    강동연	  | 경기도 의정부시 민락동 694 산들마을 대림아파트 404-1404
    강민성	  | 서울시 동작구 흑석동10 명수대 현대아파트 108-703
    강병호	  | 서울시 노원구 하계동 한신 아파트 2동417호
    강상훈	  | 전주시 덕진구 덕진동 전북대학교 식품영양학과
        ...
    황지수	  | 전주시 덕진구 인후 2가 229-36
    황진석	  | 서울시 양천구 신월5동 24-8
    황형철	  | 전남 순천시 생목동 현대ⓐ 106/407   T.061-772-2101
    황효종	  | 인천시서구 석남동 564-4번지
    --------------------------------------------------------------------
    
    588개의 행 조회
*/
SELECT
    STUDENT_NAME
    ,STUDENT_ADDRESS
FROM
    tb_student
ORDER BY
    STUDENT_NAME
;
-- 2. 휴학중인 학생들의 이름과 주민번호를 나이가 적은 순서로 화면에 출력하시오.
/*
    student_name | student_ssn
    ------------------------------
    릴희권	     | 041222-3124648
    황효종	     | 041125-3129980
    전효선	     | 041030-4176192
    김진호	     | 041013-3140536
    최이봄	     | 040916-4173437
    김혜원	     | 040723-4115944
    이경환	     | 040721-3161529
        ...
    이종대	     | 970117-1163232
    한수현	     | 970107-2116319
    최정희	     | 961215-1122553
    조기환	     | 961002-1174888
    ------------------------------
    
    91개의 행 조회
*/
SELECT
    STUDENT_NAME
    ,STUDENT_SSN
    ,DATE(LEFT(STUDENT_SSN,6))
FROM
    tb_student
WHERE
    ABSENCE_YN = 'Y'
ORDER BY
    DATE(LEFT(STUDENT_SSN,6)) DESC
;


-- 3. 주소지가 강원도나 경기도인 학생들 중 2020년대 학번을 가진 학생들의 
--    이름과 학번, 주소를 이름의 오름차순으로 화면에 출력하시오. 
--    단, 출력헤더에는 "학생이름","학번", "거주지 주소" 가 출력되도록 한다.
/*
    학생이름 | 학번    | 거주지 주소
    --------------------------------------------------------------------------
    고리나	 | A331017 | 경기도 안산시 상록구 사동 푸르지오6차 610-104
    공현준	 | A411012 | 경기남양주와부읍도곡리1012한강우성@105-601
    권병국	 | A331019 | 경기도 용인시 양지면 주북리 50-1호
    김경민	 | A513028 | 강원 원주시 신림면 황둔2리 1545번지
    김명도	 | A331083 | 경기도 기흥시 기흥구 구발동 556-3 강남큰빛유치원
    ...
    한이정	 | A551044 | 경기도 부천시 원미구 도당동274청운연립가동201호
    홍경희	 | A513119 | 경기도 광주시 퇴촌면 광동리 206 금성리버빌 101-202호
    홍용삼	 | A373039 | 경기도 성남시 분당구야탑동현대@823-1302
    황문식	 | A331388 | 경기도 안양시 동안구 호계동 985-18 2층
    --------------------------------------------------------------------------
    
    88개의 행 조회
*/
SELECT * FROM tb_student;
SELECT
    STUDENT_NAME
    , STUDENT_NO
    ,STUDENT_ADDRESS
FROM
    tb_student
WHERE
    (STUDENT_ADDRESS LIKE "경기%"
OR    STUDENT_ADDRESS LIKE "강원%")
AND   LEFT(ENTRANCE_DATE,4) BETWEEN "2020" AND "2029"
;




-- 4. 현재 법학과 교수 중 가장 나이가 많은 사람부터 이름을 확인할 수 있는 SQL 문장을 작성하시오.
-- (법학과의 '학과 코드'는 학과 테이블을 조회해서 찾아 내도록 하자)
/*
    professor_name | professor_ssn
    ---------------------------------
    홍남수	       | 540304-1112251
    김선희	       | 551030-2159000
    임진숙	       | 640125-1143548
    이미경	       | 741016-2103506
    ---------------------------------
    
    4개의 행 조회
*/
SELECT
    PROFESSOR_NAME
    ,PROFESSOR_SSN
FROM
    tb_professor
WHERE
    DEPARTMENT_NO = (SELECT DEPARTMENT_NO FROM tb_department WHERE DEPARTMENT_NAME = "법학과")
ORDER BY
    DATE(LEFT(PROFESSOR_SSN,6)) DESC
;


-- 5. 2022년 2학기에 'C3118100' 과목을 수강한 학생들의 학점을 조회하려고 한다. 
--    학점이 높은 학생부터 표시하고, 학점이 같으면 학번이 낮은 학생부터 표시하는 구문을 작성해보시오.
/*
    STUDENT_NO | POINT
    --------------------
    A331076    | 4.50
    A213128    | 4.00
    A219089    | 1.50
    --------------------
    
    3개의 행 조회
*/
SELECT
    STUDENT_NO
    ,POINT
FROM
    tb_grade
WHERE
    LEFT(TERM_NO,4) = 2022
AND SUBSTRING(TERM_NO,5,2) = 2
AND CLASS_NO = "C3118100"
ORDER BY
    POINT DESC
    , STUDENT_NO
;

SELECT
    s.STUDENT_NO
    ,g.POINT
FROM
    tb_student s
     JOIN tb_grade g ON g.STUDENT_NO = s.STUDENT_NO
WHERE
    g.CLASS_NO = "C3118100"
AND LEFT(g.TERM_NO,4) = 2022
AND SUBSTRING(g.TERM_NO,5,2) = 2
ORDER BY
    POINT DESC
    , s.STUDENT_NO
;


 
-- 6. 학생 번호, 학생 이름, 학과 이름을 학생 이름으로 오름차순 정렬하여 출력하는 SQL 문을 작성하시오.
/*
    student_no | student_name | department_name
    --------------------------------------------
    A411001    | 감현제	      | 치의학과
    A131004	   | 강동연	      | 디자인학과
    A9931003	 | 강민성	      | 치의학과
    A431010	   | 강병호	      | 임상약학과
    A531005	   | 강상훈	      | 디자인학과
    A417005	   | 강승우	      | 국어국문학과
    A517002	   | 강승주	      | 한의학과
        ...
    A615246	   | 황진석	      | 행정학과
    A411335	   | 황형철	      | 사회학과
    A511332	   | 황효종	      | 컴퓨터공학과
    --------------------------------------------
    
    588개의 행 조회
*/
SELECT
    STUDENT_NO
    ,STUDENT_NAME
    ,(SELECT DEPARTMENT_NAME FROM tb_department WHERE DEPARTMENT_NO = s.DEPARTMENT_NO)
FROM
    tb_student s
ORDER BY
    STUDENT_NAME
;



-- 7. 춘 기술대학교의 과목 이름과 과목의 학과 이름을 출력하는 SQL 문장을 작성하시오.
/*
    class_name          | department_name
    --------------------------------------
    가족상담과 정신간호	| 간호학과
    가족상담실습	    | 간호학과
    간호이론	        | 간호학과
    간호정보학	        | 간호학과
    간호현상과질적연구	| 간호학과
    건강행위론	        | 간호학과
        ...
    논문지도2	        | 회계학과
    소득세회계이론	    | 회계학과
    자본시장회계연구	| 회계학과
    회계학연구방법론1	| 회계학과
    --------------------------------------
    
    882개의 행 조회
*/
SELECT
    CLASS_NAME
    ,(SELECT DEPARTMENT_NAME FROM tb_department WHERE DEPARTMENT_NO = c.DEPARTMENT_NO) AS department_name
FROM
    tb_class c
ORDER BY
    department_name
    ,CLASS_NAME
;




-- 8. 과목별 교수 이름을 찾으려고 한다. 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오.
/*
    class_name                    | professor_name
    ------------------------------------------------
    논문지도(공개발표)3	          | 강용진
    논문지도1	                  | 강용진
    동양무용사	                  | 강용진
    발레워크샵	                  | 강용진
        ...
    신기술 세미나	              | 황헌중
    인터넷마케팅	              | 황헌중
    지식경영과 비지니스 인텔리전스| 황헌중
    -------------------------------------------------
    
    776개의 행 조회
*/
SELECT * FROM tb_class;
SELECT * FROM tb_professor;
SELECT * FROM tb_class_professor;
SELECT
    CLASS_NAME
    ,PROFESSOR_NAME
FROM 
    tb_class c
        JOIN tb_class_professor cp ON cp.CLASS_NO = c.CLASS_NO
        JOIN tb_professor p ON p.PROFESSOR_NO = cp.PROFESSOR_NO
ORDER BY
    PROFESSOR_NAME
    ,CLASS_NAME
;





-- 9. 8 번의 결과 중 ‘인문사회’ 계열에 속한 과목의 교수 이름을 찾으려고 한다. 
--    이에 해당하는 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오.
/*
    class_name                    | professor_name
    -----------------------------------------------
    논문지도(공개발표)3	          | 강혁
    논문지도1	                  | 강혁
    논문지도2	                  | 강혁
    신기술 세미나	              | 강혁
    인사조직행동 특별연구	      | 강혁
    인터넷마케팅	              | 강혁
    논문지도(공개발표)3	          | 권귀빈
        ...
    신기술 세미나	              | 황헌중
    인터넷마케팅	              | 황헌중
    지식경영과 비지니스 인텔리전스|	황헌중
    ------------------------------------------------
    
    197개의 행 조회
*/
SELECT * FROM tb_class;
SELECT * FROM tb_professor;
SELECT * FROM tb_class_professor;
SELECT * FROM tb_department;


SELECT
    CLASS_NAME
    , PROFESSOR_NAME
FROM
    tb_class c
        JOIN tb_class_professor cp ON cp.CLASS_NO = c.CLASS_NO
        JOIN tb_professor p ON p.PROFESSOR_NO = cp.PROFESSOR_NO
WHERE
    c.DEPARTMENT_NO IN (SELECT DEPARTMENT_NO FROM tb_department WHERE CATEGORY = "인문사회")
ORDER BY
    PROFESSOR_NAME
    ,CLASS_NAME
;




-- 10. ‘음악학과’ 학생들의 평점을 구하려고 한다. 음악학과 학생들의 "학번", "학생 이름", "전체 평점"을 출력하는 SQL 문장을 작성하시오. 
--     (단, 평점은 소수점 1 자리까지만 반올림하여 표시한다.)
/*
    학번      | 학생 이름 | 학점
    ------------------------------
    A612052	  | 신광현	  | 4.5
    A9931310	| 조기현	  | 4.1
    A431021	  | 구병훈	  | 3.9
    A431358	  | 조상진	  | 3.6
    A354020	  | 양재영	  | 3.5
    A411116	  | 박현화	  | 3.5
    A415245	  | 조지선	  | 3.1
    A557031	  | 이정범	  | 2.8
    ------------------------------
    
    8개의 행 조회
    
*/
SELECT * FROM tb_student;
SELECT * FROM tb_class;
SELECT * FROM tb_professor;
SELECT * FROM tb_class_professor;
SELECT * FROM tb_department;

SELECT
    s.STUDENT_NO
    ,s.STUDENT_NAME
    ,FORMAT(AVG(g.POINT),1) AS 학점
FROM
    tb_student s
        JOIN tb_grade g ON g.STUDENT_NO = s.STUDENT_NO
    /*
    tb_grade g
        JOIN tb_student s ON s.STUDENT_NO = g.STUDENT_NO    FROM절의 데이터의 주체도 고민해야됨
    */
    
WHERE
    s.DEPARTMENT_NO = (SELECT DEPARTMENT_NO FROM tb_department WHERE DEPARTMENT_NAME = "음악학과")
GROUP BY
    STUDENT_NO
ORDER BY
    학점 DESC
;



-- 11. 학번이 `A313047` 인 학생이 학교에 나오고 있지 않다. 
--     지도 교수에게 내용을 전달하기 위한 학과 이름, 학생 이름과 지도 교수 이름이 필요하다. 
--     이때 사용할 SQL 문을 작성하시오. 
--     단, 출력헤더는 ‚’학과이름‛, ‚학생이름‛, ‚지도교수이름‛으로 출력되도록 한다.
/*
    학과이름    | 학생이름 | 지도교수이름
    --------------------------------------
    경제학과	| 손건영   | 박태환
    --------------------------------------
*/
SELECT
    (SELECT DEPARTMENT_NAME FROM tb_department WHERE DEPARTMENT_NO = s.DEPARTMENT_NO)
    ,STUDENT_NAME
    ,(SELECT PROFESSOR_NAME FROM tb_professor WHERE PROFESSOR_NO = s.COACH_PROFESSOR_NO)
FROM
    tb_student s
WHERE
    STUDENT_NO = "A313047"
;


-- 12. 2022년도에 '인간관계론' 과목을 수강한 학생을 찾아 학생이름과 수강학기를 표시하는 SQL 문장을 작성하시오
/*
    student_name | term_no
    -------------------------
    최지현	     | 202201
    -------------------------
*/
SELECT
	(SELECT STUDENT_NAME FROM tb_student WHERE g.STUDENT_NO = STUDENT_NO)
    , TERM_NO
FROM
	tb_grade g
WHERE
	LEFT(TERM_NO,4) = 2022
AND g.CLASS_NO = (SELECT CLASS_NO FROM tb_class WHERE CLASS_NAME = "인간관계론")
;


-- 13. 예체능 계열 과목 중 과목 담당교수를 한명도 배정받지 못한 과목을 찾아 그 과목 이름과 학과 이름을 출력하는 SQL 문장을 작성하시오.
/*
    class_name          | department_name
    ----------------------------------------
    논문지도1	        | 공연예술학과
    무용기능학	        | 공연예술학과
    논문지도2	        | 도예학과
    도예기법연구	    | 도예학과
    공예창작연구	    | 디자인학과
    기업이미지디자인연구  | 디자인학과
        ..
    사회조사분석론	    | 체육학과
    스포츠산업연구	    | 체육학과
    운동처방연구	    | 체육학과
    해부학실험	        | 체육학과   
    ----------------------------------------
    
    44개의 행 조회
*/
SELECT
	CLASS_NAME
    ,(SELECT DEPARTMENT_NAME FROM tb_department WHERE DEPARTMENT_NO = c.DEPARTMENT_NO) AS department_name
FROM
	tb_class c
WHERE
	c.DEPARTMENT_NO IN (SELECT DEPARTMENT_NO FROM tb_department WHERE CATEGORY = "예체능")
AND NOT EXISTS (SELECT PROFESSOR_NO FROM tb_class_professor WHERE CLASS_NO = c.CLASS_NO)  # IS NULL하면 안됨, 결과같이 1행 이상이기 때문에
;

    
SELECT
	CLASS_NAME
    ,(SELECT DEPARTMENT_NAME FROM tb_department WHERE DEPARTMENT_NO = c.DEPARTMENT_NO) AS department_name
FROM
	tb_class c
     LEFT JOIN tb_class_professor cp ON cp.CLASS_NO = c.CLASS_NO # null을포함하여 조인
WHERE
	c.DEPARTMENT_NO IN (SELECT DEPARTMENT_NO FROM tb_department WHERE CATEGORY = "예체능")
AND cp.PROFESSOR_NO IS NULL; # 찾아진 교수의 이름이 존재하지 않을 경우(CLASS_NO로 해도 됨)
;
    
    
    
-- SELECT
-- 	CLASS_NAME
--     ,(SELECT DEPARTMENT_NAME FROM tb_department WHERE DEPARTMENT_NO = c.DEPARTMENT_NO) AS department_name
-- FROM
-- 	tb_class c
-- 	JOIN tb_class_professor cp ON cp.CLASS_NO = c.CLASS_NO # left를 빼면
-- WHERE
-- 	c.DEPARTMENT_NO IN (SELECT DEPARTMENT_NO FROM tb_department WHERE CATEGORY = "예체능")
-- AND cp.PROFESSOR_NO IS NULL # ISNULL인 경우가 없기 때문에 0row다.
-- ; 
    
    
    
    

    
-- 14. 춘 기술대학교 서반아어학과 학생들의 지도교수를 게시하고자 한다. 
--     학생이름과 지도교수 이름을 찾고 만일 지도 교수가 없는 학생일 경우 "지도교수 미지정”으로 표시하도록 하는 SQL 문을 작성하시오.
--     단, 출력헤더는 “학생이름”, “지도교수”로 표시하며 고학번 학생이 먼저 표시되도록 한다.
/*
    학생이름 | 지도교수
    --------------------------
    주하나	 | 허문표
    이희진	 | 남명길
    박철웅	 | 김선정
    박현민	 | 신원하
    박승우	 | 홍부철
    김정열	 | 박태환
    김현철	 | 지도교수 미지정
    성형규	 | 김영주
    민정규	 | 한은수
    이용태	 | 이경석
    김경륜	 | 이협수
    박석희	 | 장윤실
    김정현	 | 박준호
    최철현	 | 백양임
    ---------------------------
    
    14개의 행 조회
*/

select * from tb_student;
select * from tb_department;



select
	 STUDENT_NAME
     ,case
		when COACH_PROFESSOR_NO is not null then (select PROFESSOR_NAME from tb_professor where PROFESSOR_NO = COACH_PROFESSOR_NO)
		else "지도교수 미지정"
	end as 지도
from
	tb_student 
where
	DEPARTMENT_NO = (select DEPARTMENT_NO from tb_department where  DEPARTMENT_NAME = "서반아어학과")
order by
	date(ENTRANCE_DATE)
;



select
	STUDENT_NAME
    , case
		when PROFESSOR_NAME is not null then PROFESSOR_NAME
        else "지도교수 미지정"
	end as 지도
from
	tb_student s
     left join tb_professor p on PROFESSOR_NO = COACH_PROFESSOR_NO
     join tb_department d on d.DEPARTMENT_NO = s.DEPARTMENT_NO
where
	DEPARTMENT_NAME = "서반아어학과"
;




-- 15. 휴학생이 아닌 학생 중 평점이 4.0 이상인 학생을 찾아 그 학생의 학번, 이름, 학과 이름, 평점을 출력하는 SQL 문을 작성하시오.
--     평점순으로 내림차순 정렬하여 조회하시오.
/*
    학번      | 이름    | 학과 이름      | 평점
    -------------------------------------------
    A612052	  | 신광현	| 음악학과       | 4.50
    A631380	  | 한민우	| 사회학과       | 4.50
    A671040	  | 전정호	| 정치학과       | 4.50
    A674033	  | 최세정	| 환경응용과학과 | 4.50
    A517020	  | 김승진	| 식품영양학과   | 4.40
    A641040	  | 안희근	| 기계공학과     | 4.33
        ...
    A431347	  | 정상우	| 한의학과       | 4.00
    A9817035  | 김소라	| 토목공학과     | 4.00
    A531128	  | 박선아	| 중어중문학과   | 4.00
    -------------------------------------------
    
    38개의 행 조회
*/
select
    s.STUDENT_NAME
    ,(select DEPARTMENT_NAME from tb_department where DEPARTMENT_NO = s.DEPARTMENT_NO)
    ,avg(g.POINT) as 평점
from
	tb_student s
		join tb_grade g on g.STUDENT_NO = s.STUDENT_NO
where
	ABSENCE_YN = 'N'
group by
	s.STUDENT_NO
having 
	평점  >= 4
;






-- 16. 환경조경학과 전공과목들의 과목 별 평점을 파악할 수 있는 SQL 문을 작성하시오.
/*
    class_no    | class_name              | 평점
    -------------------------------------------------
    C3016200	| 전통계승방법론	      | 3.350000
    C3081300	| 조경계획방법론	      | 3.722222
    C3087400	| 조경세미나	          | 3.888888
    C4139300	| 환경보전및관리특론      | 2.777777
    C4477600	| 조경시학	              | 3.083333
    C5009300	| 단지계획및설계스튜디오  | 3.357142
    -------------------------------------------------
*/
select * from tb_class;
select * from tb_grade;

select
	CLASS_NO
    ,CLASS_NAME
    ,(select avg(POINT)
		from tb_grade
        where CLASS_NO = c.CLASS_NO) # tb_grade 테이블에 해당 CLASS_NO이 전혀 존재하지 않는 경우 null이 반환된다.
from
	tb_class c
where
	(select avg(POINT)
		from tb_grade
        where CLASS_NO = c.CLASS_NO) is not null
and c.DEPARTMENT_NO = (select DEPARTMENT_NO from tb_department where DEPARTMENT_NAME = "환경조경학과")
and c.CLASS_TYPE like "전공%"
;




select
	c.CLASS_NO
    ,c.CLASS_NAME
    ,avg(POINT)
from
	tb_class c
		join tb_grade g on g.CLASS_NO = c.CLASS_NO
where
	c.DEPARTMENT_NO = (select DEPARTMENT_NO from tb_department where DEPARTMENT_NAME = "환경조경학과")
and c.CLASS_TYPE like "전공%"
group by 
	CLASS_NO
;









-- 17. 춘 기술대학교에 다니고 있는 최경희 학생과 같은과 학생들의 이름과 주소를 출력하는 SQL 문을 작성하시오. (이름 오름차순)
/*
    student_name | student_address
    -----------------------------------------------------------------------------
    기혜미	     | 대전시 유성구 덕진동 한국원자력안전기술원 행정부장   T.042-863-2820
    김석민	     | 경기도안산시상록구2동664번지투루지오2차@205/601
    김지원	     | 전주시 완산구 중화산동 1가 동신@ 702호
    김태원	     | 전주시 완산구 효자동1가 505-3 삼호ⓐ 3동 706호
    김희훈	     | 인천시 부평구 십정 1동 323- 19호
        ...
    조재성	     | 
    최경희	     | 대구광역시 달서구 월성동 277-3 동서타운아파트 101-1403호
    최동균	     | 서울시 강서구 화곡3동 푸르지오아파트 109-1003호
    -----------------------------------------------------------------------------
    
    17개의 행 조회
*/

select
	STUDENT_NAME
    ,STUDENT_ADDRESS
from
	tb_student
where
	DEPARTMENT_NO = (select DEPARTMENT_NO from tb_department 
								where DEPARTMENT_NO = (select DEPARTMENT_NO from tb_student where STUDENT_NAME = "최경희"))
order by
	STUDENT_NAME
;


select
	STUDENT_NAME
    ,STUDENT_ADDRESS
from
	tb_student s
		join tb_department d on  d.DEPARTMENT_NO = s.DEPARTMENT_NO
where
	s.DEPARTMENT_NO = (select DEPARTMENT_NO from tb_student where STUDENT_NAME = "최경희" limit 1 ) # 이건 어쨋든 서브쿼리로 작성해야되네
order by
	STUDENT_NAME
;




-- 18. 국어국문학과에서 총 평점이 가장 높은 학생의 이름과 학번을 표시하는 SQL 문을 작성하시오.
/*
    STUDENT_NO | STUDENT_NAME
    -------------------------
    A9931165	   | 송근우
    -------------------------
*/

select
	s.STUDENT_NO
    ,s.STUDENT_NAME
from
	tb_student s
		join tb_department d on d.DEPARTMENT_NO = s.DEPARTMENT_NO
        join tb_grade g on g.STUDENT_NO = s.STUDENT_NO
where
	d.DEPARTMENT_NAME = "국어국문학과"
group by
	s.STUDENT_NO, s.STUDENT_NAME # 집계하려고 하지 않는 컬럼을 모두 넣어 모든 값을 출력한다.
order by
	avg(g.POINT) desc
limit
	1
;
    
    
    
-- 19. 춘 기술대학교의 "환경조경학과"가 속한 같은 계열 학과들의 학과 별 전공과목 평점을 파악하기 위한 적절한 SQL 문을 찾아내시오.
--     단, 출력헤더는 "계열 학과명", "전공평점"으로 표시되도록 하고, 평점은 소수점 한 자리까지만 반올림하여 표시되도록 한다.
/*
    계열 학과명      | 전공평점
    ----------------------------
    간호학과	     | 3.2
    물리학과	     | 3.3
    생명공학원	     | 3.2
    생물학과	     | 3.4
    생태시스템공학과 | 3.5
        ...
    화학과	         | 3.1
    환경응용과학과	 | 3.6
    환경조경학과	 | 3.3
    ----------------------------
    
    20개의 행 조회
*/
select * from tb_grade;
select * from tb_department;


select
	d.DEPARTMENT_NAME
    ,format(avg(POINT),1)
from
	tb_department d
		join tb_student s on s.DEPARTMENT_NO = d.DEPARTMENT_NO
        join tb_grade g on g.STUDENT_NO = s.STUDENT_NO
where
 	d.CATEGORY = (select CATEGORY from tb_department where DEPARTMENT_NAME = "환경조경학과")
group by
	d.DEPARTMENT_NAME
order by
	d.DEPARTMENT_NAME
;








# 환경경학과 카테고리의류를 having절에 넣은 이유는 학과별로 나눠진 tb_department테이블에 컬럼으로 CATcEGORY이 있으니까 분류가 가능할 줄 알았다.
# 헌데 group by-having절로 적용하기 위해서는 그룹바이에 포감된 컬럼이나 집계함수의 결과만 사용할 수 있다\
# 그래서 만약 카테고리 컬럼을 select에 추가한다면 having절로 자연과학 데이터를 분별해낼 수 있
select
	d.DEPARTMENT_NAME
    ,avg(POINT)
    ,d.CATEGORY
from
	tb_department d
		join tb_student s on s.DEPARTMENT_NO = d.DEPARTMENT_NO
        join tb_grade g on g.STUDENT_NO = s.STUDENT_NO
-- where
-- 	d.CATEGORY = (select CATEGORY from tb_department where DEPARTMENT_NAME = "환경조경학과")
group by
	d.DEPARTMENT_NAME
 having
 	 d.CATEGORY = (select CATEGORY from tb_department where DEPARTMENT_NAME = "환경조경학과")
;











