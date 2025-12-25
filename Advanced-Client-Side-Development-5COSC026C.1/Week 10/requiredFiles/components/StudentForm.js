// src/components/StudentForm.js
import React from 'react';

const StudentForm = ({ student, handleInputChange, handleSubmit, handleCancel }) => {
  return (
    <div>
      <h2>Student Form</h2>
      <form onSubmit={handleSubmit}>
        <label>
          First Name:
          <input type="text" name="firstName" value={student.firstName} onChange={handleInputChange} />
        </label>
        <br />
        <label>
          Last Name:
          <input type="text" name="lastName" value={student.lastName} onChange={handleInputChange} />
        </label>
        <br />
        <label>
          Enrollment Date:
          <input type="date" name="enrollmentDate" value={student.enrollmentDate} onChange={handleInputChange} />
        </label>
        <br />
        <button type="submit">Save</button>
        <button type="button" onClick={handleCancel}>
          Cancel
        </button>
      </form>
    </div>
  );
};

export default StudentForm;
