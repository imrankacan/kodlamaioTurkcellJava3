package com.turkcell;

public class Student {
    private String id;
    private String name;

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getId() {
        id= String.valueOf(name.charAt(0));
        System.out.println(id);
        return id;
    }
    public Student() {
    }
    public void rentABook(String name, String bookName) {
        Books books = new Books();
        this.name = name;
        books.name = bookName;
    }
}
