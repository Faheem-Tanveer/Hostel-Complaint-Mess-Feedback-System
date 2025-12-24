import streamlit as st
import mysql.connector

# Connect to MySQL
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="faheem123",
    database="hostel_management"
)
cur = conn.cursor(buffered=True)

st.title("🏠 Hostel Complaint & Mess Feedback System")

# ---------------------------
#  Student: Raise Complaint
# ---------------------------

st.header("Raise a Complaint")

student_id = st.number_input("Student ID")
category_id = st.number_input("Category ID")
description = st.text_area("Complaint Description")

if st.button("Submit Complaint"):
    cur.execute(f"CALL RaiseComplaint({student_id}, 1, {category_id}, '{description}')")
    conn.commit()
    st.success("Complaint submitted!")

# ---------------------------
#  Student: View Complaints
# ---------------------------

st.header("View My Complaints")

if st.button("Show My Complaints"):
    cur.execute(f"SELECT * FROM complaint_details WHERE student_id = {student_id}")
    rows = cur.fetchall()
    st.table(rows)

# ---------------------------
#  Admin: Resolve Complaint
# ---------------------------

st.header("Admin: Resolve Complaint")

complaint_to_resolve = st.number_input("Complaint ID to resolve")

if st.button("Resolve Complaint"):
    cur.execute(f"CALL ResolveComplaint({complaint_to_resolve})")
    conn.commit()
    st.success("Complaint marked resolved!")

# ---------------------------
#  Mess Manager: Average Rating
# ---------------------------

st.header("Mess Manager: Check Average Rating")

manager_id = st.number_input("Manager ID")

if st.button("Get Average Rating"):
    cur.execute(f"SELECT AvgManagerRating({manager_id})")
    avg_rating = cur.fetchone()[0]
    st.info(f"Average Rating: {avg_rating}")