CREATE DATABASE IF NOT EXISTS DigitalLibrary;
USE DigitalLibrary;

CREATE TABLE Books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(200) NOT NULL,
    Author VARCHAR(150) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    TotalCopies INT DEFAULT 1,
    AvailableCopies INT DEFAULT 1
);

CREATE TABLE Students (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(150) NOT NULL,
    Email VARCHAR(150) UNIQUE NOT NULL,
    EnrollmentDate DATE NOT NULL,
    LastActivityDate DATE
);

CREATE TABLE IssuedBooks (
    IssueID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT NOT NULL,
    BookID INT NOT NULL,
    IssueDate DATE NOT NULL,
    ReturnDate DATE,
    PenaltyAmount DECIMAL(6,2) DEFAULT 0.00,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

INSERT INTO Books (Title, Author, Category, TotalCopies, AvailableCopies) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 3, 2),
('A Brief History of Time', 'Stephen Hawking', 'Science', 2, 1),
('Sapiens', 'Yuval Noah Harari', 'History', 4, 3),
('Dune', 'Frank Herbert', 'Fiction', 3, 1),
('The Selfish Gene', 'Richard Dawkins', 'Science', 2, 2),
('1984', 'George Orwell', 'Fiction', 5, 3),
('Guns Germs and Steel', 'Jared Diamond', 'History', 2, 2),
('Clean Code', 'Robert C. Martin', 'Technology', 3, 1),
('To Kill a Mockingbird', 'Harper Lee', 'Fiction', 4, 4),
('Cosmos', 'Carl Sagan', 'Science', 2, 0);

INSERT INTO Students (FullName, Email, EnrollmentDate, LastActivityDate) VALUES
('Arun Kumar', 'arun.kumar@college.edu', '2022-06-01', '2024-11-10'),
('Priya Nair', 'priya.nair@college.edu', '2021-07-15', '2022-08-20'),
('Ravi Shankar', 'ravi.shankar@college.edu', '2023-01-10', '2026-02-14'),
('Meena Pillai', 'meena.pillai@college.edu', '2020-08-01', '2021-05-30'),
('Karthik Raj', 'karthik.raj@college.edu', '2022-03-20', '2026-03-01'),
('Divya Menon', 'divya.menon@college.edu', '2023-09-01', '2026-04-10'),
('Suresh Babu', 'suresh.babu@college.edu', '2019-06-01', '2020-11-15'),
('Lakshmi Devi', 'lakshmi.devi@college.edu', '2024-01-05', '2026-04-12');

INSERT INTO IssuedBooks (StudentID, BookID, IssueDate, ReturnDate) VALUES
(1, 1, '2026-03-28', NULL),
(1, 4, '2026-01-10', '2026-01-20'),
(2, 2, '2026-03-20', NULL),
(3, 3, '2026-04-14', NULL),
(4, 6, '2026-03-01', NULL),
(5, 8, '2026-04-10', NULL),
(6, 5, '2026-04-12', NULL),
(7, 10, '2022-09-01', '2022-09-10'),
(8, 1, '2026-02-20', NULL),
(3, 6, '2026-01-05', '2026-01-18'),
(5, 3, '2025-12-01', NULL),
(6, 9, '2026-04-01', NULL);

SELECT
    s.StudentID,
    s.FullName,
    s.Email,
    b.Title AS BookTitle,
    b.Category,
    ib.IssueDate,
    DATEDIFF(CURDATE(), ib.IssueDate) AS DaysOverdue,
    ROUND(DATEDIFF(CURDATE(), ib.IssueDate) * 2.00, 2) AS PenaltyAmountINR
FROM IssuedBooks ib
JOIN Students s ON ib.StudentID = s.StudentID
JOIN Books b ON ib.BookID = b.BookID
WHERE ib.ReturnDate IS NULL
  AND DATEDIFF(CURDATE(), ib.IssueDate) > 14
ORDER BY DaysOverdue DESC;

SELECT
    b.Category,
    COUNT(ib.IssueID) AS TotalBorrows,
    COUNT(DISTINCT ib.StudentID) AS UniqueStudents,
    ROUND(COUNT(ib.IssueID) * 100.0 / SUM(COUNT(ib.IssueID)) OVER (), 2) AS BorrowPercentage
FROM IssuedBooks ib
JOIN Books b ON ib.BookID = b.BookID
GROUP BY b.Category
ORDER BY TotalBorrows DESC;

SELECT
    s.StudentID,
    s.FullName,
    s.Email,
    s.LastActivityDate,
    DATEDIFF(CURDATE(), s.LastActivityDate) AS DaysInactive
FROM Students s
WHERE s.LastActivityDate < DATE_SUB(CURDATE(), INTERVAL 3 YEAR)
   OR (
        s.StudentID NOT IN (SELECT DISTINCT StudentID FROM IssuedBooks)
        AND s.EnrollmentDate < DATE_SUB(CURDATE(), INTERVAL 3 YEAR)
      );

DELETE FROM Students
WHERE LastActivityDate < DATE_SUB(CURDATE(), INTERVAL 3 YEAR)
  AND StudentID NOT IN (
      SELECT StudentID FROM IssuedBooks WHERE ReturnDate IS NULL
  );

UPDATE IssuedBooks
SET PenaltyAmount = ROUND(DATEDIFF(CURDATE(), IssueDate) * 2.00, 2)
WHERE ReturnDate IS NULL
  AND DATEDIFF(CURDATE(), IssueDate) > 14;

SELECT
    s.FullName,
    s.Email,
    b.Title,
    b.Category,
    ib.IssueDate,
    DATEDIFF(CURDATE(), ib.IssueDate) AS DaysOverdue,
    ib.PenaltyAmount AS PenaltyINR
FROM IssuedBooks ib
JOIN Students s ON ib.StudentID = s.StudentID
JOIN Books b ON ib.BookID = b.BookID
WHERE ib.ReturnDate IS NULL
  AND DATEDIFF(CURDATE(), ib.IssueDate) > 14
ORDER BY ib.PenaltyAmount DESC;