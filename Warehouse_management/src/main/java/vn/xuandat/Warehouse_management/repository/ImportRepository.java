package vn.xuandat.Warehouse_management.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
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
                and (:importCode is null or i.code like concat("%", :importCode, "%"))
                """)
                Page<Import> getPagedImport(@Param("userId") Long userId, 
                                                @Param("importCode") String importCode, 
                                                Pageable pageable);

        @Query("""
                select count(*)
                from Import i
                where month(i.date) = month(current_date())
                and year(i.date) = year(current_date())
        """)
        long countImportsInCurrentMonth();  


        List<Import> findTop5ByOrderByDateDesc();

        List<Import> findByDateGreaterThanEqual(LocalDateTime fromDate);

        boolean existsByCode(String code);

}
