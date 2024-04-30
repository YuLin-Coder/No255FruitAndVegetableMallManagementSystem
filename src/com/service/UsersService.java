package com.service;

import java.util.List;

import com.entity.Users;

public interface UsersService {
	int deleteByPrimaryKey(String id);

	int insert(Users record);

	int insertSelective(Users record);

	Users selectByPrimaryKey(String id);

	int updateByPrimaryKeySelective(Users record);

	int updateByPrimaryKey(Users record);

	Users login(Users record);
	
	List<Users> getList(Users record);
	
	int checkRepeat(Users record);

	int getTotal(Users record);
}