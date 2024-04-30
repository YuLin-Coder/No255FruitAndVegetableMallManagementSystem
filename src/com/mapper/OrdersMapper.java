package com.mapper;

import java.util.List;

import com.entity.Orders;

public interface OrdersMapper {
    int deleteByPrimaryKey(String id);

    int insert(Orders record);

    int insertSelective(Orders record);

    Orders selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Orders record);

    int updateByPrimaryKey(Orders record);

	List<Orders> getList(Orders record);

	int getTotal(Orders record);
}