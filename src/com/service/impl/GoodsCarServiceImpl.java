package com.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.entity.GoodsCar;
import com.mapper.GoodsCarMapper;
import com.service.GoodsCarService;

@Service
public class GoodsCarServiceImpl implements GoodsCarService {

	@Autowired
	private GoodsCarMapper goodsCarMapper;

	@Override
	public int deleteByPrimaryKey(String id) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insert(GoodsCar record) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insertSelective(GoodsCar record) {
		// TODO Auto-generated method stub
		return goodsCarMapper.insertSelective(record);
	}

	@Override
	public GoodsCar selectByPrimaryKey(String id) {
		// TODO Auto-generated method stub
		return goodsCarMapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(GoodsCar record) {
		// TODO Auto-generated method stub
		return goodsCarMapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(GoodsCar record) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public List<GoodsCar> getList(GoodsCar record) {
		// TODO Auto-generated method stub
		return goodsCarMapper.getList(record);
	}

	@Override
	public int getTotal(GoodsCar record) {
		return this.goodsCarMapper.getTotal(record);
	}

	@Override
	public GoodsCar getGoodsByGoodsId(GoodsCar record) {
		// TODO Auto-generated method stub
		return this.goodsCarMapper.getGoodsByGoodsId(record);
	}
}