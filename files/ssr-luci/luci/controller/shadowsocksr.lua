-- Copyright (C) 2016 Jian Chang <aa65535@live.com>
-- Licensed to the public under the GNU General Public License v3.

module("luci.controller.shadowsocksr", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/shadowsocksr") then
		return
	end

	entry({"admin", "services", "shadowsocksr"},
		alias("admin", "services", "shadowsocksr", "general"),
		_("ShadowsocksR"), 10).dependent = true

	entry({"admin", "services", "shadowsocksr", "general"},
		cbi("shadowsocksr/general"),
		_("General Settings"), 10).leaf = true

	entry({"admin", "services", "shadowsocksr", "servers"},
		arcombine(cbi("shadowsocksr/servers"), cbi("shadowsocksr/servers-details")),
		_("Servers Manage"), 20).leaf = true

	entry({"admin", "services", "shadowsocksr", "watchdog"},
		call("action_watchdog"),
		_("Watchdog Log"), 30).leaf = true

	if luci.sys.call("command -v ssr-redir >/dev/null") ~= 0 then
		return
	end

	entry({"admin", "services", "shadowsocksr", "access-control"},
		cbi("shadowsocksr/access-control"),
		_("Access Control"), 30).leaf = true
end


function action_watchdog()
	local fs = require "nixio.fs"
	local conffile = "/var/log/shadowsocksr_watchdog.log"
	local watchdog = fs.readfile(conffile) or ""
	luci.template.render("shadowsocksr-libev/watchdogr", {watchdog=watchdog})
end
