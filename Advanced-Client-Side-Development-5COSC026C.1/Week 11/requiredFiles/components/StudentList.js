// src/components/StudentList.js
import React from 'react';
import StudentsTable from './StudentsTable';

const StudentList = ({ students, handleEdit, handleDelete }) => {
  return (
    <div>
      <h2>Students</h2>
      <StudentsTable students={students} handleEdit={handleEdit} handleDelete={handleDelete} />
    </div>
  );
};

export default StudentList;
