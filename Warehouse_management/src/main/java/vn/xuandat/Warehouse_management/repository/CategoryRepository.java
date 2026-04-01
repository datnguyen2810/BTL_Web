package vn.xuandat.Warehouse_management.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.xuandat.Warehouse_management.entity.Category;

@Repository
public interface  CategoryRepository extends JpaRepository<Category, Long>{

    @Query("""
            select c
            from Category c
            where (:keyword is null
                or lower(c.name) like lower(concat('%', :keyword, '%')))
            """)
    Page<Category> searchCategories(@Param("keyword") String keyword, Pageable pageable);
    
}
