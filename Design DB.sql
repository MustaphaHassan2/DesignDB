-- Creating table with constrains, volumn level syntacs
CREATE TABLE xx_emp_col_const
( emp_id NUMBER constraint xx_emp_col_const_pk PRIMARY KEY,
  ename VARCHAR2 (100) constraint xx_emp_col_cost_uk1 UNIQUE,
  salary NUMBER not null,
  gender CHAR (1) constraint xx_emp_col_const_chq CHECK ( gender IN ('M', 'F')),
  dept_id NUMBER constraint xx_emp_col_const_fk1 REFERENCES departments (department_id)
 );
commit;

SELECT * FROM user_constraints
WHERE table_name = 'XX_EMP_COL_CONST';

INSERT INTO xx_emp_col_const (emp_id, ename, salary, gender, dept_id)
VALUES     (1, 'Hend', 7500, 'F', NULL);

SELECT * FROM xx_emp_col_const;

INSERT INTO xx_emp_col_const (emp_id, ename, salary, gender, dept_id)
VALUES     (1, 'Hend', 7500, 'R', NULL); -- the gender must follow the check ('M', 'F')

-- Creating table in table level syntacs
-- You can use 2 PKs
CREATE TABLE xx_emp_col_const1
 (emp_id1 NUMBER,
  emp_id2 NUMBER,
  ename VARCHAR2 (100),
  salary NUMBER not null,
  gender CHAR (1), 
  dept_id NUMBER, 
  constraint xx_emp_col_const1_pk PRIMARY KEY (emp_id1, emp_id2),
  constraint xx_emp_col_const1_uk1 UNIQUE (ename),
  constraint xx_emp_col_const1_chq CHECK ( gender IN ('M', 'F')),
  constraint xx_emp_col_const1_fk1 foreign key (dept_id) REFERENCES departments (department_id)
 );
commit;

-- ON DELETE CASCADE
CREATE TABLE dept1
(deptno NUMBER,
dname VARCHAR2 (100),
constraint dept1_pk primary key (deptno)
);

INSERT INTO dept1 (deptno, dname)
VALUES            (1,      'HR');
INSERT INTO dept1 (deptno, dname)
VALUES            (2,      'PO');

SELECT * FROM dept1;

CREATE TABLE emp1
(emp_id NUMBER primary key,
ename VARCHAR2 (100),
deptno NUMBER,
CONSTRAINT emp1_fk1 foreign key (deptno) REFERENCES dept1 (deptno) ON DELETE CASCADE
);

INSERT INTO emp1 VALUES (1, 'Ali', 1);
INSERT INTO emp1 VALUES (2, 'Ola', 2);
INSERT INTO emp1 VALUES (3, 'Mostafa', 1);
INSERT INTO emp1 VALUES (4, 'Hoda', 1);
INSERT INTO emp1 VALUES (5, 'Ghada', 2)

SELECT * FROM emp1

SELECT * FROM dept1
WHERE deptno = 1;

-- ON DELETE SET NULL
CREATE TABLE dept2
(deptno NUMBER,
dname VARCHAR2 (100),
constraint dept2_pk primary key (deptno)
);

INSERT INTO dept2 (deptno, dname)
VALUES            (1,      'HR dept');
INSERT INTO dept2 (deptno, dname)
VALUES            (2,      'PO dept');


CREATE TABLE emp2
(emp_id NUMBER primary key,
ename VARCHAR2 (100),
deptno NUMBER,
CONSTRAINT emp2_fk1 foreign key (deptno) REFERENCES dept1 (deptno) ON DELETE set null
);

INSERT INTO emp2 VALUES (1, 'Ali', 1);
INSERT INTO emp2 VALUES (2, 'Ola', 2);
INSERT INTO emp2 VALUES (3, 'Mostafa', 1);
INSERT INTO emp2 VALUES (4, 'Hoda', 1);
INSERT INTO emp2 VALUES (5, 'Ghada', 2);

DELETE FROM dept2
WHERE deptno = 1;

SELECT * FROM emp2;


-- Creating table as a subquery
CREATE TABLE e_emp
AS SELECT employee_id, first_name, last_name, salary, department_id
FROM employees
WHERE department_id = 90;

DESC e_emp;

SELECT * FROM e_emp;

CREATE TABLE e_emp2 (emp_id, fname, lname, sal default 0, dept_id)
AS SELECT employee_id, first_name, last_name, salary, department_id
FROM employees
WHERE department_id = 90;

DESC e_emp2;

SELECT * FROM e_emp2;

INSERT INTO e_emp2 VALUES (401, 'Hend', 'Mamdouh', 7950, 90);

-- Using alter to add a column
ALTER TABLE e_emp
ADD (Gender char(1) );

ALTER TABLE e_emp
ADD (commesion NUMBER default 0 not null);

ALTER TABLE e_emp
ADD (Gender2 char(1) default 'M' not null);

ALTER TABLE e_emp
ADD (Gender3 char(2) default 'MF' not null);

-- A dding 2 columms or more
ALTER TABLE e_emp
ADD (created_date DATE default sysdate not null, created_user VARCHAR2 (100) default user not null);

SELECT * FROM e_emp;

-- Using alter to modify a table
ALTER TABLE e_emp
MODIFY (created_user VARCHAR (50) );

DESC e_emp;

UPDATE e_emp
SET gender = 'M';

ALTER TABLE e_emp
MODIFY (gender number); -- YOU CAN NOT CHANGE THE DATATYPE FROM VARCHAR TO NUMBER BECAUSE IT IS NOT EMPATY

-- but you can change from char to varchar2 because they are the same datatype
ALTER TABLE e_emp
MODIFY (gender char (15));

-- You can not change to be smaller
ALTER TABLE e_emp
MODIFY (gender varchar2 (10));

-- Dropping a column
ALTER TABLE e_emp
DROP COLUMN gender2;

SELECT * FROM e_emp;

ALTER TABLE e_emp
DROP (commesion, created_user) ;

commit;

ALTER TABLE e_emp2
SET UNUSED (SAL);

SELECT * FROM E_EMP2

SELECT * FROM USER_UNUSED_COL_TABS;

UPDATE E_EMP2
SET SAL = 100; -- NO, YOU CAN NOT

ALTER TABLE e_emp2
SET UNUSED (fname);

SELECT * FROM E_EMP2

ALTER TABLE E_EMP2 READ ONLY;

DELETE FROM E_EMP2;

ALTER TABLE E_EMP2 READ WRITE;

SELECT * FROM E_EMP2;

DROP TABLE E_EMP2;

SELECT * FROM USER_RECYCLEBIN
WHERE original_name = 'E_EMP2';

CREATE TABLE xx_dept_table
( deptno NUMBER,
  dname VARCHAR2 (100)
  );

SELECT * FROM XX_DEPT_TABLE;

--rename a column
ALTER TABLE XX_DEPT_TABLE
RENAME COLUMN dname TO dept_name;

-- rename the object
RENAME xx_dept_table TO dept02;

-- Alter table adding comstraints
ALTER TABLE dept02
ADD CONSTRAINT dept02_pk primary key (deptno);

DESC dept02;

ALTER TABLE dept02 DISABLE CONSTRAINT dept02_pk;

ALTER TABLE dept02 enable CONSTRAINT dept02_pk;

ALTER TABLE dept02
DROP CONSTRAINT dept02_pk;

commit;

-- VERY IMPORTANT TIPS
-- You can create char datatype without size and you can not do with varchar2

CREATE TABLE dept11
( emp_id NUMBER,
fname varchar2 (100),
lname char
);

INSERT INTO dept11 VALUES (1, 'Mohammed', 'Ali'); -- CANNOT CHAR BY DEFAULT IS ONE CHARACTER
INSERT INTO dept11 VALUES (1, 'Mohammed', 'A');
SELECT * FROM dept11;


-- Design DB for players stats contains the columns (passing, attacking and defensive stats).
CREATE TABLE players
( player_id NUMBER constraint players_pk primary key,
  player_name VARCHAR2(100) not null constraint players_uk1 unique,
  player_age NUMBER not null,
  passes_id NUMBER constraint plyers_fk1 REFERENCES passing_stats (passes_id),
  defensive_id NUMBER constraint players_fk2 REFERENCES defensive_stats (defensive_id),
  attacking_id NUMBER constraint players_fk3 REFERENCES attacking_stats (attacking_id)
);

CREATE TABLE passing_stats
( passes_id NUMBER constraint passing_stats_pk primary key,
  all_passes NUMBER constraint passing_stats_uk1 unique,
  passes_acc NUMBER not null,
  forward_psses NUMBER not null,
  side_passes NUMBER not null,
  passes_to_final_third NUMBER,
  long_passes NUMBER not null
);

SELECT * FROM passing_stats;

ALTER TABLE passing_stats
RENAME COLUMN forward_psses to forward_passes;

CREATE TABLE defensive_stats
( defensive_id NUMBER constraint defensive_stats_pk primary key,
  all_blocks NUMBER constraint defensive_stats_uk1 unique,
  interceptions NUMBER not null,
  duals NUMBER not null,
  tackles NUMBER not null
);

SELECT * FROM defensive_stats;

CREATE TABLE attacking_stats
( attacking_id NUMBER constraint attacking_stats_pk primary key,
  goals NUMBER not null,
  assists NUMBER not null,
  xG NUMBER not null,
  xA NUMBER not null,
  shots NUMBER not null,
  creating_chances NUMBER not null
);

--Insert values into passing_stats table
INSERT INTO passing_stats VALUES (1, 792, 63, 45, 877, 245, 25);
INSERT INTO passing_stats VALUES (2, 2504, 79, 951, 1203, 479, 688);
INSERT INTO passing_stats VALUES (3, 2217, 71, 711, 1008, 358, 455);
INSERT INTO passing_stats VALUES (4, 2501, 65, 522, 1500, 501, 570);
INSERT INTO passing_stats VALUES (5, 2110, 66, 455, 1200, 455, 704);
INSERT INTO passing_stats VALUES (6, 1820, 60, 401, 1005, 322, 524);
INSERT INTO passing_stats VALUES (7, 3014, 71, 902, 2001, 768, 1244);
INSERT INTO passing_stats VALUES (8, 2578, 62, 824, 1577, 566, 1002);
INSERT INTO passing_stats VALUES (9, 2247, 73, 677, 1244, 632, 1624);
INSERT INTO passing_stats VALUES (10, 1478, 65, 447, 685, 541, 288);
INSERT INTO passing_stats VALUES (11, 1802, 63, 571, 687, 487, 179);
INSERT INTO passing_stats VALUES (12, 4120, 77, 1827, 2047, 1077, 962);
INSERT INTO passing_stats VALUES (13, 2541, 68, 977, 1544, 722, 598);
INSERT INTO passing_stats VALUES (14, 2401, 76, 947, 1244, 739, 933);
INSERT INTO passing_stats VALUES (15, 2104, 71, 588, 922, 247, 702);
INSERT INTO passing_stats VALUES (16, 1755, 68, 811, 872, 642, 852);
INSERT INTO passing_stats VALUES (17, 3077, 79, 1725, 1400, 1742, 498);
INSERT INTO passing_stats VALUES (18, 2822, 75, 1422, 1230, 1524, 688);
INSERT INTO passing_stats VALUES (19, 2475, 71, 1540, 1003, 1422, 681);
INSERT INTO passing_stats VALUES (20, 2740, 75, 1472, 1533, 502, 1032);
INSERT INTO passing_stats VALUES (21, 2802, 74, 1433, 1733, 466, 1247);
INSERT INTO passing_stats VALUES (22, 2741, 65, 1233, 755, 654, 402);
INSERT INTO passing_stats VALUES (23, 2755, 74, 1230, 1552, 702, 1266);
INSERT INTO passing_stats VALUES (24, 3201, 66, 966, 1520, 1052, 763);
INSERT INTO passing_stats VALUES (25, 1892, 62, 887, 1230, 766, 329);
INSERT INTO passing_stats VALUES (26, 1966, 66, 982, 1355, 893, 620);
INSERT INTO passing_stats VALUES (27, 1402, 63, 462, 638, 715, 298);
INSERT INTO passing_stats VALUES (28, 1620, 69, 582, 930, 799, 342);
INSERT INTO passing_stats VALUES (29, 2931, 65, 1302, 1644, 1004, 1320);
INSERT INTO passing_stats VALUES (30, 1722, 68, 710, 683, 455, 1520);
INSERT INTO passing_stats VALUES (31, 2304, 62, 824, 678, 582, 1320);
INSERT INTO passing_stats VALUES (32, 1824, 60, 785, 1030, 998, 320);
INSERT INTO passing_stats VALUES (33, 2954, 68, 893, 1204, 569, 1098);

SELECT * FROM passing_stats;

-- Insert into defensive_stats (blocks, interceptions, duals, tackles)
INSERT INTO defensive_stats VALUES (1, 19, 22, 96, 10);
INSERT INTO defensive_stats VALUES (2, 51, 69, 25, 31);
INSERT INTO defensive_stats VALUES (3, 45, 44, 19, 32);
INSERT INTO defensive_stats VALUES (4, 56, 96, 75, 44);
INSERT INTO defensive_stats VALUES (5, 47, 66, 27, 30);
INSERT INTO defensive_stats VALUES (6, 41, 47, 26, 32);
INSERT INTO defensive_stats VALUES (7, 189, 234, 104, 231);
INSERT INTO defensive_stats VALUES (8, 174, 257, 109, 301);
INSERT INTO defensive_stats VALUES (9, 325, 411, 247, 366);
INSERT INTO defensive_stats VALUES (10, 68, 77, 63, 28);
INSERT INTO defensive_stats VALUES (11, 61, 49, 24, 25);
INSERT INTO defensive_stats VALUES (12, 104, 87, 63, 79);
INSERT INTO defensive_stats VALUES (13, 271, 147, 158, 136);
INSERT INTO defensive_stats VALUES (14, 301, 255, 241, 150);
INSERT INTO defensive_stats VALUES (15, 214, 156, 127, 105);
INSERT INTO defensive_stats VALUES (16, 207, 145, 126, 99);
INSERT INTO defensive_stats VALUES (17, 187, 69, 99, 105);
INSERT INTO defensive_stats VALUES (18, 147, 105, 75, 55);
INSERT INTO defensive_stats VALUES (19, 182, 140, 78, 101);
INSERT INTO defensive_stats VALUES (20, 302, 257, 199, 201);
INSERT INTO defensive_stats VALUES (21, 287, 178, 165, 108);
INSERT INTO defensive_stats VALUES (22, 57, 28, 62, 19);
INSERT INTO defensive_stats VALUES (23, 276, 172, 169, 182);
INSERT INTO defensive_stats VALUES (24, 114, 89, 67, 93);
INSERT INTO defensive_stats VALUES (25, 66, 34, 25, 28);
INSERT INTO defensive_stats VALUES (26, 72, 68, 39, 52);
INSERT INTO defensive_stats VALUES (27, 27, 36, 25, 34);
INSERT INTO defensive_stats VALUES (28, 35, 72, 29, 35);
INSERT INTO defensive_stats VALUES (29, 102, 95, 56, 72);
INSERT INTO defensive_stats VALUES (30, 199, 125, 140, 135);
INSERT INTO defensive_stats VALUES (31, 164, 120, 135, 98);
INSERT INTO defensive_stats VALUES (32, 26, 27, 35, 19);
INSERT INTO defensive_stats VALUES (33, 223, 150, 108, 108);

SELECT * FROM defensive_stats;

-- Insrt values into attacking_values (goals, assists, xG, xA, shots, chances)
INSERT INTO attacking_stats VALUES (1, 41, 11, 55, 18, 289, 307);
INSERT INTO attacking_stats VALUES (2, 37, 26, 40, 31, 385, 204);
INSERT INTO attacking_stats VALUES (3, 25, 19, 35, 28, 259, 275);
INSERT INTO attacking_stats VALUES (4, 22, 14, 27, 15, 299, 310);
INSERT INTO attacking_stats VALUES (5, 29, 17, 31, 24, 282, 267);
INSERT INTO attacking_stats VALUES (6, 18, 10, 24, 17, 241, 185);
INSERT INTO attacking_stats VALUES (7, 9, 15, 11, 17, 104, 288);
INSERT INTO attacking_stats VALUES (8, 6, 9, 9, 14, 108, 207);
INSERT INTO attacking_stats VALUES (9, 5, 6, 6, 5, 44, 29);
INSERT INTO attacking_stats VALUES (10, 18, 14, 20, 17, 241, 255);
INSERT INTO attacking_stats VALUES (11, 14, 10, 19, 17, 147, 193);
INSERT INTO attacking_stats VALUES (12, 7, 9, 10, 10, 174, 199);
INSERT INTO attacking_stats VALUES (13, 2, 3, 2, 4, 56, 74);
INSERT INTO attacking_stats VALUES (14, 3, 1, 4, 3, 47, 68);
INSERT INTO attacking_stats VALUES (15, 4, 7, 4, 8, 77, 82);
INSERT INTO attacking_stats VALUES (16, 2, 4, 2, 4, 44, 32);
INSERT INTO attacking_stats VALUES (17, 7, 12, 8, 13, 184, 265);
INSERT INTO attacking_stats VALUES (18, 19, 14, 20, 17, 255, 268);
INSERT INTO attacking_stats VALUES (19, 11, 12, 14, 13, 177, 198);
INSERT INTO attacking_stats VALUES (20, 5, 4, 6, 6, 82, 48);
INSERT INTO attacking_stats VALUES (21, 4, 3, 4, 5, 54, 35);
INSERT INTO attacking_stats VALUES (22, 12, 9, 14, 13, 125, 95);
INSERT INTO attacking_stats VALUES (23, 5, 4, 6, 7, 102, 87);
INSERT INTO attacking_stats VALUES (24, 6, 8, 7, 10, 125, 144);
INSERT INTO attacking_stats VALUES (25, 14, 8, 15, 10, 144, 129);
INSERT INTO attacking_stats VALUES (26, 12, 7, 13, 8, 104, 87);
INSERT INTO attacking_stats VALUES (27, 17, 10, 19, 15, 140, 57);
INSERT INTO attacking_stats VALUES (28, 14, 8, 15, 10, 140, 74);
INSERT INTO attacking_stats VALUES (29, 6, 7, 7, 9, 140, 108);
INSERT INTO attacking_stats VALUES (30, 4, 7, 6, 8, 29, 31);
INSERT INTO attacking_stats VALUES (31, 5, 4, 6, 7, 35, 65);
INSERT INTO attacking_stats VALUES (32, 14, 8, 16, 10, 188, 163);
INSERT INTO attacking_stats VALUES (33, 4, 8, 5, 8, 48, 37);

SELECT * FROM attacking_stats;

-- Insert into players table
INSERT INTO players VALUES (1, 'Halland', 23, 1, 1, 1);
INSERT INTO players VALUES (2, 'Salah', 31, 2, 2, 2);
INSERT INTO players VALUES (3, 'Saka', 23, 3, 3, 3);
INSERT INTO players VALUES (4, 'Fernandez', 28, 4, 4, 4);
INSERT INTO players VALUES (5, 'Son', 26, 5, 5, 5);
INSERT INTO players VALUES (6, 'Sterling', 32, 6, 6, 6);
INSERT INTO players VALUES (7, 'Arnold', 25, 7, 7, 7);
INSERT INTO players VALUES (8, 'Robertson', 27, 8, 8, 8);
INSERT INTO players VALUES (9, 'Virgil', 34, 9, 9, 9);
INSERT INTO players VALUES (10, 'Jota', 26, 10, 10, 10);
INSERT INTO players VALUES (11, 'Diaz', 28, 11, 11, 11);
INSERT INTO players VALUES (12, 'Mac_Allister', 26, 12, 12, 12);
INSERT INTO players VALUES (13, 'Walker', 30, 13, 13, 13);
INSERT INTO players VALUES (14, 'Stones', 27, 14, 14, 14);
INSERT INTO players VALUES (15, 'Ake', 22, 15, 15, 15);
INSERT INTO players VALUES (16, 'Akanji', 22, 16, 16, 16);
INSERT INTO players VALUES (17, 'Gundogan', 31, 17, 17, 17);
INSERT INTO players VALUES (18, 'DeBruyne', 32, 18, 18, 18);
INSERT INTO players VALUES (19, 'Silva', 29, 19, 19, 19);
INSERT INTO players VALUES (20, 'Saliba', 27, 20, 20, 20);
INSERT INTO players VALUES (21, 'Gabreil', 26, 21, 21, 21);
INSERT INTO players VALUES (22, 'Martinelli', 25, 22, 22, 22);
INSERT INTO players VALUES (23, 'BenWhite', 28, 23, 23, 23);
INSERT INTO players VALUES (24, 'Rice', 26, 24, 24, 24);
INSERT INTO players VALUES (25, 'Havertz', 27, 25, 25, 25);
INSERT INTO players VALUES (26, 'Odegaard', 26, 26, 26, 26);
INSERT INTO players VALUES (27, 'Watkines', 28, 27, 27, 27);
INSERT INTO players VALUES (28, 'Wissa', 30, 28, 28, 28);
INSERT INTO players VALUES (29, 'Gordon', 27, 29, 29, 29);
INSERT INTO players VALUES (30, 'Mings', 31, 30, 30, 30);
INSERT INTO players VALUES (31, 'Cocorella', 28, 31, 31, 31);
INSERT INTO players VALUES (32, 'Vardy', 35, 32, 32, 32);
INSERT INTO players VALUES (33, 'Romero', 29, 33, 33, 33);

SELECT pl.player_id,
       pl.player_name,
       pas.all_passes,
       pas.passes_acc,
       pas.forward_passes,
       pas.passes_to_final_third,
       pas.side_passes,
       ds.all_blocks,
       ds.duals,
       ds.tackles,
       ds.interceptions,
       ats.goals,
       ats.assists,
       ats.xG,
       ats.xA,
       ats.shots
FROM
       players pl
JOIN
      passing_stats pas ON pl.passes_id = pas.passes_id
JOIN
      defensive_stats ds ON pl.defensive_id = ds.defensive_id
JOIN
      attacking_stats ats ON pl.attacking_id = ats.attacking_id
ORDER BY
      pl.player_id;      
commit;

