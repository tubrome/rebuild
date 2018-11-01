/*
rebuild - Building your system freely.
Copyright (C) 2018 devezhao <zhaofang123@gmail.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.
*/

package com.rebuild.server.service;

import java.util.Observable;

import com.rebuild.server.Application;
import com.rebuild.server.metadata.EntityHelper;

import cn.devezhao.bizz.privileges.impl.BizzPermission;
import cn.devezhao.persist4j.PersistManagerFactory;
import cn.devezhao.persist4j.Record;
import cn.devezhao.persist4j.engine.ID;

/**
 * 持久层服务
 * 
 * @author zhaofang123@gmail.com
 * @since 05/21/2017
 */
public abstract class BaseService extends Observable {
	
	final protected PersistManagerFactory aPMFactory;

	protected BaseService(PersistManagerFactory aPMFactory) {
		super();
		this.aPMFactory = aPMFactory;
	}

	/**
	 * 语法糖
	 * 
	 * @param record
	 * @return
	 * @see #create(Record)
	 * @see #update(Record)
	 */
	public Record createOrUpdate(Record record) {
		return record.getPrimary() == null ? create(record) : update(record);
	}
	
	/**
	 * @param record
	 * @return
	 */
	public Record create(Record record) {
		record = aPMFactory.createPersistManager().save(record);
		if (countObservers() > 0) {
			setChanged();
			notifyObservers(OperateContext.valueOf(record.getEditor(), BizzPermission.CREATE, null, record));
		}
		return record;
	}

	/**
	 * @param record
	 * @return
	 */
	public Record update(Record record) {
		record = aPMFactory.createPersistManager().update(record);
		if (countObservers() > 0) {
			setChanged();
			notifyObservers(OperateContext.valueOf(record.getEditor(), BizzPermission.UPDATE, getBeforeRecord(record), record));
		}
		return record;
	}

	/**
	 * @param recordId
	 * @return 删除记录数量。包括关联的记录，自定义实体都选择了 remove-link 级联模式，因此基本不会自动关联删除
	 */
	public int delete(ID recordId) {
		int affected = aPMFactory.createPersistManager().delete(recordId);
		if (countObservers() > 0) {
			setChanged();
			Record deleted = EntityHelper.forUpdate(recordId, Application.currentCallerUser());
			notifyObservers(OperateContext.valueOf(deleted.getEditor(), BizzPermission.DELETE, deleted, null));
		}
		return affected;
	}
	
	/**
	 * 操作前获取记录
	 * 
	 * @return
	 */
	protected Record getBeforeRecord(Record willUpdate) {
		return null;
	}
}
