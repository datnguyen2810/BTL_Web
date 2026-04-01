package vn.xuandat.Warehouse_management.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import jakarta.transaction.Transactional;
import vn.xuandat.Warehouse_management.entity.ImportDetail;

public interface ImportDetailRepository extends JpaRepository<ImportDetail, Long> {
    @Modifying // BẮT BUỘC phải có cho lệnh DELETE/UPDATE
    @Transactional // Đảm bảo tính toàn vẹn dữ liệu
    @Query("""
            delete from ImportDetail d
            where d.importEntity.id = :id
            """)
    public void deleteByImportId(@Param("id") Long id);

    @Query("""
            select d from ImportDetail d
            where d.importEntity.id = :id
            """)
    public List<ImportDetail> findByImportId(@Param("id") Long id);
    
    public boolean existsByMaterialId(Long id);
}
