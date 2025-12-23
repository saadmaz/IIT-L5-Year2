// Tutorial_Week09_DAO/src/main/java/com/example/resource/StudentResource.java
package com.example.resource;

import com.example.model.Module;
import com.example.model.Student;
import java.util.ArrayList;
import java.util.List;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;

@Path("/students")
public class StudentResource {
    private static List<Student> students = new ArrayList<>();
    private static int nextId = 3;

    static {
        students.add(new Student(1, "John Doe"));
        students.add(new Student(2, "Jane Doe"));
    }

    public static List<Student> getAllStudentsStatic() {
        return students;
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List<Student> getAllStudents() {
        return students;
    }

    @GET
    @Path("/{studentId}")
    @Produces(MediaType.APPLICATION_JSON)
    public Student getStudentById(@PathParam("studentId") int studentId) {
        for (Student student : students) {
            if (student.getId() == studentId) {
                return student;
            }
        }
        return null;
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    public void addStudent(Student student) {
        student.setId(nextId++);
        students.add(student);
    }

    @PUT
    @Path("/{studentId}")
    @Consumes(MediaType.APPLICATION_JSON)
    public void updateStudent(@PathParam("studentId") int studentId, Student updatedStudent) {
        for (int i = 0; i < students.size(); i++) {
            Student student = students.get(i);
            if (student.getId() == studentId) {
                updatedStudent.setId(studentId);
                students.set(i, updatedStudent);
                return;
            }
        }
    }

    @DELETE
    @Path("/{studentId}")
    public void deleteStudent(@PathParam("studentId") int studentId) {
        students.removeIf(student -> student.getId() == studentId);
    }

    @GET
    @Path("/{studentId}/modules")
    @Produces(MediaType.APPLICATION_JSON)
    public String getModulesForStudent(@PathParam("studentId") int studentId) {
        Student student = getStudentById(studentId);
        if (student != null) {
            int moduleId = 1; // Assuming the student selected module with ID 1
            Module selectedModule = ModuleResource.getAllModulesStatic().stream().filter(m -> m.getId() == moduleId).findFirst().orElse(null);

            if (selectedModule != null) {
                return "{\"module\": \"" + selectedModule.getName()
                        + "\", \"teacher\": \"" + selectedModule.getTeacher().getName() + "\"}";
            }
        }
        return "{\"error\": \"Student or module not found\"}";
    }
}