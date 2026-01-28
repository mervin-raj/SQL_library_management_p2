# 📚 Library Management System – SQL Project

## 📌 Project Overview
This project implements a **Library Management System** using **PostgreSQL SQL**.
It focuses on database design, table relationships, and solving real-world library operations using SQL queries.

The project includes **database creation, constraints, and 12 practical SQL tasks with queries**.

---

## 🛠️ Tools & Technologies
- **Database:** PostgreSQL
- **Language:** SQL

### SQL Concepts Used
- DDL (CREATE, ALTER, DROP)
- DML (INSERT, UPDATE, DELETE)
- INNER JOIN, LEFT JOIN, SELF JOIN
- GROUP BY & HAVING
- Aggregate Functions (COUNT, SUM)
- Date Functions
- CTAS (CREATE TABLE AS SELECT)
- Foreign Key Constraints

---

## 🗂️ Database Schema & Table Creation

### Branch Table
```sql
CREATE TABLE branch (
    branch_id VARCHAR(10) PRIMARY KEY,
    manager_id VARCHAR(10),
    branch_address VARCHAR(55),
    contact_no VARCHAR(20)
);
```

### Employees Table
```sql
CREATE TABLE employees (
    emp_id VARCHAR(10) PRIMARY KEY,
    emp_name VARCHAR(25),
    position VARCHAR(25),
    salary DECIMAL(10,2),
    branch_id VARCHAR(25)
);
```

### Books Table
```sql
CREATE TABLE books (
    isbn VARCHAR(20) PRIMARY KEY,
    book_title VARCHAR(75),
    category VARCHAR(20),
    rental_price FLOAT,
    status VARCHAR(15),
    author VARCHAR(35),
    publisher VARCHAR(55)
);
```

### Members Table
```sql
CREATE TABLE members (
    member_id VARCHAR(20) PRIMARY KEY,
    member_name VARCHAR(25),
    member_address VARCHAR(70),
    reg_date DATE
);
```

### Issued Status Table
```sql
CREATE TABLE issued_status (
    issued_id VARCHAR(10) PRIMARY KEY,
    issued_member_id VARCHAR(10),
    issued_book_name VARCHAR(75),
    issued_date DATE,
    issued_book_isbn VARCHAR(25),
    issued_emp_id VARCHAR(75)
);
```

### Return Status Table
```sql
CREATE TABLE return_status (
    return_id VARCHAR(10) PRIMARY KEY,
    issued_id VARCHAR(10),
    return_book_name VARCHAR(75),
    return_date DATE,
    return_book_isbn VARCHAR(20)
);
```

---

## 🔗 Foreign Key Relationships
```sql
ALTER TABLE issued_status
ADD CONSTRAINT fk_members FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);
```

---

## ✅ Tasks & SQL Queries

### Task 1: Create a New Book Record
```sql
INSERT INTO books
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
```

### Task 2: Update an Existing Member's Address
```sql
UPDATE members
SET member_address = '125 Main st'
WHERE member_id = 'C101';
```

### Task 3: Delete a Record from Issued Status
```sql
DELETE FROM issued_status
WHERE issued_id = 'IS121';
```

### Task 4: Retrieve All Books Issued by a Specific Employee
```sql
SELECT *
FROM issued_status
WHERE issued_emp_id = 'E101';
```

### Task 5: Members Who Issued More Than One Book
```sql
SELECT issued_emp_id, COUNT(*) AS total_issued
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(*) > 1;
```

### Task 6: Create Summary Tables (CTAS)
```sql
CREATE TABLE books_counts AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_book_isbn) AS no_issued
FROM books b
JOIN issued_status ist
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;
```

### Task 7: Retrieve Books by Category
```sql
SELECT *
FROM books
WHERE category = 'Classic';
```

### Task 8: Total Rental Income by Category
```sql
SELECT b.category, SUM(b.rental_price) AS total_income, COUNT(*) AS total_issues
FROM books b
JOIN issued_status ist
ON ist.issued_book_isbn = b.isbn
GROUP BY b.category;
```

### Task 9: Members Registered in Last 180 Days
```sql
SELECT *
FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';
```

### Task 10: Employees with Branch Manager Details
```sql
SELECT e1.*, b.manager_id, e2.emp_name AS manager_name
FROM employees e1
JOIN branch b ON e1.branch_id = b.branch_id
JOIN employees e2 ON e2.emp_id = b.manager_id;
```

### Task 11: Books Above Rental Price Threshold
```sql
CREATE TABLE book_price_abv_7 AS
SELECT *
FROM books
WHERE rental_price > 7;
```

### Task 12: Books Not Yet Returned
```sql
SELECT DISTINCT ist.issued_book_name
FROM issued_status ist
LEFT JOIN return_status rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL;
```

---

## 🎯 Project Outcome
This project demonstrates how SQL can be used to manage and analyze a complete **library database system**, including issuing, returns, employees, and revenue insights.

---

## 👤 Author
**Mervin Raj**  
Aspiring Data Analyst  
SQL | Power BI | Excel | Python (Beginner)
