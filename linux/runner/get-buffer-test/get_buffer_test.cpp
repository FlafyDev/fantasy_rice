#define _POSIX_C_SOURCE 200809L
#include <assert.h>
#include <cstdint>
#include <errno.h>
#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <wordexp.h>

#include <chrono>

#include "buffer.hpp"
#include "display/texture.h"
#include "get_buffer_test.hpp"
#include "grim.hpp"
#include "protocols/wlr-screencopy-unstable-v1-protocol.h"
#include "protocols/wlr-foreign-toplevel-management-unstable-v1-protocol.h"
#include "protocols/hyprland-toplevel-export-v1-protocol.h"
#include "protocols/wlr-foreign-toplevel-management-unstable-v1-protocol.h"
#include <glib.h>
#include <gtk/gtk.h>
#include <map>
// #include "output-layout.h"
// #include "render.h"
// #include "write_png.h"

// Define a template noop function
template <typename... Args> void noop(Args...) {}

static void toplevel_export_frame_handle_buffer(
    void *data, struct hyprland_toplevel_export_frame_v1 *frame,
    uint32_t format, uint32_t width, uint32_t height, uint32_t stride) {
  grim_toplevel *toplevel = static_cast<grim_toplevel *>(data);

  toplevel->buffer =
      create_buffer(toplevel->state->shm, static_cast<wl_shm_format>(format),
                    width, height, stride);
  if (toplevel->buffer == NULL) {
    fprintf(stderr, "failed to create buffer\n");
    exit(EXIT_FAILURE);
  }
  // fprintf(stderr, "created buffer\n");

  hyprland_toplevel_export_frame_v1_copy(frame, toplevel->buffer->wl_buffer, 1);
}

static void toplevel_export_frame_handle_flags(
    void *data, struct hyprland_toplevel_export_frame_v1 *frame,
    uint32_t flags) {
  grim_toplevel *toplevel = static_cast<grim_toplevel *>(data);
  toplevel->toplevel_export_frame_flags = flags;
}

static void toplevel_export_frame_handle_ready(
    void *data, struct hyprland_toplevel_export_frame_v1 *frame,
    uint32_t tv_sec_hi, uint32_t tv_sec_lo, uint32_t tv_nsec) {
  grim_toplevel *toplevel = static_cast<grim_toplevel *>(data);
  hyprland_toplevel_export_frame_v1_destroy(toplevel->toplevel_export_frame);
  ++toplevel->state->n_done;
}

static void toplevel_export_frame_handle_failed(
    void *data, struct hyprland_toplevel_export_frame_v1 *frame) {
  grim_toplevel *toplevel = static_cast<grim_toplevel *>(data);
  fprintf(stderr, "failed to copy toplevel %p\n", (void *)toplevel->handle);
  hyprland_toplevel_export_frame_v1_destroy(toplevel->toplevel_export_frame);
  ++toplevel->state->n_done;
}

static void
toplevel_handle_handle_closed(void *data,
                              struct zwlr_foreign_toplevel_handle_v1 *handle) {
  grim_toplevel *toplevel = static_cast<grim_toplevel *>(data);
  fprintf(stderr, "removing toplevel.\n");
  zwlr_foreign_toplevel_handle_v1_destroy(handle);
  wl_list_remove(&toplevel->link);
  toplevel->state->n_done++;
  free(toplevel);
}

static void toplevel_handle_handle_title(
    void *data, zwlr_foreign_toplevel_handle_v1 *handle, const char *title) {
  grim_toplevel *toplevel = static_cast<grim_toplevel *>(data);
  toplevel->title = title;
}

static const struct hyprland_toplevel_export_frame_v1_listener
    toplevel_export_frame_listener = {
        .buffer = toplevel_export_frame_handle_buffer,
        .damage = noop,
        .flags = toplevel_export_frame_handle_flags,
        .ready = toplevel_export_frame_handle_ready,
        .failed = toplevel_export_frame_handle_failed,
        .linux_dmabuf = noop,
        .buffer_done = noop,
};

static const zwlr_foreign_toplevel_handle_v1_listener toplevel_handle_listener =
    {
        .title = noop,
        .app_id = toplevel_handle_handle_title,
        .output_enter = noop,
        .output_leave = noop,
        .state = noop,
        .done = noop,
        .closed = toplevel_handle_handle_closed,
        .parent = noop,

};

static void toplevel_manager_handle_toplevel(
    void *data, struct zwlr_foreign_toplevel_manager_v1 *manager,
    struct zwlr_foreign_toplevel_handle_v1 *handle) {

  fprintf(stderr, "new toplevel\n");
  grim_state *state = static_cast<grim_state *>(data);
  grim_toplevel *toplevel = new grim_toplevel();
  toplevel->state = state;
  toplevel->handle = handle;
  wl_list_insert(&state->toplevels, &toplevel->link);

  zwlr_foreign_toplevel_handle_v1_add_listener(
      handle, &toplevel_handle_listener, toplevel);

  // fprintf(stderr, "TOP LEVEL: %p\n", (void *)toplevel->handle);
}

static const struct zwlr_foreign_toplevel_manager_v1_listener
    toplevel_manager_listener = {
        .toplevel = toplevel_manager_handle_toplevel,
        .finished = noop,
};

static void screencopy_frame_handle_buffer(void *data,
		zwlr_screencopy_frame_v1 *frame, uint32_t format, uint32_t width,
		uint32_t height, uint32_t stride) {
  grim_output *output = static_cast<grim_output *>(data);

	output->buffer = create_buffer(output->state->shm, static_cast<wl_shm_format>(format), width, height, stride);
	if (output->buffer == NULL) {
		fprintf(stderr, "failed to create buffer\n");
		exit(EXIT_FAILURE);
	}

	fprintf(stderr, "handling output buffer(buffer) %p\n", output);
	zwlr_screencopy_frame_v1_copy(frame, output->buffer->wl_buffer);
}

static void screencopy_frame_handle_flags(void *data,
		zwlr_screencopy_frame_v1 *frame, uint32_t flags) {
  grim_output *output = static_cast<grim_output *>(data);
	output->screencopy_frame_flags = flags;
}

static void screencopy_frame_handle_ready(void *data,
		zwlr_screencopy_frame_v1 *frame, uint32_t tv_sec_hi,
		uint32_t tv_sec_lo, uint32_t tv_nsec) {
  grim_output *output = static_cast<grim_output *>(data);
	fprintf(stderr, "copied output(ready) %p\n", output);
	++output->state->n_done_outputs;
}

static void screencopy_frame_handle_failed(void *data,
		zwlr_screencopy_frame_v1 *frame) {
  grim_output *output = static_cast<grim_output *>(data);
	fprintf(stderr, "failed to copy output %p\n", output);
	exit(EXIT_FAILURE);
}

static const struct zwlr_screencopy_frame_v1_listener screencopy_frame_listener = {
	.buffer = screencopy_frame_handle_buffer,
	.flags = screencopy_frame_handle_flags,
	.ready = screencopy_frame_handle_ready,
	.failed = screencopy_frame_handle_failed,
};


static void handle_global(void *data, struct wl_registry *registry,
                          uint32_t name, const char *interface,
                          uint32_t version) {
  grim_state *state = static_cast<grim_state *>(data);

  if (strcmp(interface, wl_shm_interface.name) == 0) {
    state->shm = static_cast<wl_shm *>(
        wl_registry_bind(registry, name, &wl_shm_interface, 1));
  } else if (strcmp(interface,
                    zwlr_foreign_toplevel_manager_v1_interface.name) == 0) {
    uint32_t bind_version = (version > 3) ? 3 : version;
    state->foreign_toplevel_manager =
        static_cast<zwlr_foreign_toplevel_manager_v1 *>(wl_registry_bind(
            registry, name, &zwlr_foreign_toplevel_manager_v1_interface,
            bind_version));
  } else if (strcmp(interface, zxdg_output_manager_v1_interface.name) == 0) {
		// uint32_t bind_version = (version > 2) ? 2 : version;
		// state->xdg_output_manager = wl_registry_bind(registry, name,
		// 	&zxdg_output_manager_v1_interface, bind_version);
	} else if (strcmp(interface, wl_output_interface.name) == 0) {
		grim_output *output = new grim_output();
		output->state = state;
		output->wl_output =  static_cast<wl_output*>(wl_registry_bind(registry, name, &wl_output_interface, 3));
		// wl_output_add_listener(output->wl_output, &output_listener, output);
		wl_list_insert(&state->outputs, &output->link);
  } else if (strcmp(interface,
                    hyprland_toplevel_export_manager_v1_interface.name) == 0) {
    state->toplevel_export_manager =
        static_cast<hyprland_toplevel_export_manager_v1 *>(wl_registry_bind(
            registry, name, &hyprland_toplevel_export_manager_v1_interface, 2));
  } else if (strcmp(interface, zwlr_screencopy_manager_v1_interface.name) == 0) {
		state->screencopy_manager = static_cast<zwlr_screencopy_manager_v1 *>(wl_registry_bind(registry, name,
			&zwlr_screencopy_manager_v1_interface, 1));
  }
}

// static void handle_global_remove(void *data, struct wl_registry *registry,
//                                  uint32_t name) {
//   // who cares
// }

static const struct wl_registry_listener registry_listener = {
    .global = handle_global,
    .global_remove = noop,
};

struct grim_state state = grim_state();

bool init() {
  if (state.init) {
    fprintf(stderr, "init = true\n");
  } else {
    fprintf(stderr, "init = false\n");
  }

  if (!state.init) {
    wl_list_init(&state.toplevels);
    wl_list_init(&state.outputs);

    state.display = wl_display_connect(NULL);
    if (state.display == NULL) {
      fprintf(stderr, "failed to create display\n");
      return false;
    }

    state.registry = wl_display_get_registry(state.display);
    wl_registry_add_listener(state.registry, &registry_listener, &state);

    if (wl_display_roundtrip(state.display) < 0) {
      fprintf(stderr, "wl_display_roundtrip() failed\n");
      return false;
    }

    fprintf(stderr, "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa\n");
    if (state.shm == NULL) {
      fprintf(stderr, "compositor doesn't support wl_shm\n");
      return false;
    }

    fprintf(stderr, "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa\n");
    if (state.screencopy_manager == NULL) {
      fprintf(stderr, "compositor doesn't support the screencopy protocol\n");
      return EXIT_FAILURE;
    }

    fprintf(stderr, "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa\n");
    if (state.toplevel_export_manager == NULL) {
      fprintf(stderr,
              "compositor doesn't support hyprland-toplevel-export-v1\n");
      return false;
    }

    fprintf(stderr, "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa\n");
    if (state.foreign_toplevel_manager == NULL) {
      fprintf(stderr,
              "compositor doesn't support zwlr_foreign_toplevel_manager_v1\n");
      return false;
    }

    fprintf(stderr, "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa\n");
    zwlr_foreign_toplevel_manager_v1_add_listener(
        state.foreign_toplevel_manager, &toplevel_manager_listener, &state);

    while ((wl_list_empty(&state.toplevels) || wl_list_empty(&state.outputs)) &&
           wl_display_dispatch(state.display) != -1)
      ;

    fprintf(stderr, "aAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa\n");
    state.init = true;
  } else {
    wl_display_roundtrip(state.display);
    // wl_display_dispatch(state.display);
  }
  fprintf(stderr, "bbbbbbbbbbbbbbbb\n");
  return true;
}

uintptr_t get_single_screen(FlView *view) {
  if (!init()) {
    return -1;
  }
  fprintf(stderr, "finished init()\n");

  state.n_done_outputs = 0;

  grim_output *first_output = wl_container_of(state.outputs.next, first_output, link);
  fprintf(stderr, "first output! %p\n", first_output);

  first_output->screencopy_frame = zwlr_screencopy_manager_v1_capture_output(
    state.screencopy_manager, false, first_output->wl_output);
  zwlr_screencopy_frame_v1_add_listener(first_output->screencopy_frame,
    &screencopy_frame_listener, first_output);

  fprintf(stderr, "did screen..\n");

  bool done = false;

  while (!done && wl_display_dispatch(state.display) != -1) {
    done = (state.n_done_outputs == 1);
  }
  if (!done) {
    fprintf(stderr, "failed to screenshoot all outputs\n");
    return {};
  }

  FlEngine *engine = fl_view_get_engine(view);
  FlTextureRegistrar *tex_reg = fl_engine_get_texture_registrar(engine);

  uintptr_t texture = 0;

  if (first_output != NULL) {
    GdkWindow *win = gtk_widget_get_window(GTK_WIDGET(view));
    GError *error = NULL;
    GdkGLContext *ctx = gdk_window_create_gl_context(win, &error);
    if (first_output->texture) {
      display_channel_texture_update(first_output->texture, first_output->buffer);
    } else {
      first_output->texture = display_channel_texture_new(ctx, first_output->buffer);
    }
    auto fl_texture = FL_TEXTURE(first_output->texture);
    fl_texture_registrar_register_texture(tex_reg, fl_texture);
    uintptr_t res = reinterpret_cast<uintptr_t>(fl_texture);

    texture = res;

    destroy_buffer(first_output->buffer);
  }

  return texture;
}


std::map<std::string, uintptr_t> get_buffer_test(FlView *view) {
  if (!init()) {
    return {};
  }

  state.n_done = 0;

  // zwlr_foreign_toplevel_manager_v1_stop(state.foreign_toplevel_manager);

  fprintf(stderr, "1\n");

  size_t n_pending = 0;
  // wl_list_for_each(toplevel, &state.toplevels, link) {
  //   // fprintf(stderr, "top level :D\n");
  // }
  struct grim_toplevel *toplevel;
  wl_list_for_each(toplevel, &state.toplevels, link) {
    // if (n_pending != 1) {
    // fprintf(stderr, "TOP LEVEL: %p\n", (void *)toplevel->handle);
    toplevel->toplevel_export_frame =
        hyprland_toplevel_export_manager_v1_capture_toplevel_with_wlr_toplevel_handle(
            state.toplevel_export_manager, 1, toplevel->handle);
    hyprland_toplevel_export_frame_v1_add_listener(
        toplevel->toplevel_export_frame, &toplevel_export_frame_listener,
        toplevel);
    ++n_pending;
    // }
  }
  fprintf(stderr, "2\n");

  auto start = std::chrono::high_resolution_clock::now();
  bool done = false;
  while (!done && wl_display_dispatch(state.display) != -1) {
    done = (state.n_done == n_pending);
  }
  if (!done) {
    fprintf(stderr, "failed to screenshoot all toplevels\n");
    return {};
  }
  fprintf(stderr, "3\n");

  auto end = std::chrono::high_resolution_clock::now();
  auto duration =
      std::chrono::duration_cast<std::chrono::microseconds>(end - start);
  fprintf(stderr, "Exection time of INNER: %f miliseconds\n",
          duration.count() / 1000.0);

  FlEngine *engine = fl_view_get_engine(view);
  FlTextureRegistrar *tex_reg = fl_engine_get_texture_registrar(engine);

  std::map<std::string, uintptr_t> texture_map = {};

  grim_toplevel *toplevel_tmp;
  wl_list_for_each_safe(toplevel, toplevel_tmp, &state.toplevels, link) {
    fprintf(stderr, "title: %s\n", toplevel->title.c_str());
    if (toplevel->buffer != NULL) {
      GdkWindow *win = gtk_widget_get_window(GTK_WIDGET(view));
      GError *error = NULL;
      GdkGLContext *ctx = gdk_window_create_gl_context(win, &error);
      if (toplevel->texture) {
        display_channel_texture_update(toplevel->texture, toplevel->buffer);
      } else {
        toplevel->texture = display_channel_texture_new(ctx, toplevel->buffer);
      }
      auto fl_texture = FL_TEXTURE(toplevel->texture);
      fl_texture_registrar_register_texture(tex_reg, fl_texture);
      uintptr_t res = reinterpret_cast<uintptr_t>(fl_texture);

      // Avoid overwriting keys with the same name
      std::string key = toplevel->title;
      int suffix = 1;
      while (texture_map.find(key) != texture_map.end()) {
        key = toplevel->title + "_" + std::to_string(suffix++);
      }

      texture_map.insert({key, res});
      destroy_buffer(toplevel->buffer);
    }
  }
  return texture_map;


  // grim_toplevel *toplevel_tmp;
  // wl_list_for_each_safe(toplevel, toplevel_tmp, &state.toplevels, link) {
  //   // fprintf(stderr, "destroying toplevel\n");
  //   // free(toplevel);
  // }
  // hyprland_toplevel_export_manager_v1_destroy(state.toplevel_export_manager);
  // zwlr_foreign_toplevel_manager_v1_destroy(state.foreign_toplevel_manager);
  // wl_shm_destroy(state.shm);
  // wl_registry_destroy(state.registry);
  // wl_display_disconnect(state.display);

  // return res;
}
