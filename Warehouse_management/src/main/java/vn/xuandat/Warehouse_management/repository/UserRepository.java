package vn.xuandat.Warehouse_management.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import jakarta.transaction.Transactional;
import vn.xuandat.Warehouse_management.entity.User;

@Repository
public interface  UserRepository extends JpaRepository<User, Long> {

    User findByEmail(String email);

    @Modifying
    @Transactional
    @Query("""
            update User u
            set u.deleted_at = current_timestamp
            where u.id = :id
            """)
    public void handleDeleteUser(@Param("id") Long id);

    @Query("""
        select u from User u
        where u.deleted_at IS NULL 
        and (:keyword is null or u.email like %:keyword% or u.fullName like %:keyword%)
        """)
    Page<User> getPagedUsers(@Param("keyword") String keyword, Pageable pageable);
    
}
