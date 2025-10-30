🩺 MySQL Practice Project

This project includes hands-on SQL scripts that demonstrate core and advanced MySQL concepts. It’s ideal for learners and analysts practicing real-world database operations.

🚀 Topics Covered

Creating and modifying tables (ALTER, ADD, DROP)

Data insertion, updates, and deletion

Handling NULL and using COALESCE()

Transactions and rollback control (SAVEPOINT, ROLLBACK, COMMIT)

Triggers for audit tracking on insert, update, and delete

Stored procedures for automation (CALL AddNewPatient)

Using subqueries with IN, EXISTS, and NOT IN

Table partitioning (RANGE, HASH, LIST, KEY)

Primary key management and indexing

OLTP and OLAP simulation (customers and orders tables)

Sharding example using two user databases (users_shard1, users_shard2)

🧠 Project Files
Section	Description
file table	Main patient data table with triggers and procedures
Patient_Audit	Stores audit records for changes in file
shopDB	Demonstrates OLTP and OLAP queries
users_shard1, users_shard2	Simulate horizontal sharding in MySQL
🧩 How to Run

Open MySQL Workbench or terminal.

Copy and run the SQL file step by step.

Observe table changes and audit logs after each trigger or transaction.

Try modifying procedures or queries to test different results.

🧾 Learning Outcome

By the end of this project, you’ll understand how to:

Manage relational data efficiently.

Use MySQL transactions safely.

Automate data tracking with triggers.

Optimize large datasets with partitions.

Simulate data scaling through sharding.
