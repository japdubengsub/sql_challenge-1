
CREATE PROCEDURE dbo.contact_crud
(
    @site_id            int,
    @contact_data       xml
)
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @operation_type smallint;

    SELECT @operation_type = t.s.value('.', 'smallint')
    FROM @contact_data.nodes('/Contact/ID') AS t(s);


    --  update contact
    IF @operation_type > 0
    BEGIN
        
        WITH cte AS
        (
            SELECT
                t.s.value('@id', 'int')                     AS id,
                t.s.value('@first_name', 'nvarchar(100)')   AS first_name,
                t.s.value('@last_name', 'nvarchar(100)')    AS last_name
            FROM @contact_data.nodes('/Contact') AS t(s)
        )
        UPDATE dbo.contact
        SET first_name = cte.first_name,
            last_name  = cte.last_name
        FROM dbo.contact    AS c
            INNER JOIN cte
                ON cte.id = c.id

    END

    --  add new contact
    ELSE IF @operation_type = 0
    BEGIN

        INSERT dbo.contact (site_id, first_name, last_name)
        SELECT
            @site_id,
            t.s.value('@first_name', 'nvarchar(100)'),
            t.s.value('@last_name', 'nvarchar(100)')
        FROM @contact_data.nodes('/Contact') AS t(s);

    END

    --  delete contact
    ELSE IF @operation_type < 0
    BEGIN

        DELETE
        FROM dbo.contact
        WHERE id = (
                        SELECT
                            t.s.value('@id', 'nvarchar(100)')
                        FROM @contact_data.nodes('/Contact') AS t(s)
                    );

    END

    -- return site info
    EXEC dbo.get_site_info @site_id = @site_id;
    

END
GO


-----------------------------
--  SOME TESTS
-----------------------------
/*
DECLARE @p xml;
SELECT 'before', * FROM dbo.contact;


--  add new contact
SET @p = N'<Contact id="7" first_name="contact #7 fisrtname" last_name="contact #7 lastname"><ID>0</ID></Contact>';
EXEC dbo.contact_crud
    @site_id = 1,
    @contact_data = @p;
SELECT 'inserted', * FROM dbo.contact;



--  update contact
SET @p = N'<Contact id="7" first_name="CONTACT #7 FISRTNAME" last_name="CONTACT #7 LASTNAME"><ID>1</ID></Contact>';
EXEC dbo.contact_crud
    @site_id = 1,
    @contact_data = @p;
SELECT 'updated', * FROM dbo.contact;



--  delete contact
SET @p = N'<Contact id="7" first_name="CONTACT #7 FISRTNAME" last_name="CONTACT #7 LASTNAME"><ID>-1</ID></Contact>';
EXEC dbo.contact_crud
    @site_id = 1,
    @contact_data = @p;
SELECT 'deleted', * FROM dbo.contact;
--*/


