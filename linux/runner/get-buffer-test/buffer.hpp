#ifndef _BUFFER_H
#define _BUFFER_H

#include <wayland-client.h>

struct grim_buffer {
public:
  wl_buffer *wl_buffer;
  void *data;
  int32_t width, height, stride;
  size_t size;
  wl_shm_format format;
};

struct grim_buffer *create_buffer(wl_shm *shm, wl_shm_format format,
                                  int32_t width, int32_t height,
                                  int32_t stride);
void destroy_buffer(struct grim_buffer *buffer);

#endif
