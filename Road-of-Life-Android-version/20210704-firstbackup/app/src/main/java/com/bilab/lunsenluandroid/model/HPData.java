package com.bilab.lunsenluandroid.model;


public class HPData {
    private int id;
    private String time;
    private String detail;
    private int state;
    private  Boolean edit;



    public HPData() {
    }

    public HPData(int id, String time, String detail, int state,Boolean edit) {
        this.id = id;
        this.time = time;
        this.detail = detail;
        this.state = state;
        this.edit = edit;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getDetail() {
        return detail;
    }

    public void setDetail(String detail) {
        this.detail = detail;
    }

    public int getState() {
        return state;
    }

    public void setState(int state) {
        this.state = state;
    }

    public Boolean getEdit() {
        return edit;
    }

    public void setEdit(Boolean edit) {
        this.edit = edit;
    }
}
