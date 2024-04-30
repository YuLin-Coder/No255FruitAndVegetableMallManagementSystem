package com.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.entity.GoodsType;
import com.mapper.GoodsTypeMapper;
import com.service.GoodsTypeService;

@Service
public class GoodsTypeServiceImpl implements GoodsTypeService {

	@Autowired
	private GoodsTypeMapper goodsTypeMapper;

	@Override
	public int deleteByPrimaryKey(String id) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insert(GoodsType record) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insertSelective(GoodsType record) {
		// TODO Auto-generated method stub
		return goodsTypeMapper.insertSelective(record);
	}

	@Override
	public GoodsType selectByPrimaryKey(String id) {
		// TODO Auto-generated method stub
		return goodsTypeMapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(GoodsType record) {
		// TODO Auto-generated method stub
		return goodsTypeMapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(GoodsType record) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public List<GoodsType> getList(GoodsType record) {
		// TODO Auto-generated method stub
		return goodsTypeMapper.getList(record);
	}
	
	@Override
	public int getTotal(GoodsType record) {
		return this.goodsTypeMapper.getTotal(record);
	}

	@Override
	public int checkRepeat(GoodsType record) {
		return this.goodsTypeMapper.checkRepeat(record);
	}
}