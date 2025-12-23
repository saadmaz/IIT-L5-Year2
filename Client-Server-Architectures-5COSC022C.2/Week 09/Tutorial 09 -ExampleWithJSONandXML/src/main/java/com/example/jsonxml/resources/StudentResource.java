/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.example.jsonxml.resources;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@Path("/students")
public class StudentResource {

    // Use a ConcurrentHashMap for thread-safe storage.
    private static final ConcurrentHashMap<String, Student> studentStore = new ConcurrentHashMap<>();

    // Static initializer block to add some initial students.  This is
    // executed when the class is loaded.
    static {
        addInitialStudents();
    }

    private static void addInitialStudents() {
        Student student1 = new Student(UUID.randomUUID().toString(), "Alice", "Smith");
        Student student2 = new Student(UUID.randomUUID().toString(), "Bob", "Johnson");
        Student student3 = new Student(UUID.randomUUID().toString(), "Charlie", "Brown");

        studentStore.put(student1.getId(), student1);
        studentStore.put(student2.getId(), student2);
        studentStore.put(student3.getId(), student3);
    }

    //you can send different types based on client request headers
    //by sending the "Accept: text/json" header you can get json
    //by sending the "Accept: text/xml" header you can get json
    //use pastebin or postman to experiment.
    @GET
    @Produces({MediaType.APPLICATION_JSON,MediaType.APPLICATION_XML})
    public List<Student> getAllStudents() {
        return new ArrayList<>(studentStore.values());
    }

    @GET
    @Path("/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getStudentById(@PathParam("id") String id) {
        System.out.print(id);
        Student student = studentStore.get(id);
  
        if (student != null) {
            return Response.ok(student).build();
        } else {
            return Response.status(Response.Status.NOT_FOUND).entity("Student with ID " + id + " not found").build();
        }
    }


    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response createStudent(Student student) {
        if (student.getFirstName() == null || student.getLastName() == null) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("firstName and lastName are required").build();
        }

        String id = UUID.randomUUID().toString();
        student.setId(id);
        studentStore.put(id, student);
        return Response.status(Response.Status.CREATED).entity(student).build();
    }

    @PUT
    @Path("/{id}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response updateStudent(@PathParam("id") String id, Student updatedStudent) {
        if (studentStore.containsKey(id)) {
            Student student = studentStore.get(id);
            if(updatedStudent.getFirstName() != null){
                student.setFirstName(updatedStudent.getFirstName());
            }
            if(updatedStudent.getLastName() != null){
                student.setLastName(updatedStudent.getLastName());
            }

            studentStore.put(id,student);
            return Response.ok(student).build();

        } else {
            return Response.status(Response.Status.NOT_FOUND).entity("Student with id " + id + " not found").build();
        }
    }

    @DELETE
    @Path("/{id}")
    public Response deleteStudent(@PathParam("id") String id) {
        if (studentStore.remove(id) != null) {
            return Response.noContent().build();
        } else {
            return Response.status(Response.Status.NOT_FOUND).entity("Student with ID " + id + " not found").build();
        }
    }
}