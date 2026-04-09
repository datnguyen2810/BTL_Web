package vn.xuandat.Warehouse_management.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import jakarta.transaction.Transactional;
import vn.xuandat.Warehouse_management.entity.ExportDetail;

public interface  ExportDetailRepository extends JpaRepository<ExportDetail, Object> {

    @Modifying
    @Transactional
    @Query("""
            delete from ExportDetail d
            where d.exportEntity.id = :exportId
            """)
    void deleteByExportId(@Param("exportId") Long exportId);

    boolean existsByMaterialId(Long id);

    @Query("""
            select coalesce(sum(d.export_quantity), 0)
            from ExportDetail d
            where d.exportEntity.id = :exportId
            """)
    public long sumQuantityByExportId(@Param("exportId") Long id);
    
}
