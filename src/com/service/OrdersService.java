package com.service;

import java.util.List;

import com.entity.Orders;
import com.entity.OrdersInfo;


public interface OrdersService {
	int deleteByPrimaryKey(String id);

	int insert(Orders record);

	int insertSelective(Orders record);

	Orders selectByPrimaryKey(String id);

	int updateByPrimaryKeySelective(Orders record);

	int updateByPrimaryKey(Orders record);
	
	List<Orders> getList(Orders record);

	int getTotal(Orders record);

	void insertSelective(OrdersInfo ordersInfo);

	List<OrdersInfo> getInfoList(OrdersInfo ordersInfo);

	void updateByPrimaryKeySelective(OrdersInfo evelInfo);
}