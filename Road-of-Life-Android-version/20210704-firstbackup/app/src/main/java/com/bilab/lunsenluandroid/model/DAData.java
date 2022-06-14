package com.bilab.lunsenluandroid.model;


public class DAData {
    private int id;
    private String name;
    private String hospital;
    private String department;
    //private String image;



    public DAData() {
    }

    public DAData(int id, String name, String hospital, String department) {
        this.id = id;
        this.name = name;
        this.hospital = hospital;
        this.department = department;
        //this.image = image;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getHospital() {
        return hospital;
    }

    public void setHospital(String hospital) {
        this.hospital = hospital;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    /*public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }*/
}
