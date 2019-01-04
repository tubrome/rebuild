-- Init db/user

CREATE DATABASE `rebuild10` DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
CREATE USER 'rebuild'@'127.0.0.1' IDENTIFIED BY 'rebuild';
GRANT ALL PRIVILEGES ON `rebuild10`.* TO 'rebuild'@'127.0.0.1';

USE `rebuild10`;

-- Init schemas
-- Generate by SchemaGen.java

-- ************ Entity [User] DDL ************
drop table if exists `user`;
create table /*!32312 if not exists*/ `user` (
  `AVATAR_URL`         varchar(300) comment '头像',
  `ROLE_ID`            char(20) comment '角色',
  `JOB_TITLE`          varchar(100) comment '职务',
  `DEPT_ID`            char(20) comment '部门',
  `FULL_NAME`          varchar(100) comment '姓名',
  `USER_ID`            char(20) not null,
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  `PASSWORD`           varchar(100) not null comment '登录密码',
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `CREATED_BY`         char(20) not null comment '创建人',
  `LOGIN_NAME`         varchar(100) not null comment '登录名',
  `QUICK_CODE`         varchar(70),
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `IS_DISABLED`        char(1) default 'F' comment '是否停用',
  `EMAIL`              varchar(100) comment '邮箱',
  primary key  (`USER_ID`),
  unique index `UIX1_user` (`LOGIN_NAME`),
  unique index `UIX2_user` (`EMAIL`)
)Engine=InnoDB;

-- ************ Entity [Department] DDL ************
drop table if exists `department`;
create table /*!32312 if not exists*/ `department` (
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `CREATED_BY`         char(20) not null comment '创建人',
  `DEPT_ID`            char(20) not null,
  `NAME`               varchar(100) not null comment '部门名称',
  `QUICK_CODE`         varchar(70),
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `IS_DISABLED`        char(1) default 'F' comment '是否停用',
  `PARENT_DEPT`        char(20) comment '父级部门',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  primary key  (`DEPT_ID`)
)Engine=InnoDB;

-- ************ Entity [Role] DDL ************
drop table if exists `role`;
create table /*!32312 if not exists*/ `role` (
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `CREATED_BY`         char(20) not null comment '创建人',
  `ROLE_ID`            char(20) not null,
  `NAME`               varchar(100) not null comment '角色名称',
  `QUICK_CODE`         varchar(70),
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `IS_DISABLED`        char(1) default 'F' comment '是否停用',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  primary key  (`ROLE_ID`)
)Engine=InnoDB;

-- ************ Entity [RolePrivileges] DDL ************
drop table if exists `role_privileges`;
create table /*!32312 if not exists*/ `role_privileges` (
  `PRIVILEGES_ID`      char(20) not null,
  `ROLE_ID`            char(20) not null,
  `DEFINITION`         varchar(100) comment '权限定义',
  `ZERO_KEY`           varchar(50) comment '其他权限KEY',
  `ENTITY`             int(11) not null default '0' comment '哪个实体',
  primary key  (`PRIVILEGES_ID`),
  unique index `UIX1_role_privileges` (`ROLE_ID`, `ENTITY`, `ZERO_KEY`)
)Engine=InnoDB;

-- ************ Entity [RoleMember] DDL ************
drop table if exists `role_member`;
create table /*!32312 if not exists*/ `role_member` (
  `ROLE_ID`            char(20),
  `USER_ID`            char(20),
  `MEMBER_ID`          char(20) not null,
  primary key  (`MEMBER_ID`)
)Engine=InnoDB;

-- ************ Entity [MetaEntity] DDL ************
drop table if exists `meta_entity`;
create table /*!32312 if not exists*/ `meta_entity` (
  `ENTITY_LABEL`       varchar(100) not null comment 'for description',
  `COMMENTS`           varchar(200),
  `ICON`               varchar(60),
  `NAME_FIELD`         varchar(100),
  `ENTITY_ID`          char(20) not null,
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  `MASTER_ENTITY`      varchar(100) comment '明细实体-所属主实体',
  `TYPE_CODE`          smallint(6) not null,
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `PHYSICAL_NAME`      varchar(100) not null,
  `CREATED_BY`         char(20) not null comment '创建人',
  `ENTITY_NAME`        varchar(100) not null,
  `MODIFIED_BY`        char(20) not null comment '修改人',
  primary key  (`ENTITY_ID`),
  unique index `UIX1_meta_entity` (`TYPE_CODE`),
  unique index `UIX2_meta_entity` (`ENTITY_NAME`),
  unique index `UIX3_meta_entity` (`PHYSICAL_NAME`)
)Engine=InnoDB;

-- ************ Entity [MetaField] DDL ************
drop table if exists `meta_field`;
create table /*!32312 if not exists*/ `meta_field` (
  `FIELD_NAME`         varchar(100) not null,
  `COMMENTS`           varchar(300),
  `NULLABLE`           char(1) default 'T',
  `DEFAULT_VALUE`      varchar(300),
  `CASCADE`            varchar(20) default 'ignore',
  `PRECISION`          smallint(6) default '6',
  `EXT_CONFIG`         varchar(700) comment '更多扩展配置，JSON格式KV',
  `BELONG_ENTITY`      varchar(100) not null,
  `CREATABLE`          char(1) default 'T',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  `DISPLAY_TYPE`       varchar(100) comment '显示类型.如链接/QQ/电话其实都是文本',
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `PHYSICAL_NAME`      varchar(100) not null,
  `CREATED_BY`         char(20) not null comment '创建人',
  `FIELD_LABEL`        varchar(100) not null comment 'for description',
  `REF_ENTITY`         varchar(100),
  `UPDATABLE`          char(1) default 'T',
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `MAX_LENGTH`         smallint(6) default '300',
  `FIELD_ID`           char(20) not null,
  primary key  (`FIELD_ID`),
  unique index `UIX1_meta_field` (`BELONG_ENTITY`, `FIELD_NAME`),
  unique index `UIX2_meta_field` (`BELONG_ENTITY`, `PHYSICAL_NAME`)
)Engine=InnoDB;

-- ************ Entity [PickList] DDL ************
drop table if exists `pick_list`;
create table /*!32312 if not exists*/ `pick_list` (
  `ITEM_ID`            char(20) not null,
  `IS_DEFAULT`         char(1) default 'F',
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `CREATED_BY`         char(20) not null comment '创建人',
  `BELONG_FIELD`       varchar(100) not null,
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `BELONG_ENTITY`      varchar(100) not null,
  `TEXT`               varchar(100) not null,
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  `SEQ`                int(11) default '0' comment '排序,小到大',
  `IS_HIDE`            char(1) default 'F',
  primary key  (`ITEM_ID`)
)Engine=InnoDB;

-- ************ Entity [LayoutConfig] DDL ************
drop table if exists `layout_config`;
create table /*!32312 if not exists*/ `layout_config` (
  `APPLY_TO`           varchar(420) default 'SELF' comment '应用到哪些人，可选值: ALL/SELF/$MemberID(U/D/R)',
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `CREATED_BY`         char(20) not null comment '创建人',
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `BELONG_ENTITY`      varchar(100) not null,
  `TYPE`               varchar(20) not null comment 'FORM,DATALIST,NAVI',
  `LAYOUT_ID`          char(20) not null,
  `CONFIG`             text(21845) not null comment 'JSON格式配置',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  primary key  (`LAYOUT_ID`)
)Engine=InnoDB;

-- ************ Entity [FilterConfig] DDL ************
drop table if exists `filter_config`;
create table /*!32312 if not exists*/ `filter_config` (
  `FILTER_ID`          char(20) not null,
  `APPLY_TO`           varchar(420) default 'SELF' comment '应用到哪些人，可选值: ALL/SELF/$MemberID(U/D/R)',
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `CREATED_BY`         char(20) not null comment '创建人',
  `FILTER_NAME`        varchar(100) not null,
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `BELONG_ENTITY`      varchar(100) not null,
  `CONFIG`             text(21845) not null comment 'JSON格式配置',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  primary key  (`FILTER_ID`)
)Engine=InnoDB;

-- ************ Entity [ViewAddonsConfig] DDL ************
drop table if exists `view_addons_config`;
create table /*!32312 if not exists*/ `view_addons_config` (
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `CREATED_BY`         char(20) not null comment '创建人',
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `ADDONS_ID`          char(20) not null,
  `BELONG_ENTITY`      varchar(100) not null,
  `TYPE`               varchar(20) not null comment 'TAB,ADD',
  `CONFIG`             text(21845) not null comment 'JSON格式配置',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  primary key  (`ADDONS_ID`),
  unique index `UIX1_view_addons_config` (`BELONG_ENTITY`, `TYPE`)
)Engine=InnoDB;

-- ************ Entity [DashboardConfig] DDL ************
drop table if exists `dashboard_config`;
create table /*!32312 if not exists*/ `dashboard_config` (
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `DASHBOARD_ID`       char(20) not null,
  `CREATED_BY`         char(20) not null comment '创建人',
  `SHARE_TO`           varchar(420) default 'SELF' comment '共享给哪些人，可选值: ALL/SELF/$MemberID(U/D/R)',
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `TITLE`              varchar(100) not null,
  `CONFIG`             text(21845) not null comment 'JSON格式配置',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  primary key  (`DASHBOARD_ID`)
)Engine=InnoDB;

-- ************ Entity [ChartConfig] DDL ************
drop table if exists `chart_config`;
create table /*!32312 if not exists*/ `chart_config` (
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `CHART_ID`           char(20) not null,
  `CREATED_BY`         char(20) not null comment '创建人',
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `BELONG_ENTITY`      varchar(100) not null,
  `TYPE`               varchar(100) not null,
  `TITLE`              varchar(100) not null,
  `CONFIG`             text(21845) not null comment 'JSON格式配置',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  primary key  (`CHART_ID`)
)Engine=InnoDB;

-- ************ Entity [ShareAccess] DDL ************
drop table if exists `share_access`;
create table /*!32312 if not exists*/ `share_access` (
  `ACCESS_ID`          char(20) not null,
  `RECORD_ID`          char(20) not null comment '记录ID',
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `CREATED_BY`         char(20) not null comment '创建人',
  `RIGHTS`             int(11) not null default '0' comment '共享权限(R=2,U=4,D=8,0=Auto)',
  `SHARE_TO`           char(20) not null comment '共享给谁 (U/D/R)',
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `BELONG_ENTITY`      varchar(100) not null comment '哪个实体',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  primary key  (`ACCESS_ID`)
)Engine=InnoDB;
alter table `share_access`
  add index `IX1_share_access` (`BELONG_ENTITY`, `RECORD_ID`, `SHARE_TO`);

-- ************ Entity [SystemConfig] DDL ************
drop table if exists `system_config`;
create table /*!32312 if not exists*/ `system_config` (
  `ITEM`               varchar(100) not null,
  `CONFIG_ID`          char(20) not null,
  `VALUE`              varchar(600) not null,
  primary key  (`CONFIG_ID`),
  unique index `UIX1_system_config` (`ITEM`)
)Engine=InnoDB;

-- ************ Entity [Notification] DDL ************
drop table if exists `notification`;
create table /*!32312 if not exists*/ `notification` (
  `TO_USER`            char(20) not null,
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `FROM_USER`          char(20) not null,
  `UNREAD`             char(1) default 'T',
  `CREATED_BY`         char(20) not null comment '创建人',
  `MESSAGE_ID`         char(20) not null,
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `MESSAGE`            varchar(1000),
  `RELATED_RECORD`     char(20) comment '相关业务记录',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  primary key  (`MESSAGE_ID`)
)Engine=InnoDB;
alter table `notification`
  add index `IX1_notification` (`TO_USER`, `UNREAD`, `CREATED_ON`);

-- ************ Entity [Attachment] DDL ************
drop table if exists `attachment`;
create table /*!32312 if not exists*/ `attachment` (
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `FILE_SIZE`          int(11) default '0' comment 'in KB',
  `CREATED_BY`         char(20) not null comment '创建人',
  `FILE_PATH`          varchar(200) not null,
  `BELONG_FIELD`       varchar(100),
  `IN_FOLDER`          char(20),
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `ATTACHMENT_ID`      char(20) not null,
  `BELONG_ENTITY`      smallint(6) default '0',
  `RELATED_RECORD`     char(20) comment '相关业务记录',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  `FILE_TYPE`          varchar(20),
  primary key  (`ATTACHMENT_ID`)
)Engine=InnoDB;
alter table `attachment`
  add index `IX1_attachment` (`BELONG_ENTITY`, `BELONG_FIELD`, `FILE_PATH`),
  add index `IX2_attachment` (`RELATED_RECORD`),
  add index `IX3_attachment` (`IN_FOLDER`, `CREATED_ON`);

-- ************ Entity [AttachmentFolder] DDL ************
drop table if exists `attachment_folder`;
create table /*!32312 if not exists*/ `attachment_folder` (
  `PARENT`             char(20),
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `CREATED_BY`         char(20) not null comment '创建人',
  `NAME`               varchar(100) not null,
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  `FOLDER_ID`          char(20) not null,
  primary key  (`FOLDER_ID`)
)Engine=InnoDB;


-- Init data

-- User
INSERT INTO `user` (`USER_ID`, `LOGIN_NAME`, `PASSWORD`, `FULL_NAME`, `DEPT_ID`, `ROLE_ID`, `IS_DISABLED`, `CREATED_ON`, `CREATED_BY`, `MODIFIED_ON`, `MODIFIED_BY`, `QUOCK_CODE`)
  VALUES 
  ('001-0000000000000000', 'system', 'system', '系统用户', '002-0000000000000001', '003-0000000000000001', 'T', CURRENT_TIMESTAMP, '001-0000000000000000', CURRENT_TIMESTAMP, '001-0000000000000000', 'XTYH'),
  ('001-0000000000000001', 'admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', '超级管理员', '002-0000000000000001', '003-0000000000000001', 'F', CURRENT_TIMESTAMP, '001-0000000000000000', CURRENT_TIMESTAMP, '001-0000000000000000', 'CJGLY');
-- Department
INSERT INTO `department` (`DEPT_ID`, `NAME`, `CREATED_ON`, `CREATED_BY`, `MODIFIED_ON`, `MODIFIED_BY`, `QUOCK_CODE`)
  VALUES ('002-0000000000000001', '总部', CURRENT_TIMESTAMP, '001-0000000000000000', CURRENT_TIMESTAMP, '001-0000000000000000', 'ZB');
-- Role
INSERT INTO `role` (`ROLE_ID`, `NAME`, `CREATED_ON`, `CREATED_BY`, `MODIFIED_ON`, `MODIFIED_BY`, `QUOCK_CODE`)
  VALUES ('003-0000000000000001', '管理员', CURRENT_TIMESTAMP, '001-0000000000000000', CURRENT_TIMESTAMP, '001-0000000000000000', 'GLY');
