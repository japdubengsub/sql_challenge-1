-- clean data
/*
DROP TABLE dbo.contact_address
DROP TABLE dbo.contact_phone
DROP TABLE dbo.phone
DROP TABLE dbo.address
DROP TABLE dbo.country
DROP TABLE dbo.contact
DROP TABLE dbo.site
--*/


SET NOCOUNT ON;
GO

CREATE TABLE dbo.[site]
(
    id          int     PRIMARY KEY IDENTITY(1, 1),
    name        nvarchar(100)   NOT NULL,

    CONSTRAINT UQ_site___name UNIQUE (name)
);
GO

CREATE TABLE dbo.contact
(
    id          int     PRIMARY KEY IDENTITY(1, 1),
    site_id     int             NOT NULL,
    first_name  nvarchar(100)   NOT NULL,
    last_name   nvarchar(100)   NOT NULL 

    CONSTRAINT FK_contact___site_id FOREIGN KEY (site_id) REFERENCES dbo.[site] (id),
    CONSTRAINT UQ_contact___last_name__fist_name__site_id UNIQUE (last_name, first_name, site_id)
);
CREATE NONCLUSTERED INDEX IX_contact__site_id ON dbo.contact (site_id);


CREATE TABLE dbo.country
(
    id      smallint        PRIMARY KEY IDENTITY(1,1),
    title   nvarchar(100)   NOT NULL,

    CONSTRAINT UQ_country__title UNIQUE (title)
);


CREATE TABLE dbo.address
(
    id              int             PRIMARY KEY IDENTITY(1, 1),
    country_id      smallint        NOT NULL,
    city            nvarchar(100)   NOT NULL,
    street_name     nvarchar(100)   NOT NULL,
    number          int             NOT NULL,

    CONSTRAINT FK_address___country_id FOREIGN KEY (country_id) REFERENCES dbo.country (id)
);
CREATE NONCLUSTERED INDEX IX_address__country_id ON dbo.address (country_id);


CREATE TABLE dbo.phone
(
    id              int         PRIMARY KEY IDENTITY(1,1),
    type            int         NOT NULL,
    phone_number    varchar(12) NOT NULL, -- this field can be int, depends on requirements; additional check constraint also may be useful

    CONSTRAINT UQ_phone___phone_number__type UNIQUE (phone_number, type)
);


CREATE TABLE dbo.contact_phone
(
    id          int     PRIMARY KEY IDENTITY(1,1),
    contact_id  int     NOT NULL,
    phone_id    int     NOT NULL,

    CONSTRAINT UQ_contact_phone___contact_id__phpne_id  UNIQUE (contact_id, phone_id),
    CONSTRAINT FK_contact_phone___contact_id            FOREIGN KEY (contact_id) REFERENCES dbo.contact (id),
    CONSTRAINT FK_contact_phone___phone_id              FOREIGN KEY (phone_id) REFERENCES dbo.phone (id)
);
--CREATE NONCLUSTERED INDEX IX_contact_phone___contact_id     ON dbo.contact_phone (contact_id);
CREATE NONCLUSTERED INDEX IX_contact_phone___phone_id       ON dbo.contact_phone (phone_id);


CREATE TABLE dbo.contact_address
(
    id          int     PRIMARY KEY IDENTITY(1,1),
    contact_id  int     NOT NULL,
    address_id  int     NOT NULL,

    CONSTRAINT UQ_contact_address___contact_id__address_id  UNIQUE (contact_id, address_id),
    CONSTRAINT FK_contact_address___contact_id              FOREIGN KEY (contact_id) REFERENCES dbo.contact (id),
    CONSTRAINT FK_contact_address___address_id              FOREIGN KEY (address_id) REFERENCES dbo.address (id)
);
--CREATE NONCLUSTERED INDEX IX_contact_address___contact_id    ON dbo.contact_address (contact_id);
CREATE NONCLUSTERED INDEX IX_contact_address___address_id    ON dbo.contact_address (address_id);





INSERT INTO dbo.site (name)
VALUES (N'site #1'), (N'site #2');

INSERT INTO dbo.country (title)
VALUES (N'Spain'), (N'Russia');

INSERT dbo.address (country_id, city, street_name, number)
VALUES (1, N'city #1', N'street #1', 1),
       (1, N'city #2', N'street #2', 100),   
       (2, N'city #3', N'street #3', 33);

INSERT dbo.phone (type, phone_number)
VALUES (1, '+5-555-55-55'),
       (2, '+1-111-11-11'),
       (3, '+3-333-33-33');


INSERT dbo.contact (site_id, first_name, last_name)
VALUES (1, 'contact #1 fisrtname', 'contact #1 lastname'),
       (1, 'contact #2 fisrtname', 'contact #2 lastname'),
       (1, 'contact #3 fisrtname', 'contact #3 lastname'),
       (2, 'contact #4 fisrtname', 'contact #4 lastname'),
       (2, 'contact #5 fisrtname', 'contact #5 lastname'),
       (2, 'contact #6 fisrtname', 'contact #6 lastname');

INSERT dbo.contact_address (contact_id, address_id)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 1),
       (5, 2),
       (6, 3);


INSERT dbo.contact_phone
VALUES (1, 1),
       (1, 2),
       (2, 2),
       (3, 3),
       (4, 1),
       (5, 2),
       (6, 3);
GO



