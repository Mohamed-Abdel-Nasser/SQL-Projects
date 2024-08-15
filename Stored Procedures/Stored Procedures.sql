-- Stored Procedure Basic Sayntax
	CREATE PROCEDURE SP_ProductList
	AS
	BEGIN
		SELECT product_name,list_price
		FROM production.products
		ORDER BY product_name;
	END;


--Executing a stored procedure
	--To execute a stored procedure, you use the EXECUTE or EXEC statement followed by the name of the stored procedure:

	EXECUTE SP_ProductList;
	Or
	EXEC SP_ProductList;

--where sp_name is the name of the stored procedure that you want to execute.


--Modifying a stored procedure
	--To modify an existing stored procedure, you use the ALTER PROCEDURE statement.

	 ALTER PROCEDURE SP_ProductList
		AS
		BEGIN
			SELECT product_name,list_price
			FROM production.products
			ORDER BY list_price 
		END;

--Deleting a stored procedure
--To delete a stored procedure, you use the DROP PROCEDURE or DROP PROC statement:

		DROP PROCEDURE SP_ProductList;
		or
		DROP PROC SP_ProductList;    

--where sp_name is the name of the stored procedure that you want to delete.

--#####################################################################################

--## Stored Procedures - With Input and Output Parameters 
--Creating a stored procedure with One parameters

CREATE PROCEDURE SP_Find_Products 
				 @min_list_price AS DECIMAL
AS
BEGIN
	SELECT product_name,list_price
	FROM production.products
	WHERE list_price >= @min_list_price
	ORDER BY list_price;
END;

EXEC SP_Find_Products 100;
--#####################################################################################
--Creating a stored procedure with multiple parameters
		ALTER PROCEDURE SP_Find_Products
						@min_list_price AS DECIMAL,
						@max_list_price AS DECIMAL
		AS
		BEGIN
			SELECT product_name,list_price
			FROM production.products
			WHERE list_price >= @min_list_price AND list_price <= @max_list_price
			ORDER BY list_price;
		END;

		EXECUTE SP_Find_Products 900, 1000;

		EXECUTE SP_Find_Products 
			@min_list_price = 900, 
			@max_list_price = 1000;


--###########################################################
--Creating a stored procedure with Texet parameters
		CREATE PROCEDURE SP_Find_Products
						@min_list_price AS DECIMAL = 0 ,
						@max_list_price AS DECIMAL = NULL ,
						@name AS VARCHAR(max) 
		AS
		BEGIN
			SELECT product_name,list_price
			FROM production.products
			WHERE
				list_price >= @min_list_price 
				AND (@max_list_price IS NULL OR list_price <= @max_list_price) 
				AND product_name LIKE '%' + @name + '%'
			ORDER BY list_price;
		END;


		EXECUTE SP_Find_Products 
			@min_list_price = 900, 
			@max_list_price = 1000,
			@name = 'Trek';

--###################################################
--Creating a stored procedure with Initialization parameters
		ALTER PROCEDURE SP_Find_Products
						 @min_list_price AS DECIMAL = 0,
						 @max_list_price AS DECIMAL = 999999,
						 @name AS VARCHAR(max) =''
		AS
		BEGIN
			SELECT product_name,list_price
			FROM production.products
			WHERE
				list_price >= @min_list_price AND
				list_price <= @max_list_price AND
				product_name LIKE '%' + @name + '%'
			ORDER BY
				list_price;
		END;


		EXECUTE SP_Find_Products 
    
		EXECUTE SP_Find_Products 
		@min_list_price = 6000,
		@name = 'Trek';




--Creating a stored procedure with NULL parameters

ALTER PROCEDURE SP_Find_Products
				@min_list_price AS DECIMAL = 0
				,@max_list_price AS DECIMAL = NULL
				,@name AS VARCHAR(max)

AS
BEGIN
    SELECT product_name,list_price
    FROM production.products
    WHERE
        list_price >= @min_list_price AND
        (@max_list_price IS NULL OR list_price <= @max_list_price) AND
        product_name LIKE '%' + @name + '%'
    ORDER BY
        list_price;
END;


EXECUTE SP_Find_Products 
    @min_list_price = 500,
    @name = 'Haro';


--####################################################################################################
----Creating a stored procedure with Declaring a variable USING INPUT parameters  && OUTPUT parameters

--USING INPUT parameters
	CREATE  PROC SP_GetProductList
				 @model_year SMALLINT
	AS 
	BEGIN
		DECLARE @product_list VARCHAR(MAX);
		SET @product_list = '';
		SELECT @product_list = @product_list + product_name + CHAR(10)
		FROM production.products
		WHERE model_year = @model_year
		ORDER BY product_name;
		PRINT @product_list;
	END;


	EXEC SP_GetProductList 2018


--#############################################################
--USING OUTPUT parameters

	CREATE PROC SP_FindProductByModelYear
				@model_year SMALLINT, 
				@product_count INT OUTPUT	
	AS
	BEGIN
		SELECT product_name,list_price
		FROM production.products
		WHERE model_year = @model_year
		SELECT @product_count = @@ROWCOUNT
	END


	DROP PROC SP_FindProductByModelYear

		DECLARE @count AS INT
		EXEC SP_FindProductByModelYear 
			 @model_year=2018,
			 @product_count=@count output;
		SELECT @count AS "No of Products"


		