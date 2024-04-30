package com.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.entity.Admin;
import com.mapper.AdminMapper;
import com.service.AdminService;

@Service
public class AdminServiceImpl implements AdminService {

	@Autowired
	private AdminMapper adminMapper;

	@Override
	public int deleteByPrimaryKey(String id) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insert(Admin record) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insertSelective(Admin record) {
		// TODO Auto-generated method stub
		return adminMapper.insertSelective(record);
	}

	@Override
	public Admin selectByPrimaryKey(String id) {
		// TODO Auto-generated method stub
		return adminMapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(Admin record) {
		// TODO Auto-generated method stub
		return adminMapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(Admin record) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public Admin login(Admin record) {
		return adminMapper.login(record);
	}

	@Override
	public List<Admin> getList(Admin record) {
		// TODO Auto-generated method stub
		return adminMapper.getList(record);
	}

	public int getTotal(Admin record) {
		return this.adminMapper.getTotal(record);
	}

	@Override
	public int checkRepeat(Admin record) {
		return this.adminMapper.checkRepeat(record);
	}
}