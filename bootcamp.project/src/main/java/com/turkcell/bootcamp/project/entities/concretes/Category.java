package com.turkcell.bootcamp.project.entities.concretes;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name="categories")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Category {
    @Id
    @Column(name="category_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private short categoryId;

    @Column(name="category_name")
    private String categoryName;

    @Column(name="description")
    private String description;

    @Column(name="picture")
    private byte[] picture;

    // değişkenin ismi!!
    @OneToMany(mappedBy = "category")
    private List<Product> products;
}
