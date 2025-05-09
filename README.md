📚 **Library Management System - Database Project**

🏷️**Project Title**

Library Management System Database
A comprehensive MySQL database for managing library operations
📝 Description

This project implements a complete relational database system for library management, designed to handle:

    Book cataloging with authors, publishers, and categories

    Member registration and management

    Book borrowing and returns

    Reservations and waitlists

    Fine calculations

    Staff management

The database follows proper normalization principles (3NF) with appropriate constraints and relationships to ensure data integrity.
🛠️ **Technologies Used**

    MySQL (Compatible with MySQL 5.7+ and MariaDB)

    Relational Database Design

    SQL Constraints (PK, FK, CHECK, UNIQUE, NOT NULL)

🚀 **Setup Instructions**
Prerequisites

    MySQL Server installed (version 5.7 or higher)

    MySQL client (command line, Workbench, or other interface)

**Installation**

    Clone or download the project repository

    Import the SQL file into your MySQL server:

bash

mysql -u [username] -p library_management_system < library_management_system.sql

Alternative Method (Using MySQL Workbench)

    Open MySQL Workbench

    Connect to your server

    Create a new schema named "library_management_system"

    Open the SQL script file

    Execute the entire script (Ctrl+Shift+Enter)

📊 **Database Schema**

**Entity Relationship Diagram**

[View interactive diagram](https://dbdiagram.io/d/681dce475b2fc4582fe4f8ed)

Key relationships:
- Members → Borrowings (One-to-Many)
- Books → BookCopies (One-to-Many)
- Books ↔ Authors (Many-to-Many)

  
🏗️ **Database Schema Overview**

The database consists of 11 main tables:

    Members - Library patrons

    Books - Book metadata

    Authors - Book authors

    Publishers - Publishing companies

    BookCopies - Physical book copies

    Borrowings - Checkout records

    Fines - Late fees and penalties

    Staff - Library employees

    Reservations - Book holds

    Categories - Book genres/subjects

    Junction tables for M-M relationships

📜 License

This project is open-source and available under the MIT License.
✉️ Contact odingaval71@gmail.com

For questions or suggestions, please open
