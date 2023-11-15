---
layout: note
title:  "Make a CMake build debug by default"
date:   2023-11-14
permalink: /notes/make-cmake-debug-by-default
---

Add this to your CMakeLists.txt:

```cmake
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug)
endif()
```
