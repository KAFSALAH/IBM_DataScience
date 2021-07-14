select * from CHICAGO_CRIME_DATA;
select * from census_data;
select * from chicago_public_schools
--- Write and execute a SQL query to list the school names, community names and average attendance for communities with a hardship index of 98.
select S.name_of_school, S.Average_student_attendance,
C.hardship_index, C.community_area_name 
from chicago_public_schools as S  left outer join census_data  as C
on S.community_area_number = C.community_area_number
where C.hardship_index = 98;
---
---Write and execute a SQL query to list all crimes that took place at a school. Include case number, crime type and community name.
select CR.case_number, CR.primary_type,
C.community_area_name
from CHICAGO_CRIME_DATA as CR  left outer join
census_data as C
on CR.community_area_number = C.community_area_number
where CR.location_description like 'SCHOOL%'

---
--- Write and execute a SQL statement to create a view showing the columns listed in the following table, with new column names as shown in the second column.
---Column name in CHICAGO_PUBLIC_SCHOOLS	Column name in view
-- NAME_OF_SCHOOL	School_Name
-- Safety_Icon	Safety_Rating
-- Family_Involvement_Icon	Family_Rating
-- Environment_Icon	Environment_Rating
-- Instruction_Icon	Instruction_Rating
-- Leaders_Icon	Leaders_Rating
-- Teachers_Icon	Teachers_Rating

---Write and execute a SQL statement that returns all of the columns from the view.
---Write and execute a SQL statement that returns just the school name and leaders rating from the view.
create view chicago_schools_view
(School_name, Safety_rating, family_rating,
environment_rating, instruction_rating, leaders_rating,
teachers_rating)
as select NAME_OF_SCHOOL, safety_icon, Family_Involvement_Icon,
Environment_Icon, Instruction_Icon, Leaders_Icon, Teachers_Icon
from chicago_public_schools;
select * from chicago_schools_view;
Select school_name, leaders_rating from chicago_schools_view;  
---The icon fields are calculated based on the value in the corresponding score field. You need to make sure that when a score field is updated, the icon field is updated too. To do this, you will write a stored procedure that receives the school id and a leaders score as input parameters, calculates the icon setting and updates the fields appropriately
---Question 3-1
---Write the structure of a query to create or replace a stored procedure called UPDATE_LEADERS_SCORE that takes a in_School_ID parameter as an integer and a in_Leader_Score parameter as an integer. Don't forget to use the #SET TERMINATOR statement to use the @ for the CREATE statement terminator.
--#SET TERMINATOR @
create or replace procedure update_leaders_score
(IN in_school_id INTEGER, IN in_leaders_scores INTEGER)
language SQL
MODIFIES SQL DATA 
BEGIN
END
@
---Question 3-2
---Inside your stored procedure, write a SQL statement to update the Leaders_Score field in the CHICAGO_PUBLIC_SCHOOLS table for the school identified by in_School_ID to the value in the in_Leader_Score parameter.
--#SET TERMINATOR @
CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE 
(IN in_School_ID INTEGER, IN in_Leader_Score INTEGER)
LANGUAGE SQL
BEGIN 
UPDATE CHICAGO_PUBLIC_SCHOOLS
SET Leaders_Score = in_Leader_Score
WHERE School_ID = in_School_ID;		
END
@
---Question 3-3
---Inside your stored procedure, write a SQL IF statement to update the Leaders_Icon field in the CHICAGO_PUBLIC_SCHOOLS table for the school identified by in_School_ID using the following information.
---
-- Score lower limit	Score upper limit	Icon
-- 80	99	Very strong
-- 60	79	Strong
-- 40	59	Average
-- 20	39	Weak
-- 0	19	Very weak
--#SET TERMINATOR @

CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE 
(IN in_School_ID INTEGER, IN in_Leader_Score INTEGER)
LANGUAGE SQL
BEGIN 
UPDATE CHICAGO_PUBLIC_SCHOOLS
SET Leaders_Score = in_Leader_Score
WHERE School_ID = in_School_ID;
IF in_Leader_Score > 0 AND in_Leader_Score < 20 THEN
	      	UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET Leaders_Icon = 'Very Weak';
	    ELSEIF in_Leader_Score < 40 THEN
	       	UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET Leaders_Icon = 'Weak';	
	    ELSEIF in_Leader_Score < 60 THEN
	       	UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET Leaders_Icon = 'Average';
	    ELSEIF in_Leader_Score < 80 THEN
	       	UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET Leaders_Icon = 'Strong';
	    ELSEIF in_Leader_Score < 100 THEN
	       	UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET Leaders_Icon = 'Very Strong';
	   	END IF;
		
	END@
---Question 3-4
---Run your code to create the stored procedure.
---Write a query to call the stored procedure, passing a valid school ID and a leader score of 50, to check that the procedure works as expected.
---Question 4-1
---Update your stored procedure definition. Add a generic ELSE clause to the IF statement that rolls back the current work if the score did not fit any of the preceding categories.
--#SET TERMINATOR @
CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE 
(IN in_School_ID INTEGER, IN in_Leader_Score INTEGER)
LANGUAGE SQL
BEGIN 
UPDATE CHICAGO_PUBLIC_SCHOOLS
SET Leaders_Score = in_Leader_Score
WHERE School_ID = in_School_ID;
IF in_Leader_Score > 0 AND in_Leader_Score < 20 THEN
	      	UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET Leaders_Icon = 'Very Weak';
	    ELSEIF in_Leader_Score < 40 THEN
	       	UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET Leaders_Icon = 'Weak';	
	    ELSEIF in_Leader_Score < 60 THEN
	       	UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET Leaders_Icon = 'Average';
	    ELSEIF in_Leader_Score < 80 THEN
	       	UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET Leaders_Icon = 'Strong';
	    ELSEIF in_Leader_Score < 100 THEN
	       	UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET Leaders_Icon = 'Very Strong';
		ELSE
				ROLLBACK;
	   	END IF;
		
	END@

--- Update your stored procedure definition again. Add a statement to commit the current unit of work at the end of the procedure.

--#SET TERMINATOR @
CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE 
(IN in_School_ID INTEGER, IN in_Leader_Score INTEGER)
LANGUAGE SQL
BEGIN 
UPDATE CHICAGO_PUBLIC_SCHOOLS
SET Leaders_Score = in_Leader_Score
WHERE School_ID = in_School_ID;
IF in_Leader_Score > 0 AND in_Leader_Score < 20 THEN
	      	UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET Leaders_Icon = 'Very Weak';
	    ELSEIF in_Leader_Score < 40 THEN
	       	UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET Leaders_Icon = 'Weak';	
	    ELSEIF in_Leader_Score < 60 THEN
	       	UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET Leaders_Icon = 'Average';
	    ELSEIF in_Leader_Score < 80 THEN
	       	UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET Leaders_Icon = 'Strong';
	    ELSEIF in_Leader_Score < 100 THEN
	       	UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET Leaders_Icon = 'Very Strong';
		ELSE
				ROLLBACK;
	   	END IF;
	   			COMMIT WORK;
		
	END@

		
