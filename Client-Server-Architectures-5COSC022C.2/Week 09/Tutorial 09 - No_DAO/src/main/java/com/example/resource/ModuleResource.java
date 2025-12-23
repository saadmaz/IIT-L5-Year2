// Tutorial_Week09_DAO/src/main/java/com/example/resource/ModuleResource.java
package com.example.resource;

import com.example.model.Module;
import com.example.model.Teacher;
import java.util.ArrayList;
import java.util.List;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;

@Path("/modules")
public class ModuleResource {
    private static List<Module> modules;
    private static int nextId = 3;

    static {
        modules = new ArrayList<>();
        List<Teacher> teachers = TeacherResource.getAllTeachersStatic();
        modules.add(new Module(1, "Math", teachers.get(0)));
        modules.add(new Module(2, "Science", teachers.get(1)));
    }

    public static List<Module> getAllModulesStatic() {
        return modules;
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List<Module> getAllModules() {
        return modules;
    }

    @GET
    @Path("/{moduleId}")
    @Produces(MediaType.APPLICATION_JSON)
    public Module getModuleById(@PathParam("moduleId") int moduleId) {
        for (Module module : modules) {
            if (module.getId() == moduleId) {
                return module;
            }
        }
        return null;
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    public void addModule(Module module) {
        module.setId(nextId++);
        modules.add(module);
    }

    @PUT
    @Path("/{moduleId}")
    @Consumes(MediaType.APPLICATION_JSON)
    public void updateModule(@PathParam("moduleId") int moduleId, Module updatedModule) {
        for (int i = 0; i < modules.size(); i++) {
            Module module = modules.get(i);
            if (module.getId() == moduleId) {
                updatedModule.setId(moduleId);
                modules.set(i, updatedModule);
                return;
            }
        }
    }

    @DELETE
    @Path("/{moduleId}")
    public void deleteModule(@PathParam("moduleId") int moduleId) {
        modules.removeIf(module -> module.getId() == moduleId);
    }

    @GET
    @Path("/teachers/{teacherId}")
    @Produces(MediaType.APPLICATION_JSON)
    public List<Module> getModulesByTeacher(@PathParam("teacherId") int teacherId) {
        List<Module> modulesByTeacher = new ArrayList<>();
        for (Module module : modules) {
            if (module.getTeacher().getId() == teacherId) {
                modulesByTeacher.add(module);
            }
        }
        return modulesByTeacher;
    }
}