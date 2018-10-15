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

package com.rebuild.server.bizz.privileges;

import com.rebuild.server.bizz.RoleService;
import com.rebuild.server.bizz.UserService;
import com.rebuild.server.helper.cache.RecordOwningCache;

import cn.devezhao.bizz.privileges.DepthEntry;
import cn.devezhao.bizz.privileges.Permission;
import cn.devezhao.bizz.privileges.Privileges;
import cn.devezhao.bizz.privileges.impl.BizzDepthEntry;
import cn.devezhao.bizz.privileges.impl.BizzPermission;
import cn.devezhao.bizz.security.member.Role;
import cn.devezhao.bizz.security.member.User;
import cn.devezhao.persist4j.engine.ID;

/**
 * 实体安全/权限 管理
 * 
 * @author Zhao Fangfang
 * @since 1.0, 2013-6-21
 * 
 * @see Role
 * @see BizzPermission
 * @see BizzDepthEntry
 */
public class SecurityManager {
	
	final private UserStore USER_STORE;
	final private RecordOwningCache RECORDOWNING_CACHE;

	/**
	 * @param us
	 * @param roc
	 */
	public SecurityManager(UserStore us, RecordOwningCache roc) {
		this.USER_STORE = us;
		this.RECORDOWNING_CACHE = roc;
	}
	
	/**
	 * @param target
	 * @return
	 */
	public ID getOwningUser(ID target) {
		return RECORDOWNING_CACHE.getOwningUser(target);
	}
	
	/**
	 * 获取指定实体的权限集合
	 * 
	 * @param userId
	 * @param entity
	 * @return
	 */
	public Privileges getPrivileges(ID user, int entity) {
		Role role = USER_STORE.getUser(user).getOwningRole();
		return role.getPrivileges(entity);
	}
	
	/**
	 * 创建权限
	 * 
	 * @param user
	 * @param entity
	 * @return
	 */
	public boolean allowedC(ID user, int entity) {
		return allowed(user, entity, BizzPermission.CREATE);
	}
	
	/**
	 * 删除权限
	 * 
	 * @param user
	 * @param entity
	 * @return
	 */
	public boolean allowedD(ID user, int entity) {
		return allowed(user, entity, BizzPermission.DELETE);
	}
	
	/**
	 * 更新权限
	 * 
	 * @param user
	 * @param entity
	 * @return
	 */
	public boolean allowedU(ID user, int entity) {
		return allowed(user, entity, BizzPermission.UPDATE);
	}
	
	/**
	 * 读取权限
	 * 
	 * @param user
	 * @param entity
	 * @return
	 */
	public boolean allowedR(ID user, int entity) {
		return allowed(user, entity, BizzPermission.READ);
	}
	
	/**
	 * 分派权限
	 * 
	 * @param user
	 * @param entity
	 * @return
	 */
	public boolean allowedA(ID user, int entity) {
		return allowed(user, entity, BizzPermission.ASSIGN);
	}
	
	/**
	 * 共享权限
	 * 
	 * @param user
	 * @param entity
	 * @return
	 */
	public boolean allowedS(ID user, int entity) {
		return allowed(user, entity, BizzPermission.SHARE);
	}
	
	/**
	 * 创建权限
	 * 
	 * @param user
	 * @param target
	 * @return
	 */
	public boolean allowedC(ID user, ID target) {
		return allowed(user, target, BizzPermission.CREATE);
	}
	
	/**
	 * 删除权限
	 * 
	 * @param user
	 * @param target
	 * @return
	 */
	public boolean allowedD(ID user, ID target) {
		return allowed(user, target, BizzPermission.DELETE);
	}
	
	/**
	 * 更新权限
	 * 
	 * @param user
	 * @param target
	 * @return
	 */
	public boolean allowedU(ID user, ID target) {
		return allowed(user, target, BizzPermission.UPDATE);
	}
	
	/**
	 * 读取权限
	 * 
	 * @param user
	 * @param target
	 * @return
	 */
	public boolean allowedR(ID user, ID target) {
		return allowed(user, target, BizzPermission.READ);
	}
	
	/**
	 * 分派权限
	 * 
	 * @param user
	 * @param target
	 * @return
	 */
	public boolean allowedA(ID user, ID target) {
		return allowed(user, target, BizzPermission.ASSIGN);
	}
	
	/**
	 * 共享权限
	 * 
	 * @param user
	 * @param target
	 * @return
	 */
	public boolean allowedS(ID user, ID target) {
		return allowed(user, target, BizzPermission.SHARE);
	}
	
	/**
	 * 是否对实体有指定权限
	 * 
	 * @param user
	 * @param entity 目标实体
	 * @param action 权限动作
	 * @return
	 */
	public boolean allowed(ID user, int entity, Permission action) {
		if (UserService.ADMIN_USER.equals(user)) {
			return true;
		}
		
		Role role = USER_STORE.getUser(user).getOwningRole();
		if (RoleService.ADMIN_ROLE.equals(role.getIdentity())) {
			return true;
		}
		
		Privileges priv = role.getPrivileges(entity);
		return priv.allowed(action);
	}
	
	/**
	 * 是否对指定记录有指定权限
	 * 
	 * @param user
	 * @param target 目标记录
	 * @param action 权限动作
	 * @return
	 */
	public boolean allowed(ID user, ID target, Permission action) {
		if (UserService.ADMIN_USER.equals(user)) {
			return true;
		}
		
		Role role = USER_STORE.getUser(user).getOwningRole();
		if (RoleService.ADMIN_ROLE.equals(role.getIdentity())) {
			return true;
		}
		
		final int entity = target.getEntityCode();
		
		Privileges priv = role.getPrivileges(entity);
		boolean allowed = priv.allowed(action);
		if (!allowed) {
			return false;
		}
		
		DepthEntry depth = priv.superlative(action);
		
		if (BizzDepthEntry.NONE.equals(depth)) {
			return false;
		}
		if (BizzDepthEntry.GLOBAL.equals(depth)) {
			return true;
		}
		
		ID targetUserId = RECORDOWNING_CACHE.getOwningUser(target);
		
		if (BizzDepthEntry.PRIVATE.equals(depth)) {
			allowed = user.equals(targetUserId);
			if (allowed == false) {
				return allowedViaShare(user, user, action);
			}
			return true;
		}
		
		com.rebuild.server.bizz.privileges.User accessUser = USER_STORE.getUser(user);
		com.rebuild.server.bizz.privileges.User targetUser = USER_STORE.getUser(targetUserId);
		Department accessUserDept = (Department) accessUser.getOwningDept();
		
		if (BizzDepthEntry.LOCAL.equals(depth)) {
			allowed = accessUserDept.equals(targetUser.getOwningDept());
			if (allowed == false) {
				return allowedViaShare(user, user, action);
			}
			return true;
		}
		
		if (BizzDepthEntry.DEEPDOWN.equals(depth)) {
			if (accessUserDept.equals(targetUser.getOwningDept())) {
				return true;
			}
			
			allowed = accessUserDept.isChildrenAll((Department) targetUser.getOwningDept());
			if (allowed == false) {
				return allowedViaShare(user, user, action);
			}
			return true;
		}
		
		return false;
	}
	
	/**
	 * TODO 通过共享取得的操作权限
	 * 
	 * @param user
	 * @param target
	 * @param action
	 * @return
	 */
	private boolean allowedViaShare(ID user, ID target, Permission action) {
		return false;
	}
	
	/**
	 * 创建查询过滤器
	 * 
	 * @param user
	 * @return
	 */
	public QueryFilter createQueryFilter(ID user) {
		if (UserService.ADMIN_USER.equals(user)) {
			return QueryFilter.ALLOWED;
		}
		
		User sUser = USER_STORE.getUser(user);
		Role role = sUser.getOwningRole();
		if (RoleService.ADMIN_ROLE.equals(role.getIdentity())) {
			return QueryFilter.ALLOWED;
		}
		return new QueryFilter(sUser);
	}
}