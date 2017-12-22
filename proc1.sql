
CREATE PROCEDURE dbo.get_site_info
(
    @site_id AS int
)
AS
BEGIN

    SET NOCOUNT ON;

    SELECT
        CASE
            WHEN GROUPING_ID(a.city) = 0            THEN 7
            WHEN GROUPING_ID(ca.contact_id) = 0     THEN 6 
            WHEN GROUPING_ID(p.phone_number) = 0    THEN 5
            WHEN GROUPING_ID(cp.contact_id) = 0     THEN 4 
            WHEN GROUPING_ID(c.id) = 0              THEN 3
            WHEN GROUPING_ID(c.site_id) = 0         THEN 2
            WHEN GROUPING_ID(s.id) = 0              THEN 1
        END AS TAG,
        CASE
            WHEN GROUPING_ID(a.city) = 0            THEN 6
            WHEN GROUPING_ID(ca.contact_id) = 0     THEN 3 
            WHEN GROUPING_ID(p.phone_number) = 0    THEN 4
            WHEN GROUPING_ID(cp.contact_id) = 0     THEN 3
            WHEN GROUPING_ID(c.id) = 0              THEN 2
            WHEN GROUPING_ID(c.site_id) = 0         THEN 1
            WHEN GROUPING_ID(s.id) = 0              THEN NULL
        END AS PARENT,

        s.id            AS [Site!1!id],
        s.name          AS [Site!1!name],
        c.site_id       AS [Contacts!2!!hide],
        c.id            AS [Contact!3!id],
        c.first_name    AS [Contact!3!first_name],
        c.last_name     AS [Contact!3!last_name],
        cp.contact_id   AS [Phones!4!!hide],
        p.phone_number  AS [Phone!5!phone_number],
        ca.contact_id   AS [Addresses!6!!hide],
        co.title        AS [Address!7!country],
        a.city          AS [Address!7!city],
        a.street_name   AS [Address!7!street_name],
        a.number        AS [Address!7!number]
    FROM dbo.site                       AS s
        INNER JOIN dbo.contact          AS c
            ON c.site_id = s.id
        INNER JOIN dbo.contact_phone    AS cp
            ON cp.contact_id = c.id
        INNER JOIN dbo.phone            AS p
            ON p.id = cp.phone_id
        INNER JOIN dbo.contact_address  AS ca
            ON ca.contact_id = c.id
        INNER JOIN dbo.address          AS a
            ON a.id = ca.address_id
        INNER JOIN dbo.country          AS co
            ON co.id = a.country_id
    WHERE s.id = @site_id
    GROUP BY GROUPING SETS (
        (s.id, s.name),
        (s.id, s.name, c.site_id),
        (s.id, s.name, c.id, c.first_name, c.last_name),
        (s.id, s.name, c.id, c.first_name, c.last_name, cp.contact_id),
        (s.id, s.name, c.id, c.first_name, c.last_name, cp.contact_id, p.phone_number),
        (s.id, s.name, c.id, c.first_name, c.last_name, ca.contact_id),
        (s.id, s.name, c.id, c.first_name, c.last_name, ca.contact_id, a.city, a.street_name, a.number, co.title)
    )
    ORDER BY s.id, c.id, ca.contact_id, cp.contact_id, p.phone_number, a.city
    FOR XML EXPLICIT, TYPE

END
GO


-----------------------------
--  SOME TESTS
-----------------------------
/*
EXEC dbo.get_site_info  @site_id = 1;
EXEC dbo.get_site_info  @site_id = 2;
--*/

