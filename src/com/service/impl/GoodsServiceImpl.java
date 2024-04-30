package com.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.entity.Goods;
import com.mapper.GoodsMapper;
import com.service.GoodsService;

@Service
public class GoodsServiceImpl implements GoodsService {

	@Autowired
	private GoodsMapper goodsMapper;

	@Override
	public int deleteByPrimaryKey(String id) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insert(Goods record) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insertSelective(Goods record) {
		// TODO Auto-generated method stub
		return goodsMapper.insertSelective(record);
	}

	@Override
	public Goods selectByPrimaryKey(String id) {
		// TODO Auto-generated method stub
		return goodsMapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(Goods record) {
		// TODO Auto-generated method stub
		return goodsMapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(Goods record) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public List<Goods> getList(Goods record) {
		// TODO Auto-generated method stub
		return goodsMapper.getList(record);
	}

	@Override
	public int getTotal(Goods record) {
		return this.goodsMapper.getTotal(record);
	}

	@Override
	public List<Goods> selectBuyGoodsList(String[] goodsId) {
		// TODO Auto-generated method stub
		return this.goodsMapper.selectBuyGoodsList(goodsId);
	}

	@Override
	public List<Goods> selectBuyCarGoodsList(Goods goodsCar) {
		// TODO Auto-generated method stub
		return this.goodsMapper.selectBuyCarGoodsList(goodsCar);
	}
}