package vn.xuandat.Warehouse_management.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.xuandat.Warehouse_management.entity.InventoryDTO;
import vn.xuandat.Warehouse_management.entity.Material;

@Repository
public interface MaterialRepository extends JpaRepository<Material, Long> {
    List<Material> findByCategoryId(Long categoryId);
    @Query("""
            select m 
            from Material m
            where (:categoryId is null or m.category.id = :categoryId)
            and (
                :keyword is null 
                or lower(m.name) like lower(concat('%', :keyword, '%')))
            """)
    List<Material> searchMaterials(@Param("categoryId") Long categoryId, 
                                  @Param("keyword") String keyword);

    @Query("""
        select (
            select coalesce(sum(id.import_quantity), 0)
            from ImportDetail id 
            where id.material.id = :materialId
            - 
            (select coalesce(sum(ed.export_quantity), 0)
             from ExportDetail ed
             where ed.material.id = :materialId)
        ) """)
    long calculateCurrentStock(@Param("materialId") Long materialId);


    @Query("""
        select new vn.xuandat.Warehouse_management.entity.InventoryDTO(
            m.id, m.name, m.unit,
            (select coalesce(sum(id.import_quantity), 0) from ImportDetail id where id.material.id = m.id),
            (select coalesce(sum(ed.export_quantity), 0) from ExportDetail ed where ed.material.id = m.id)
        )
        from Material m
        where (select count(id) from ImportDetail id where id.material.id = m.id) > 0
        and (:categoryId is null or m.category.id = :categoryId)
        and (:keyword is null 
            or lower(m.name) like lower(concat('%', :keyword, '%')) 
            or cast(m.id as string) like lower(concat('%', :keyword, '%')))
    """)

    List<InventoryDTO> getInventoryReport(@Param("keyword") String keyword, @Param("categoryId") Long categoryId);
    
    @Query("""
            select count(*)
            from Material m
            where (select count(id) from ImportDetail id where id.material.id = m.id) > 0
            and (select coalesce(sum(id.import_quantity), 0) from ImportDetail id where id.material.id = m.id) 
            - (select coalesce(sum(ed.export_quantity), 0) from ExportDetail ed where ed.material.id = m.id) < 10
            """)
    long countLowStockMaterials();
}
