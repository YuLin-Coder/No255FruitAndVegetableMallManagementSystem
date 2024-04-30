package com.mapper;

import java.util.List;

import com.entity.GoodsCar;

public interface GoodsCarMapper {
    int deleteByPrimaryKey(String id);

    int insert(GoodsCar record);

    int insertSelective(GoodsCar record);

    GoodsCar selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(GoodsCar record);

    int updateByPrimaryKey(GoodsCar record);

	List<GoodsCar> getList(GoodsCar record);

	int getTotal(GoodsCar record);

	GoodsCar getGoodsByGoodsId(GoodsCar record);
}