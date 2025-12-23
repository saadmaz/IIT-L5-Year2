// Tutorial_Week09_DAO/src/main/java/com/example/resource/TeacherResource.java
package com.example.resource;

import com.example.model.Teacher;
import java.util.ArrayList;
import java.util.List;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;

@Path("/teachers")
public class TeacherResource {
    private static List<Teacher> teachers = new ArrayList<>();
    private static int nextId = 3;

    static {
        teachers.add(new Teacher(1, "Mr. Smith"));
        teachers.add(new Teacher(2, "Ms. Johnson"));
    }

    public static List<Teacher> getAllTeachersStatic() {
        return teachers;
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List<Teacher> getAllTeachers() {
        return teachers;
    }

    @GET
    @Path("/{teacherId}")
    @Produces(MediaType.APPLICATION_JSON)
    public Teacher getTeacherById(@PathParam("teacherId") int teacherId) {
        for (Teacher teacher : teachers) {
            if (teacher.getId() == teacherId) {
                return teacher;
            }
        }
        return null;
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    public void addTeacher(Teacher teacher) {
        teacher.setId(nextId++);
        teachers.add(teacher);
    }

    @PUT
    @Path("/{teacherId}")
    @Consumes(MediaType.APPLICATION_JSON)
    public void updateTeacher(@PathParam("teacherId") int teacherId, Teacher updatedTeacher) {
        for (int i = 0; i < teachers.size(); i++) {
            Teacher teacher = teachers.get(i);
            if (teacher.getId() == teacherId) {
                updatedTeacher.setId(teacherId);
                teachers.set(i, updatedTeacher);
                return;
            }
        }
    }

    @DELETE
    @Path("/{teacherId}")
    public void deleteTeacher(@PathParam("teacherId") int teacherId) {
        teachers.removeIf(teacher -> teacher.getId() == teacherId);
    }
}