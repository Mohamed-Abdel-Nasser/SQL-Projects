--Creating a scalar function
		CREATE FUNCTION [schema_name.]function_name (parameter_list) RETURNS data_type 
		AS
		BEGIN
			statements
			RETURN value
		END

--Modifying a scalar function
		ALTER FUNCTION [schema_name.]function_name (parameter_list) RETURNS data_type 
			AS
			BEGIN
				statements
				RETURN value
			END
--Note that you can use the CREATE OR ALTER statement to create a user-defined function 
--if it does not exist or to modify an existing scalar function:
		CREATE OR ALTER FUNCTION [schema_name.]function_name (parameter_list)RETURNS data_type 
				AS
				BEGIN
					statements
					RETURN value
				END

--Removing a scalar function
		DROP FUNCTION [schema_name.]function_name;

