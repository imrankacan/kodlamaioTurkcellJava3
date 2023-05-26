package com.turkcell.bootcamp.project.entities.concretes;

import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name="products")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Product {
    @Column(name="product_id")
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private short productId;

    @Column(name = "unit_price")
    private float unitPrice;

    @ManyToOne()
    @JoinColumn(name="category_id")
    private Category category;
}
