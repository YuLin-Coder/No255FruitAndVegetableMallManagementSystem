package com.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.entity.Orders;
import com.entity.OrdersInfo;
import com.mapper.OrdersInfoMapper;
import com.mapper.OrdersMapper;
import com.service.OrdersService;

@Service
public class OrdersServiceImpl implements OrdersService {

	@Autowired
	private OrdersMapper ordersMapper;
	@Autowired
	private OrdersInfoMapper ordersInfoMapper;

	@Override
	public int deleteByPrimaryKey(String id) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insert(Orders record) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insertSelective(Orders record) {
		// TODO Auto-generated method stub
		return ordersMapper.insertSelective(record);
	}

	@Override
	public Orders selectByPrimaryKey(String id) {
		// TODO Auto-generated method stub
		return ordersMapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(Orders record) {
		// TODO Auto-generated method stub
		return ordersMapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(Orders record) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public List<Orders> getList(Orders record) {
		// TODO Auto-generated method stub
		return ordersMapper.getList(record);
	}

	@Override
	public int getTotal(Orders record) {
		return this.ordersMapper.getTotal(record);
	}

	@Override
	public void insertSelective(OrdersInfo ordersInfo) {
		// TODO Auto-generated method stub
		this.ordersInfoMapper.insertSelective(ordersInfo);
	}

	@Override
	public List<OrdersInfo> getInfoList(OrdersInfo ordersInfo) {
		// TODO Auto-generated method stub
		return this.ordersInfoMapper.getList(ordersInfo);
	}

	@Override
	public void updateByPrimaryKeySelective(OrdersInfo evelInfo) {
		this.ordersInfoMapper.updateByPrimaryKeySelective(evelInfo);
		
	}
}