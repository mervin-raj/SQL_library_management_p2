--library management system project 2
--creating branc table--

DROP TABLE IF EXISTS branch;
CREATE TABLE branch (
                     branch_id VARCHAR(10)  PRIMARY KEY,
                     manager_id VARCHAR(10),
					 branch_address VARCHAR(55),EEEE
					 contact_no VARCHAR(10)
					 );
ALTER TABLE branch
ALTER COLUMN contact_no TYPE VARCHAR(20);

--creating employee table

DROP TABLE IF  EXISTS employees;
CREATE TABLE employees(
                     emp_id	VARCHAR(10) PRIMARY KEY,
					 emp_name VARCHAR(25),
					 position VARCHAR(25),	
					 salary	INT,
					 branch_id VARCHAR(25)
					 );

ALTER TABLE employees
ALTER COLUMN salary TYPE DECIMAL(10,2);


--creating books table--

DROP TABLE IF EXISTS books;
CREATE TABLE books(
                 isbn  VARCHAR(20) PRIMARY KEY,
				 book_title	VARCHAR(75),
	             category VARCHAR(10),
				 rental_price FLOAT,
				 status	VARCHAR(15),
				 author VARCHAR(35),
				 publisher VARCHAR(55)
				 );
ALTER TABLE books
ALTER COLUMN category TYPE VARCHAR(20);

--creating members table


 DROP TABLE IF EXISTS members;
CREATE TABLE members(
                   member_id VARCHAR(20) PRIMARY KEY, 
				   member_name	VARCHAR(25),
				   member_address	VARCHAR(70),
				   reg_date DATE
				   );



 DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status(
                       issued_id VARCHAR(10) PRIMARY KEY,
					   issued_member_id	VARCHAR(10),
					   issued_book_name	VARCHAR(75),
					   issued_date	DATE,
					   issued_book_isbn	VARCHAR(25),
					   issued_emp_id VARCHAR(75)
					   );

 DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status(
                           return_id VARCHAR(10) PRIMARY KEY,	
	                       issued_id VARCHAR(10),	 
						   return_book_name	VARCHAR(75),
						   return_date	DATE,
						   return_book_isbn VARCHAR(20)
						   );

--foreign key

ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY  (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY  ( issued_book_isbn)
REFERENCES books( isbn );

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY  (  issued_emp_id)
REFERENCES employees( emp_id );

ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY  (   branch_id)
REFERENCES branch( branch_id );

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY  (   issued_id )
REFERENCES issued_status( issued_id );


--Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books(isbn  ,book_title	,category ,rental_price ,status	,author ,publisher )
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

SELECT*FROM books;

--Task 2: Update an Existing Member's Address--------
UPDATE members
SET member_address='125 Main st'
WHERE member_id='C101';

SELECT*FROM members;

--Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM issued_status
WHERE issued_id='IS121';

--Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM issued_status
where issued_emp_id='E101'

--Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT 
     issued_emp_id,
	 count(issued_emp_id) as total_issued_emp
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_emp_id)>1;

-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE book_issue_summary AS 
SELECT 
     issued_book_name,
	 COUNT(*) AS total_issued
from issued_status
GROUP BY issued_book_name;

 SELECT * FROM book_issue_summary;



 OR

CREATE TABLE books_counts
AS
 SELECT 
      b.isbn,
	  b.book_title,
	  COUNT(issued_book_isbn)AS NO_ISSUED
 FROM books AS b
 JOIN issued_status as ist
 ON ist.issued_book_isbn = b.isbn
 GROUP BY 1,2;
  SELECT*FROM  books_counts;


  --Task 7. Retrieve All Books in a Specific Category:


SELECT * FROM books
WHERE category = 'Classic';

--Task 8: Find Total Rental Income by Category
SELECT
     b.category,
	SUM(b.rental_price),
		COUNT(*)
FROM books AS b
 JOIN issued_status as ist
 ON ist.issued_book_isbn = b.isbn
 GROUP BY 1;

--Task 9:  List Members Who Registered in the Last 180 Days:

SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';

--Task 10:List Employees with Their Branch Manager's Name and their branch details:
 SELECT
     e1.*,
	 b.manager_id,
	 e2.emp_name AS manager
 FROM
    employees AS e1
JOIN 
   branch as b
   ON e1.branch_id=b.branch_id
JOIN 
   employees AS e2
   ON e2.emp_id=b.manager_id

--Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:

CREATE TABLE book_price_abv_7
 AS
   SELECT * FROM books
   WHERE rental_price>7


SELECT * FROM  book_price_abv_7

--Task 12: Retrieve the List of Books Not Yet Returned

SELECT  DISTINCT issued_BOOK_NAME 
FROM ISSUED_STATUS AS ist
LEFT JOIN
    	return_status as rs
	ON ist.issued_id=rs.issued_id
	WHERE rs.return_id is NULL;

