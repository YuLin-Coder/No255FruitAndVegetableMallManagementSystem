package com.mapper;

import java.util.List;

import com.entity.OrdersInfo;

public interface OrdersInfoMapper {
    int deleteByPrimaryKey(String id);

    int insert(OrdersInfo record);

    int insertSelective(OrdersInfo record);

    OrdersInfo selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(OrdersInfo record);

    int updateByPrimaryKey(OrdersInfo record);

	List<OrdersInfo> getList(OrdersInfo ordersInfo);
}