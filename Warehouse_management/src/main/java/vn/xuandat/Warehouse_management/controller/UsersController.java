package vn.xuandat.Warehouse_management.controller;

import java.util.ArrayList;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import vn.xuandat.Warehouse_management.entity.User;
import vn.xuandat.Warehouse_management.service.UserService;




// MVC => , View <-> Controller ---Service ---Repository--- Model(entity)
@Controller
public class UsersController {
    private final UserService userService;
    public UsersController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/admin/users")
    public String getAllUsers(Model model) {
        ArrayList<User> users = (ArrayList<User>) this.userService.handleGetAllUsers();
        model.addAttribute("users", users);
        return "admin/user/show-users";
    }

    @GetMapping("/admin/users/create")
    public String createUser(Model model) {
        User newUser = new User();
        model.addAttribute("newUser", newUser);
        return "admin/user/create-user";
    }
    
    @PostMapping("/admin/users/create")
    public String postCreateUser(Model model, @ModelAttribute("newUser") User newUser) {
        this.userService.handleSaveUser(newUser);
        return "redirect:/admin/users"; // redirect: trả về api (endpoint) getAllUsers
    }
    
    @GetMapping("/admin/users/delete/{id}")
    public String deleteUser(@PathVariable Long id) {
        this.userService.handleDeleteUser(id);
        return "redirect:/admin/users";
    }

    @GetMapping("/admin/users/update/{id}")
    public String updateUser(Model model, @PathVariable Long id){
        User userDB = this.userService.fetchUserById(id);
        model.addAttribute("userDB", userDB);
        return "admin/user/update-user";
    }

    @PostMapping("/admin/users/update")
    public String postUpdateUser(@ModelAttribute("userDB") User newUser){
        this.userService.handleSaveUser(newUser);
        return "redirect:/admin/users";
    }

}
