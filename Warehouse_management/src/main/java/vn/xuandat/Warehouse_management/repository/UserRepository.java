package vn.xuandat.Warehouse_management.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import vn.xuandat.Warehouse_management.entity.User;

@Repository
public interface  UserRepository extends JpaRepository<User, Long> {

    User findByEmail(String email);
    
}
