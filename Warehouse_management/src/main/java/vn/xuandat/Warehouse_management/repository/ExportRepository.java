package vn.xuandat.Warehouse_management.repository;

import java.util.List;

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
            and (:exportId is null or e.id = :exportId)
            """)
            List<Export> searchExports(@Param("userId") Long userID,@Param("exportId") Long exportId);

            
    List<Export> findTop5ByOrderByDateDesc();
}
