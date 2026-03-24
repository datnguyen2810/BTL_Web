package vn.xuandat.Warehouse_management.service;

import java.util.ArrayList;
import java.util.Optional;

import org.springframework.stereotype.Service;

import vn.xuandat.Warehouse_management.entity.User;
import vn.xuandat.Warehouse_management.repository.UserRepository;

@Service
public class UserService {
    private final UserRepository userRepository;
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public ArrayList<User> handleGetAllUsers() {
        return (ArrayList<User>) this.userRepository.findAll();
    }

    public void handleSaveUser(User user) {
        this.userRepository.save(user);
    }

    public void handleDeleteUser(Long id){
        this.userRepository.deleteById(id);
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

    

}
