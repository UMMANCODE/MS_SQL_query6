CREATE DATABASE NewCourse
GO
USE NewCourse

CREATE Table Groups
(
    Id INT PRIMARY KEY IDENTITY,
    [No] VARCHAR(10)
)
GO

CREATE TABLE Students
(
    Id INT PRIMARY KEY IDENTITY,
    FullName VARCHAR(50),
    Age TINYINT,
    Gender VARCHAR(10),
    GroupId INT FOREIGN KEY REFERENCES Groups(Id)
)
GO
-- Inserting data into the Groups table
INSERT INTO Groups
    ([No])
VALUES
    ('Group A'),
    ('Group B'),
    ('Group C');

-- Inserting data into the Students table
INSERT INTO Students
    (FullName, Age, Gender, GroupId)
VALUES
    ('John Doe', 25, 'Male', 1),
    -- John Doe belongs to Group A
    ('Jane Smith', 23, 'Female', 2),
    -- Jane Smith belongs to Group B
    ('Bob Johnson', 22, 'Male', 3); -- Bob Johnson belongs to Group C
GO

-- Student datası silindikdə DeletedStudents table-na əlavə olsun avtomatik (trigger yazın)
CREATE TRIGGER trg_DeleteStudent ON Students
AFTER DELETE
AS
BEGIN
    SELECT *
    INTO DeletedStudents
    FROM DELETED
END
GO

-- Group datalarının IsDeleted column-u olsun və default false olsun. Bir group datası silinmək istədikdə onun db-dan silinməsinin yerinə o datanın IsDeleted dəyəri dəyişib true olsun (trigger yazın instead of ilə)
ALTER TABLE Groups
ADD IsDeleted BIT NOT NULL DEFAULT 0
GO

CREATE TRIGGER trg_DeleteGroup ON Groups
INSTEAD OF DELETE
AS
BEGIN
    UPDATE Groups
    SET IsDeleted = 1
    WHERE Id IN (SELECT Id
    FROM DELETED)
END
GO
