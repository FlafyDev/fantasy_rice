#ifndef _GRIM_H
#define _GRIM_H

#include <wayland-client.h>

// #include "box.h"
#include "display/texture.h"
#include "protocols/hyprland-toplevel-export-v1-protocol.h"
#include "protocols/xdg-output-unstable-v1-protocol.h"
#include "protocols/wlr-screencopy-unstable-v1-protocol.h"
#include "protocols/wlr-foreign-toplevel-management-unstable-v1-protocol.h"
#include <string>

enum grim_filetype {
  GRIM_FILETYPE_PNG,
  GRIM_FILETYPE_PPM,
  GRIM_FILETYPE_JPEG,
};

struct grim_state {
  wl_display *display;
  wl_registry *registry;
  wl_shm *shm;

	zxdg_output_manager_v1 *xdg_output_manager;
	zwlr_screencopy_manager_v1 *screencopy_manager;

  zwlr_foreign_toplevel_manager_v1 *foreign_toplevel_manager;
  hyprland_toplevel_export_manager_v1 *toplevel_export_manager;
  wl_list toplevels;
  wl_list outputs;

  size_t n_done;
  size_t n_done_outputs;

  bool init;
  grim_state()
      : display(nullptr), registry(nullptr), shm(nullptr),
        // xdg_output_manager(nullptr),
        foreign_toplevel_manager(nullptr), toplevel_export_manager(nullptr),
        n_done(0), n_done_outputs(0), init(false) {}
};

struct grim_buffer;

struct grim_toplevel {
  grim_state *state;
  grim_buffer *buffer;
  std::string title;
  DisplayChannelTexture* texture;
  zwlr_foreign_toplevel_handle_v1 *handle;
  hyprland_toplevel_export_frame_v1 *toplevel_export_frame;
  uint32_t
      toplevel_export_frame_flags; // enum
                                   // hyprland_toplevel_export_frame_v1_flags
  wl_list link;
  // pixman_image_t *image;
};

struct grim_output {
  grim_state *state;
  grim_buffer *buffer;
  std::string title;

	wl_output *wl_output;
	zxdg_output_v1 *xdg_output;
	wl_list link;

  DisplayChannelTexture* texture;
	zwlr_screencopy_frame_v1 *screencopy_frame;
	uint32_t screencopy_frame_flags; // enum zwlr_screencopy_frame_v1_flags

};

#endif
