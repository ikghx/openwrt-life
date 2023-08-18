#!/usr/bin/env ucode
'use strict';
import { vlist_new, is_equal, wdev_create, wdev_remove } from "/usr/share/hostap/common.uc";
import { readfile, writefile, basename, readlink, glob } from "fs";

let keep_devices = {};
let phy = shift(ARGV);
let new_config = shift(ARGV);
const mesh_params = [
	"mesh_retry_timeout", "mesh_confirm_timeout", "mesh_holding_timeout", "mesh_max_peer_links",
	"mesh_max_retries", "mesh_ttl", "mesh_element_ttl", "mesh_hwmp_max_preq_retries",
	"mesh_path_refresh_time", "mesh_min_discovery_timeout", "mesh_hwmp_active_path_timeout",
	"mesh_hwmp_preq_min_interval", "mesh_hwmp_net_diameter_traversal_time", "mesh_hwmp_rootmode",
	"mesh_hwmp_rann_interval", "mesh_gate_announcements", "mesh_sync_offset_max_neighor",
	"mesh_rssi_threshold", "mesh_hwmp_active_path_to_root_timeout", "mesh_hwmp_root_interval",
	"mesh_hwmp_confirmation_interval", "mesh_awake_window", "mesh_plink_timeout",
	"mesh_auto_open_plinks", "mesh_fwding", "mesh_power_mode"
];

function iface_stop(wdev)
{
	if (keep_devices[wdev.ifname])
		return;

	wdev_remove(wdev.ifname);
}

function iface_start(wdev)
{
	let ifname = wdev.ifname;

	if (readfile(`/sys/class/net/${ifname}/ifindex`)) {
		system([ "ip", "link", "set", "dev", ifname, "down" ]);
		wdev_remove(ifname);
	}
	wdev_create(phy, ifname, wdev);
	system([ "ip", "link", "set", "dev", ifname, "up" ]);
	if (wdev.freq)
		system(`iw dev ${ifname} set freq ${wdev.freq} ${wdev.htmode}`);
	if (wdev.mode == "adhoc") {
		let cmd = ["iw", "dev", ifname, "ibss", "join", wdev.ssid, wdev.freq, wdev.htmode, "fixed-freq" ];
		if (wdev.bssid)
			push(cmd, wdev.bssid);
		for (let key in [ "beacon-interval", "basic-rates", "mcast-rate", "keys" ])
			if (wdev[key])
				push(cmd, key, wdev[key]);
		system(cmd);
	} else if (wdev.mode == "mesh") {
		let cmd = [ "iw", "dev", ifname, "mesh", "join", wdev.ssid, "freq", wdev.freq, wdev.htmode ];
		for (let key in [ "mcast-rate", "beacon-interval" ])
			if (wdev[key])
				push(cmd, key, wdev[key]);
		system(cmd);

		cmd = ["iw", "dev", ifname, "set", "mesh_param" ];
		let len = length(cmd);

		for (let param in mesh_params)
			if (wdev[param])
				push(cmd, param, wdev[param]);

		if (len == length(cmd))
			return;

		system(cmd);
	}

}

function iface_cb(new_if, old_if)
{
	if (old_if && new_if && is_equal(old_if, new_if))
		return;

	if (old_if)
		iface_stop(old_if);
	if (new_if)
		iface_start(new_if);
}

function drop_inactive(config)
{
	for (let key in config) {
		if (!readfile(`/sys/class/net/${key}/ifindex`))
			delete config[key];
	}
}

function add_ifname(config)
{
	for (let key in config)
		config[key].ifname = key;
}

function delete_ifname(config)
{
	for (let key in config)
		delete config[key].ifname;
}

function add_existing(phy, config)
{
	let wdevs = glob(`/sys/class/ieee80211/${phy}/device/net/*`);
	wdevs = map(wdevs, (arg) => basename(arg));
	for (let wdev in wdevs) {
		if (config[wdev])
			continue;

		if (basename(readlink(`/sys/class/net/${wdev}/phy80211`)) != phy)
			continue;

		if (trim(readfile(`/sys/class/net/${wdev}/operstate`)) == "down")
			config[wdev] = {};
	}
}


let statefile = `/var/run/wdev-${phy}.json`;

for (let dev in ARGV)
	keep_devices[dev] = true;

if (!phy || !new_config) {
	warn(`Usage: ${basename(sourcepath())} <phy> <config> [<device]...]\n`);
	exit(1);
}

if (!readfile(`/sys/class/ieee80211/${phy}/index`)) {
	warn(`PHY ${phy} does not exist\n`);
	exit(1);
}

new_config = json(new_config);
if (!new_config) {
	warn("Invalid configuration\n");
	exit(1);
}

let old_config = readfile(statefile);
if (old_config)
	old_config = json(old_config);

let config = vlist_new(iface_cb);
if (type(old_config) == "object")
	config.data = old_config;

add_existing(phy, config.data);
add_ifname(config.data);
drop_inactive(config.data);

add_ifname(new_config);
config.update(new_config);

drop_inactive(config.data);
delete_ifname(config.data);
writefile(statefile, sprintf("%J", config.data));
