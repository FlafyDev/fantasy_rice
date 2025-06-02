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
#include <flutter_linux/flutter_linux.h>
#include <map>

#include "buffer.hpp"
#include "grim.hpp"


uintptr_t get_single_screen(FlView *view);

std::map<std::string, uintptr_t> get_buffer_test(FlView* view);

