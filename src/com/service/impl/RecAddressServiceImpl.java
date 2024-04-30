package com.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.entity.RecAddress;
import com.mapper.RecAddressMapper;
import com.service.RecAddressService;

@Service
public class RecAddressServiceImpl implements RecAddressService {

	@Autowired
	private RecAddressMapper recAddressMapper;

	@Override
	public int deleteByPrimaryKey(String id) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insert(RecAddress record) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insertSelective(RecAddress record) {
		// TODO Auto-generated method stub
		return recAddressMapper.insertSelective(record);
	}

	@Override
	public RecAddress selectByPrimaryKey(String id) {
		// TODO Auto-generated method stub
		return recAddressMapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(RecAddress record) {
		// TODO Auto-generated method stub
		return recAddressMapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(RecAddress record) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public List<RecAddress> getList(RecAddress record) {
		// TODO Auto-generated method stub
		return recAddressMapper.getList(record);
	}

	@Override
	public int getTotal(RecAddress record) {
		return this.recAddressMapper.getTotal(record);
	}
}