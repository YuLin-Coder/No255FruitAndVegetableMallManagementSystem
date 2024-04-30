package com.service;

import java.util.List;

import com.entity.Admin;

public interface AdminService {
    int deleteByPrimaryKey(String id);

    int insert(Admin record);

    int insertSelective(Admin record);

    Admin selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Admin record);

    int updateByPrimaryKey(Admin record);

	Admin login(Admin record);
	
	List<Admin> getList(Admin record);

	int checkRepeat(Admin record);

	int getTotal(Admin admin);
}