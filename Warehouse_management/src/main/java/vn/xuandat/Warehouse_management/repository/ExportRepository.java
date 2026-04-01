package vn.xuandat.Warehouse_management.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.xuandat.Warehouse_management.entity.Export;

@Repository
public interface  ExportRepository extends JpaRepository<Export, Long>{
    @Query("""
            select e 
            from Export e
            where (:userId is null or e.userExport.id = :userId)
            and (:exportCode is null or e.code like %:exportCode%)
            """)
            Page<Export> getPagedExport(@Param("userId") Long userID, 
                                        @Param("exportCode") String exportCode, 
                                        Pageable pageable);

            
    List<Export> findTop5ByOrderByDateDesc();

    List<Export> findByDateGreaterThanEqual(LocalDateTime fromDate);

    boolean existsByCode(String exportCode);
    
}
