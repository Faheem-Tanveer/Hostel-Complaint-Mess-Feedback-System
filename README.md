# 🏠 Hostel Complaint & Mess Feedback System

A **DBMS mini project** developed as part of the **Database Management Systems** course.  
This system provides a structured platform for hostel students to raise complaints and give mess feedback, while enabling admins and mess managers to manage and analyze data efficiently.

---

## 📌 Project Overview

Students residing in hostels often face issues related to maintenance, cleanliness, Wi-Fi, electricity, and food quality.  
This project solves the problem by implementing a **centralized database-backed system** with:

- Proper complaint tracking  
- Automated status updates  
- Mess feedback analysis  
- Backend automation using DBMS concepts  
- A simple Python-based UI  

---

## 🧩 Features Implemented

### 👨‍🎓 Student Module
- Raise hostel-related complaints  
- View previously raised complaints  
- Submit mess feedback ratings  

### 🧑‍💼 Admin Module
- View all complaints  
- Resolve complaints  
- Automatic status update on resolution (via trigger)  

### 🍽 Mess Manager Module
- Receive student feedback  
- View average rating calculated using SQL function  

---

## 🗄 Database Design

### Entities (Tables)
- Students  
- Admins  
- MessManagers  
- ComplaintCategory  
- HostelRooms  
- Complaints  
- Feedback  

### Relationships
- One-to-Many between **Students → Complaints**  
- One-to-Many between **ComplaintCategory → Complaints**  
- One-to-Many between **MessManagers → Feedback**

---

## ⚙ DBMS Concepts Used

- **DDL & DML**
- **Primary & Foreign Keys**
- **Constraints**
- **Triggers (3)**
- **Stored Procedures (2)**
- **Function (1)**
- **View (1)**

---

## 🖥 Frontend

- Built using **Streamlit**
- Connected to MySQL using `mysql-connector-python`
- Allows real-time interaction with the database

---

## 🛠 Technologies Used

- MySQL 8.0  
- Python 3  
- Streamlit  
- VS Code  
- Git & GitHub  

---

## 📌 Conclusion

The project demonstrates real-world usage of DBMS concepts by integrating a relational database with a frontend interface.  
It ensures data consistency, automation, and efficient complaint management using triggers, procedures, functions, and views.

---
