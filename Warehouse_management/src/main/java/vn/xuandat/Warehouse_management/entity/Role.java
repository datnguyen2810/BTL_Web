package vn.xuandat.Warehouse_management.entity;

import java.util.List;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "roles")
@Setter
@Getter
@NoArgsConstructor // public Role() {}
@AllArgsConstructor // public Role(Long id, String name, List<User> users) { this.id = id; this.name = name; this.users = users; }

public class Role {
    @Id // danh dau day la primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    // 1 user co 1 role
    // 1 role co nhieu user

    @OneToMany(mappedBy = "role")
    // list la interface co nhieu implement, arraylist la 1 implement cua list -> list linh hoat hon
    private List <User> users;



}
