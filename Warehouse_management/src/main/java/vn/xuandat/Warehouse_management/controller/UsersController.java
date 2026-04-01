package vn.xuandat.Warehouse_management.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import vn.xuandat.Warehouse_management.entity.User;
import vn.xuandat.Warehouse_management.service.UserService;




// MVC => , View <-> Controller ---Service ---Repository--- Model(entity)
@Controller
public class UsersController {
    private final UserService userService;
    // private final PasswordEncoder passwordEncoder;
    public UsersController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/admin/users")
    public String getAllUsers(@RequestParam(name="keyword", required = false) String keyword,
                            @RequestParam(name="page", defaultValue="0") int page, 
                            Model model) {
        int pageSize = 5;
        Pageable pageable = PageRequest.of(page, pageSize);
        Page<User> userPage = this.userService.getPagedUsers(keyword, pageable);
        if (page < 0 || page >= userPage.getTotalPages() && userPage.getTotalPages() > 0) {
            return "redirect:/admin/users?page=0";      
        }
        model.addAttribute("users", userPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", userPage.getTotalPages());

        model.addAttribute("currentUser", this.userService.getCurrentUser());
        return "admin/user/show-users";
    }

    @GetMapping("/admin/users/create")
    public String createUser(Model model) {
        User newUser = new User();
        model.addAttribute("newUser", newUser);
        return "admin/user/create-user";
    }
    
    @PostMapping("/admin/users/create")
    public String postCreateUser(@ModelAttribute("newUser") User newUser, Model model) {
        // String hashPasswordd = passwordEncoder.encode(newUser.getPassword());
        // newUser.setPassword(hashPasswordd);
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
