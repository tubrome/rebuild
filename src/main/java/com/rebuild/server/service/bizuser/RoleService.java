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

package com.rebuild.server.service.bizuser;

import com.rebuild.server.metadata.EntityHelper;
import com.rebuild.server.service.BaseService;

import cn.devezhao.persist4j.PersistManagerFactory;
import cn.devezhao.persist4j.engine.ID;

/**
 * 
 * @author zhaofang123@gmail.com
 * @since 08/03/2018
 */
public class RoleService extends BaseService {

	/**
	 * 管理员权限
	 */
	public static final ID ADMIN_ROLE = ID.valueOf("003-0000000000000001");
	
	protected RoleService(PersistManagerFactory persistManagerFactory) {
		super(persistManagerFactory);
	}

	@Override
	public int getEntity() {
		return EntityHelper.Role;
	}
}