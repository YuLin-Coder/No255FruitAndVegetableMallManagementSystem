package com.service;

import java.util.List;

import com.entity.GoodsCar;


public interface GoodsCarService {
	int deleteByPrimaryKey(String id);

	int insert(GoodsCar record);

	int insertSelective(GoodsCar record);

	GoodsCar selectByPrimaryKey(String id);

	int updateByPrimaryKeySelective(GoodsCar record);

	int updateByPrimaryKey(GoodsCar record);
	
	List<GoodsCar> getList(GoodsCar record);

	int getTotal(GoodsCar record);

	GoodsCar getGoodsByGoodsId(GoodsCar goodsCar);
}