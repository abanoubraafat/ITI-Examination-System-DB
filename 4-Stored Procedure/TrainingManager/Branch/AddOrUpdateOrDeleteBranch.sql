 -------------------------------------AddOneOrMoreBranch---------------------
 
create or alter proc AddOneOrMoreBranche
	@Username varchar(10),
	@Password varchar(10),
    @BranchNames nvarchar(MAX)
as
begin
	IF not (@Username = 'manager' and @Password = 'manager')
	begin
		SELECT 'Access Denied' AS ResultMessage
		RETURN
	end
    create table #TempBranches
    (
        BranchName nvarchar(50)
    );
    insert into #TempBranches (BranchName)
    select value FROM STRING_SPLIT(@BranchNames, ',');
    if EXISTS (
        select 1
        from #TempBranches t
        where EXISTS (
            select 1
            from Branch B
            where B.Name = t.BranchName
        )
    )
    begin
        select distinct
            'The ' + t.BranchName + ' is already exist in the database' AS ResultMessage
        from #TempBranches t
        where EXISTS (
            select 1
            from Branch B
           where B.Name = t.BranchName
        );
    end
    else
    begin
        insert into Branch (Name)
        select  t.BranchName
        from #TempBranches t
        where NOT EXISTS (
            select 1
            from Branch B
            where B.Name = t.BranchName
        );

        SELECT 'Branches added successfully.' AS ResultMessage;
    END;
    DROP TABLE #TempBranches;
END;
Go



--------------------Update the Branch----------------

CREATE OR ALTER PROCEDURE UpdateBranchNames
	@Username varchar(10),
	@Password varchar(10),
    @OldBranchName nvarchar(50),
    @NewBranchName nvarchar(50)
AS
BEGIN
	IF not (@Username = 'manager' and @Password = 'manager')
	begin
		SELECT 'Access Denied' AS ResultMessage
		RETURN
	end
    ELSE IF EXISTS (SELECT 1 FROM Branch WHERE Name = @OldBranchName)
    BEGIN
        UPDATE Branch
        SET Name = @NewBranchName
        WHERE Name = @OldBranchName;

        SELECT 'Branch updated successfully.' AS ResultMessage;
    END
    ELSE
    BEGIN
        SELECT 'Branch not found IN data base' AS ResultMessage;
    END
END;
Go


	

-----------------------------Delete Branch-------------

CREATE OR ALTER PROCEDURE DeleteBranch
	@Username varchar(10),
	@Password varchar(10),
    @BranchID INT
AS
BEGIN
	IF not (@Username = 'manager' and @Password = 'manager')
	begin
		SELECT 'Access Denied' AS ResultMessage
		RETURN
	end
    ELSE IF EXISTS (SELECT 1 FROM Branch WHERE ID = @BranchID)
    BEGIN
        DELETE FROM Branch
        WHERE ID = @BranchID;

        SELECT 'Branch deleted successfully.' AS ResultMessage;
    END
    ELSE
    BEGIN
        SELECT 'Branch not found In data base' AS ResultMessage;
    END
END;
Go