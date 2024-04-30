package com.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.entity.Users;
import com.mapper.UsersMapper;
import com.service.UsersService;

@Service
public class UsersServiceImpl implements UsersService {

	@Autowired
	private UsersMapper usersMapper;

	@Override
	public int deleteByPrimaryKey(String id) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insert(Users record) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insertSelective(Users record) {
		// TODO Auto-generated method stub
		return usersMapper.insertSelective(record);
	}

	@Override
	public Users selectByPrimaryKey(String id) {
		// TODO Auto-generated method stub
		return usersMapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(Users record) {
		// TODO Auto-generated method stub
		return usersMapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(Users record) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public Users login(Users record) {
		return usersMapper.login(record);
	}

	@Override
	public List<Users> getList(Users record) {
		// TODO Auto-generated method stub
		return usersMapper.getList(record);
	}

	@Override
	public int getTotal(Users record) {
		return this.usersMapper.getTotal(record);
	}

	@Override
	public int checkRepeat(Users record) {
		return this.usersMapper.checkRepeat(record);
	}

}