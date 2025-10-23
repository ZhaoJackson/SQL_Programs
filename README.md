# SQL Learning Repository 📚

Welcome to the SQL Learning Repository! This is a comprehensive collection of SQL concepts, exercises, and real-world examples designed to track learning progress and serve as a reference guide for SQL learners at all levels.

## 🎯 Purpose

This repository serves as:
- **A learning tracker** - Document your SQL journey from basics to advanced topics
- **A reference guide** - Quick access to SQL syntax, functions, and best practices
- **A collaborative space** - Share knowledge and learn together with the SQL community

## 🤝 Collaboration & Co-Learning

**We welcome collaboration!** Whether you're:
- Just starting your SQL journey
- Looking to deepen your understanding
- Wanting to share your knowledge and examples
- Interested in adding new exercises or challenges

Feel free to contribute, suggest improvements, or share your own SQL solutions. Learning together makes us all better!

---

## 📖 Topics Covered

### 1. **Basic Clauses** 
`Basic Clause/`
- `SELECT`, `FROM` statements
- `ORDER BY` clause (ASC/DESC)
- `DISTINCT` keyword for filtering unique values
- `LIMIT` clause for controlling result size
- `COUNT()` function for aggregation
- Fundamental query structure and syntax

### 2. **Filtering Data**
`Filtering/`
- `WHERE` clause and conditions
- Comparison operators (`=`, `>`, `<`, `>=`, `<=`, `IS NULL`, `IS NOT NULL`)
- Logical operators (`AND`, `OR`, `NOT`)
- `BETWEEN` operator for range filtering
- `IN()` operator for multiple value matching
- `LIKE` operator with wildcards (`%`, `_`) for pattern matching
- Combining multiple conditions

### 3. **Functions**
`Functions/`

**String Functions:**
- `LENGTH()`, `UPPER()`, `LOWER()`
- `LEFT()`, `RIGHT()` for substring extraction
- `SUBSTRING()` for advanced string manipulation
- `POSITION()` for character location
- Concatenation operator (`||`)

**Date/Time Functions:**
- `EXTRACT()` for date parts (DAY, MONTH, YEAR, DOW, DOY, HOUR, MINUTE)
- `TO_CHAR()` for custom date formatting
- `CURRENT_DATE`, `CURRENT_TIMESTAMP`
- Date arithmetic and intervals

### 4. **Grouping & Aggregation**
`Grouping/`
- `GROUP BY` clause for data aggregation
- Aggregate functions: `SUM()`, `AVG()`, `MIN()`, `MAX()`, `COUNT()`
- `HAVING` clause for filtering aggregated results
- Grouping by multiple columns
- Working with `DATE()` function in grouping
- `ROUND()` function for decimal precision

### 5. **Joins**
`Joins/`
- `INNER JOIN` for matching records
- `LEFT JOIN` (LEFT OUTER JOIN) for including all left table records
- `RIGHT JOIN` (RIGHT OUTER JOIN) for including all right table records
- `FULL OUTER JOIN` for all records from both tables
- Multiple join conditions
- Joining on multiple columns
- Real-world multi-table queries

### 6. **Advanced Joins & Grouping Sets**
`Grouping sets, Rollups, Self-Joins/`
- `GROUPING SETS` for multiple aggregation levels
- `ROLLUP` for hierarchical subtotals
- `CUBE` for all possible combinations of aggregations
- `SELF JOIN` for comparing rows within the same table
- `CROSS JOIN` for cartesian products
- `NATURAL JOIN` for automatic column matching

### 7. **Conditional Expressions**
`Conditional Expressions/`
- `CASE` statements (WHEN-THEN-ELSE-END)
- `COALESCE()` for handling NULL values
- `CAST()` for data type conversion
- `REPLACE()` for string manipulation
- Conditional logic in queries
- Creating custom classifications and categories

### 8. **Union & Subqueries**
`Union & Subquery/`

**UNION Operations:**
- `UNION` (removing duplicates)
- `UNION ALL` (keeping duplicates)
- Combining results from multiple tables

**Subqueries:**
- Subqueries in `WHERE` clause
- Subqueries in `FROM` clause
- Subqueries in `SELECT` clause
- Correlated subqueries
- Using `IN`, `EXISTS`, `NOT EXISTS`
- Nested and complex subqueries

### 9. **Window Functions**
`Window Functions/`
- `OVER()` clause for window operations
- `PARTITION BY` for grouping within windows
- `ORDER BY` in window functions
- Ranking functions: `RANK()`, `DENSE_RANK()`
- `FIRST_VALUE()` for accessing first row in partition
- `LEAD()` and `LAG()` for accessing adjacent rows
- Running totals and cumulative calculations
- Comparing values across rows without collapsing results

### 10. **Views & Data Manipulation**
`View & Data Manipulation/`

**Data Manipulation (DML):**
- `UPDATE` statements for modifying data
- `DELETE` statements for removing records
- `INSERT INTO` for adding new records
- Using `RETURNING` clause

**Views:**
- `CREATE VIEW` for virtual tables
- `CREATE MATERIALIZED VIEW` for physical storage
- `REFRESH MATERIALIZED VIEW` for updating data
- `ALTER VIEW` for modifications
- `DROP VIEW` for removal
- `CREATE OR REPLACE VIEW`
- Creating tables with `CREATE TABLE AS`
- Data import/export with CSV files

### 11. **Managing Tables and Databases**
`Managing Tables and Databases/`

**Database Management (DDL):**
- `CREATE DATABASE` and database properties
- Data types: INT, NUMERIC, VARCHAR, TEXT, DATE, BOOLEAN, SERIAL
- Table creation with `CREATE TABLE`
- Constraints: `NOT NULL`, `UNIQUE`, `DEFAULT`, `CHECK`
- `PRIMARY KEY` and `FOREIGN KEY` relationships
- `ALTER TABLE` operations:
  - Adding/dropping columns
  - Changing data types
  - Renaming columns and tables
  - Adding/removing constraints
- `DROP TABLE` and `TRUNCATE TABLE`
- Schema management

### 12. **User-Defined Functions & Stored Procedures**
`User-Defined functions and stored procedures/`
- Creating custom functions
- Stored procedures for reusable logic
- Function parameters and return types
- Advanced database programming

---

## 🗃️ Database Files

The `Database/` folder contains:
- **flight_database.sql** - Flight management database schema and data
- **pagila-insert-data.sql** - Sample retail database (film rental store data)

These databases are used throughout the exercises for hands-on practice.

---

## 📂 Projects

The `Project/` folder contains:
- **mid_project.sql** - Mid-term project demonstrating intermediate SQL skills
- **final_proj.sql** - Final project showcasing advanced SQL techniques

---

## 🚀 Getting Started

1. **Clone or fork this repository**
2. **Set up your SQL environment** (PostgreSQL recommended based on the syntax used)
3. **Import the sample databases** from the `Database/` folder
4. **Start with the basics** and progress through the topics
5. **Practice with the exercises** in each folder
6. **Challenge yourself** with the projects

---

## 💡 Learning Path

**Recommended progression:**
1. Basic Clauses → Filtering
2. Functions → Grouping
3. Joins → Advanced Joins & Grouping Sets
4. Conditional Expressions
5. Union & Subqueries
6. Window Functions
7. Views & Data Manipulation
8. Managing Tables and Databases
9. User-Defined Functions & Stored Procedures

---

## 🤓 Tips for Success

- **Practice regularly** - SQL skills improve with consistent practice
- **Experiment** - Try modifying queries to see different results
- **Read the code** - Each SQL file contains comments explaining concepts
- **Build projects** - Apply what you learn to real-world scenarios
- **Collaborate** - Share your solutions and learn from others

---

## 🌟 Contributing

We welcome contributions of all kinds:
- **Add new exercises or challenges**
- **Share alternative solutions**
- **Improve documentation**
- **Report issues or suggest improvements**
- **Add new topics or advanced concepts**

**How to contribute:**
1. Fork the repository
2. Create a new branch for your changes
3. Make your improvements
4. Submit a pull request with a clear description

---

## 📝 Notes

- This repository primarily uses **PostgreSQL** syntax
- Each folder contains both **SQL files** (with executable code) and **PDF files** (with theoretical explanations)
- Code includes extensive **comments** for self-guided learning
- Examples use real-world scenarios from databases like flight systems and film rental stores

---

## 📬 Get in Touch

Have questions? Want to discuss SQL concepts? Looking for study partners?

**Let's learn SQL together!** 🎓

---

## 📄 License

This repository is open for educational purposes. Feel free to use, modify, and share for learning.

---

**Happy Learning! 🚀**

Remember: SQL is a powerful tool, and mastering it opens doors to data analysis, backend development, database administration, and much more. Keep querying, keep learning!
