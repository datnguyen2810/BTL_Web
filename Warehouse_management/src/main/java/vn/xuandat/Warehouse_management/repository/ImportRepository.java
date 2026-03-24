package vn.xuandat.Warehouse_management.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.xuandat.Warehouse_management.entity.Import;

@Repository
public interface ImportRepository extends JpaRepository<Import, Long> {
    @Query("""
            select i from Import i
            where (:userId is null or i.userImport.id = :userId)
            and (:importId is null or i.id = :importId)
            """)
            List<Import> searchImports(@Param("userId") Long userId, 
                                        @Param("importId") Long importId);

    List<Import> findTop5ByOrderByDateDesc();

    @Query("""
            select count(*)
            from Import i
            where month(i.date) = month(current_date())
            and year(i.date) = year(current_date())
    """)
    long countImportsInCurrentMonth();  
}
