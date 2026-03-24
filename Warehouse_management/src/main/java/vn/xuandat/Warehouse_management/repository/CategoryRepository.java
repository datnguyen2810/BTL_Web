package vn.xuandat.Warehouse_management.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import vn.xuandat.Warehouse_management.entity.Category;

@Repository
public interface  CategoryRepository extends JpaRepository<Category, Long>{
    
}
