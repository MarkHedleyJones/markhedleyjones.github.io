---
layout: note
title:  "Using Tracy Profiler"
date:   2023-12-05
permalink: /notes/using-tracy-profiler
description: "- a quick guide to profiling a C++ application"
---

[Tracy Profiler](https://github.com/wolfpld/tracy) is a fantastic tool for profiling C++ applications and is something I have recently started integrating into my workflow.
This guide serves as a quick guide on how to integrate it with an existing application and get your first profile. Note that these instructions assume that you are using Ubuntu 22.04 and that your project uses CMake.

Tracy Profiler has two parts, a set of macros that are included into your project and a server that receives the profiling data and displays it.

### Project Integration
From the root of your project, clone the Tracy Profiler repository into a subdirectory of your project (master branch should be fine).
```bash
git clone https://github.com/wolfpld/tracy
```

Then update your project's CMakeLists.txt as such:
```cmake
include_directories(
  include
  tracy/public
  ...
)

option( TRACY_ENABLE "" ON)
add_subdirectory(tracy)

add_executable(<your_project>
  tracy/public/TracyClient.cpp
  ...
)

target_link_libraries(<your_project>
  Tracy::TracyClient
  ...
)
```
Compile your project in debug mode.
```bash
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=DEBUG ..
make
```

### Building the profile viewer
Install dependencies
This will compile the viewer from source, which guarantees that the viewer is compatible with the version of profiler you are using. This will build for an
X11 based system (legacy mode, not for Wayland), see [the PDF documentation](https://github.com/wolfpld/tracy/releases/latest/download/tracy.pdf) for Wayland-based build.

```bash
sudo apt install libglfw3-dev libfreetype-dev libcapstone-dev libdbus-1-dev
```
Build for X11 (won't work on Wayland)
```bash
cd tracy/profiler/build/unix
make LEGACY=1
```
Build for Wayland (won't work on X11)
```bash
cd tracy/profiler/build/unix
make
```

This should create a binary called `Tracy-release` in the `tracy/profiler/build/unix` directory.
Execute this binary to start the viewer.
```bash
./Tracy-release
```
You should now have a profile viewer running on your machine like:
![profile_viewer](https://raw.githubusercontent.com/MarkHedleyJones/markhedleyjones.github.io/master/media/2023-12-05-note-using-tracy-profiler/profile_viewer.png)


### Profiling your application
Now that you have the viewer built (and running) it's time to profile your application.
Running your application under sudo is required to allow the profiler to access the system's performance counters.
```bash
cd build
sudo ./<your_project_executable>
```
You should now be able to see a profile like:

![profile_viewer](https://raw.githubusercontent.com/MarkHedleyJones/markhedleyjones.github.io/master/media/2023-12-05-note-using-tracy-profiler/captured_profile.png)
