package com.mapper;

import java.util.List;

import com.entity.Goods;

public interface GoodsMapper {
    int deleteByPrimaryKey(String id);

    int insert(Goods record);

    int insertSelective(Goods record);

    Goods selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Goods record);

    int updateByPrimaryKey(Goods record);

	List<Goods> getList(Goods record);

	int getTotal(Goods record);

	List<Goods> selectBuyGoodsList(String[] goodsId);

	List<Goods> selectBuyCarGoodsList(Goods goodsCar);
}