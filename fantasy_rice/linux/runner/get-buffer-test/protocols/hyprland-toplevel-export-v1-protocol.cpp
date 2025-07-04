/* Generated by wayland-scanner 1.22.0 */

/*
 * Copyright © 2022 Vaxry
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdlib.h>
#include <stdint.h>
#include "wayland-util.h"
#include "hyprland-toplevel-export-v1-protocol.h"

#ifndef __has_attribute
# define __has_attribute(x) 0  /* Compatibility with non-clang compilers. */
#endif

#if (__has_attribute(visibility) || defined(__GNUC__) && __GNUC__ >= 4)
#define WL_PRIVATE __attribute__ ((visibility("hidden")))
#else
#define WL_PRIVATE
#endif

extern const struct wl_interface hyprland_toplevel_export_frame_v1_interface;
extern const struct wl_interface wl_buffer_interface;
extern const struct wl_interface zwlr_foreign_toplevel_handle_v1_interface;

static const struct wl_interface *hyprland_toplevel_export_v1_types[] = {
	NULL,
	NULL,
	NULL,
	NULL,
	&hyprland_toplevel_export_frame_v1_interface,
	NULL,
	NULL,
	&hyprland_toplevel_export_frame_v1_interface,
	NULL,
	&zwlr_foreign_toplevel_handle_v1_interface,
	&wl_buffer_interface,
	NULL,
};

static const struct wl_message hyprland_toplevel_export_manager_v1_requests[] = {
	{ "capture_toplevel", "niu", hyprland_toplevel_export_v1_types + 4 },
	{ "destroy", "", hyprland_toplevel_export_v1_types + 0 },
	{ "capture_toplevel_with_wlr_toplevel_handle", "2nio", hyprland_toplevel_export_v1_types + 7 },
};

WL_PRIVATE const struct wl_interface hyprland_toplevel_export_manager_v1_interface = {
	"hyprland_toplevel_export_manager_v1", 2,
	3, hyprland_toplevel_export_manager_v1_requests,
	0, NULL,
};

static const struct wl_message hyprland_toplevel_export_frame_v1_requests[] = {
	{ "copy", "oi", hyprland_toplevel_export_v1_types + 10 },
	{ "destroy", "", hyprland_toplevel_export_v1_types + 0 },
};

static const struct wl_message hyprland_toplevel_export_frame_v1_events[] = {
	{ "buffer", "uuuu", hyprland_toplevel_export_v1_types + 0 },
	{ "damage", "uuuu", hyprland_toplevel_export_v1_types + 0 },
	{ "flags", "u", hyprland_toplevel_export_v1_types + 0 },
	{ "ready", "uuu", hyprland_toplevel_export_v1_types + 0 },
	{ "failed", "", hyprland_toplevel_export_v1_types + 0 },
	{ "linux_dmabuf", "uuu", hyprland_toplevel_export_v1_types + 0 },
	{ "buffer_done", "", hyprland_toplevel_export_v1_types + 0 },
};

WL_PRIVATE const struct wl_interface hyprland_toplevel_export_frame_v1_interface = {
	"hyprland_toplevel_export_frame_v1", 2,
	2, hyprland_toplevel_export_frame_v1_requests,
	7, hyprland_toplevel_export_frame_v1_events,
};

