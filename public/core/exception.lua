-- Copyright (C) 2016 Jian Zhang (Jack)
-- 文件：exception.lua
-- 简介：luant 异常处理类
-- 功能：抛出异常信息，结束本次运行
-- 使用：lexception.${method}(...)

local Exception = {}

--依赖
local tostring = tostring
local json_encode = json.json_encode
local strfromat = string.format

function _throw(err_no, err_msg)
	res = json_encode({err_no=err_no, err_msg=err_msg})
	if not UNIT_TEST then
		ngx.say(res)
		ngx.exit(0)
	end
	return res
end

-- 成功
function Exception.success(t)
	if type(t) == 'table' then
		if not t.err_no then
			t.err_no = 0
		end
		ngx.say(json_encode(t))
	end
	ngx.exit(0)
end

-- 权限相关
function Exception.throw_ip_error()
	return _throw(101, '请求来源IP非法')
end

function Exception.throw_user_error()
	return _throw(102, '用户名不存在')
end

function Exception.throw_password_error()
	return _throw(103, '用户名或密码错误')
end

function Exception.throw_token_error()
	return _throw(104, 'Token已失效')
end

function Exception.throw_permission_error()
	return _throw(105, '越权操作数据')
end

-- 参数相关
function Exception.throw_param_error(k, v)
	return _throw(201, strfromat('参数：%s[%s]非法', k, tostring(v)))
end

function Exception.throw_json_illegal(v)
	return _throw(202, strfromat('JSON[%s]非法', tostring(v)))
end

function Exception.throw_uri_illegal(p)
	return _throw(203, strfromat('访问路径[%s]非法', tostring(v)))
end

-- 数据操作相关
function Exception.throw_add_error(err_msg)
	return _throw(301, '添加纪录失败：' .. tostring(err_msg))
end

function Exception.throw_update_error(err_msg)
	return _throw(302, '更新纪录失败：' .. tostring(err_msg))
end

function Exception.throw_delete_error(err_msg)
	return _throw(303, '删除纪录失败：' .. tostring(err_msg))
end

function Exception.throw_assemble_error(err_msg)
	return _throw(304, '组装SQL出错：' .. tostring(err_msg))
end

function Exception.throw_table_error(t)
	return _throw(305, strfromat('数据表[%s]非法', tostring(t)))
end

function Exception.throw_sql_error(sql, err)
	return _throw(306, strfromat('sql[%s]出错，错误信息[%s]', tostring(sql), tostring(err)))
end

-- 文件读取相关
function Exception.throw_config_error(file)
	return _throw(401, strfromat('配置文件[%s]加载失败', tostring(file)))
end

function Exception.throw_require_error(file)
	return _throw(402, strfromat('文件[%s]加载失败', tostring(file)))
end

-- 系统加载相关
-- 类加载失败
function Exception.throw_load_class_error(class)
	return _throw(501, strfromat('类[%s]加载失败', tostring(class)))
end

-- 函数加载失败
function Exception.throw_load_func_error(func)
	return _throw(502, strfromat('函数[%s]加载失败', tostring(func)))
end

-- 内部错误
function Exception.throw(err_msg)
	return _throw(1, err_msg)
end

return Exception