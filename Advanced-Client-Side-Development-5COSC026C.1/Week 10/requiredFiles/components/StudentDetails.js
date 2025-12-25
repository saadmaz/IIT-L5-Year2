// src/components/StudentDetails.js
import React from 'react';

const StudentDetails = ({ student }) => {
  if (!student) {
    return <div>No student selected.</div>;
  }

  return (
    <div>
      <h2>Student Details</h2>
      <p>ID: {student.studentID}</p>
      <p>First Name: {student.firstName}</p>
      <p>Last Name: {student.lastName}</p>
      <p>Enrollment Date: {student.enrollmentDate}</p>
    </div>
  );
};

export default StudentDetails;
