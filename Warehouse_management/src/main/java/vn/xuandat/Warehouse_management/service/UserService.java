package vn.xuandat.Warehouse_management.service;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import vn.xuandat.Warehouse_management.entity.User;
import vn.xuandat.Warehouse_management.repository.UserRepository;

@Service
public class UserService {
    private final UserRepository userRepository;
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }
    public List<User> handleGetAllUsers() {
        return this.userRepository.findAll();
    }

    public Page<User> getPagedUsers(String keyword, Pageable pageable) {
        if(keyword != null && keyword.trim().isEmpty()) {
            keyword = null;
        }
        return this.userRepository.getPagedUsers(keyword, pageable);
    }

    public void handleSaveUser(User user) {
        this.userRepository.save(user);
    }

    public void handleDeleteUser(Long id){
        this.userRepository.handleDeleteUser(id);
    }

    public User fetchUserById(Long id) {
        Optional<User> userOptional = this.userRepository.findById(id);
        if(userOptional.isPresent()){
            return userOptional.get();
        }
        return null;
        // return this.userRepository.findById(id).orElse(null);
    }

    public User getUserByEmail(String email) {
        return this.userRepository.findByEmail(email);
    }

    public User getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName();
        return userRepository.findByEmail(email);
    }

    

}
