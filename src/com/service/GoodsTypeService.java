package com.service;

import java.util.List;

import com.entity.GoodsType;


public interface GoodsTypeService {
	int deleteByPrimaryKey(String id);

	int insert(GoodsType record);

	int insertSelective(GoodsType record);

	GoodsType selectByPrimaryKey(String id);

	int updateByPrimaryKeySelective(GoodsType record);

	int updateByPrimaryKey(GoodsType record);
	
	List<GoodsType> getList(GoodsType record);

	int checkRepeat(GoodsType record);

	int getTotal(GoodsType record);
}