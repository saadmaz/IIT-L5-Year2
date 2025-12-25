// src/components/Students.js
import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { API_BASE_URL } from '../apiConfig';
import StudentList from './StudentList';
import StudentDetails from './StudentDetails';
import StudentForm from './StudentForm';

const Students = () => {
  const [students, setStudents] = useState([]);
  const [selectedStudent, setSelectedStudent] = useState(null);
  const [editingStudent, setEditingStudent] = useState(null);

  useEffect(() => {
    // Fetch students data when component mounts
    fetchStudents();
  }, []);

  const fetchStudents = async () => {
    try {
      const response = await axios.get(`${API_BASE_URL}Students`);
      setStudents(response.data);
      setSelectedStudent(null);
      setEditingStudent(null);
    } catch (error) {
      console.error('Error fetching students:', error);
    }
  };

const handleEdit = (studentID) => {
  console.log('Edit button clicked for studentID:', studentID);
  const selected = students.find((student) => student.studentId === studentID);
  console.log('Selected student:', selected);
  setSelectedStudent(null);

  // Ensure that the property names match the expected format (studentID, firstName, lastName, enrollmentDate)
  setEditingStudent({ studentID: selected.studentId, firstName: selected.firstName, lastName: selected.lastName, enrollmentDate: selected.enrollmentDate });
};



  const handleDelete = async (studentID) => {
    try {
      await axios.delete(`${API_BASE_URL}Students/${studentID}`);
      fetchStudents();
    } catch (error) {
      console.error('Error deleting student:', error);
    }
  };

  const handleViewDetails = (studentID) => {
    const selected = students.find((student) => student.studentID === studentID);
    setSelectedStudent(selected);
    setEditingStudent(null);
  };

  const handleCreate = () => {
    setSelectedStudent(null);
    setEditingStudent({ firstName: '', lastName: '', enrollmentDate: '' });
  };

  const handleCancelEdit = () => {
    setEditingStudent(null);
  };

const handleFormSubmit = async (event) => {
  event.preventDefault();
  try {
    console.log('Editing Student:', editingStudent);

    if (editingStudent) {
      if (editingStudent.studentID) {
        console.log('Updating existing student:', editingStudent);
        await axios.put(`${API_BASE_URL}Students/${editingStudent.studentID}`, editingStudent);
		
      } else {
        // Remove the existing studentID property for new students
        const { studentID, ...newStudent } = editingStudent;
        console.log('Creating new student:', newStudent);
        await axios.post(`${API_BASE_URL}Students`, newStudent);
      }
      fetchStudents();
    }
  } catch (error) {
    console.error('Error saving student:', error);
    console.error('Response data:', error.response?.data);
  } finally {
    setEditingStudent(null);
  }
};




  return (
    <div>
      <StudentList students={students} handleEdit={handleEdit} handleDelete={handleDelete} />
      {selectedStudent && <StudentDetails student={selectedStudent} />}
      {editingStudent && (
        <StudentForm
          student={editingStudent}
          handleInputChange={(e) => setEditingStudent({ ...editingStudent, [e.target.name]: e.target.value })}
          handleSubmit={handleFormSubmit}
          handleCancel={handleCancelEdit}
        />
      )}
      <button onClick={handleCreate}>Create New Student</button>
    </div>
  );
};

export default Students;
