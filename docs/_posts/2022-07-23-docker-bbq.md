---
layout: project
title:  "Docker-BBQ"
date:   2022-07-23 19:12:00 +0000
permalink: /projects/docker-bbq
featureimage: logo.webp
thumb: logo.webp
description: A set of bash scripts for creating and running templated docker projects
excerpt_separator: \{% endhighlight %\}
---
Creating flexible [docker](https://www.docker.com/) images with the ability quickly and efficiently develop and execute code can be time consuming.
There are generally two competing goals, keeping images small for deployment, while making them usable during development.
On top of that, there are a number of special flags and features of docker that can be forgotten when starting a new project.
This project aims to codify a standard approach to creating and running docker based projects.

The user can select between a number of bundled templates, which at the time of writing are limited to:
* Ubuntu
* Debian
* ROS
* Alpine

Using docker-bbq, the user can simply execute `bbq-create Alpine my-test-project` to get generate a new project.
That project comes with a *Makefile* that takes care of building the images.
There are two different build types: *development*, which is the default, and *production*, which is used for deployment.

In the development image, the user's code is mounted into the image at run-time.
This means that the user doesn't need to rebuild the image every time they make a change.
Docker-bbq also provides a `run` command that manages running, mounting the workspace, translating execution paths during development.
Using the `run` command, the user can seamlessly execute things in the image as if they were executing in the host machine.

The production image on the other hand is compiled with the workspace inside the image.
It is not designed to be used during development, which means the `run` command is not available for this image.
The user needs to execute the image using plain Docker commands, which is how it would be used in production.

My local development environment for [this website](https://github.com/MarkHedleyJones/markhedleyjones.github.io) is a bbq-docker project.

## Demonstration
This clip is a little out-of-date, but it shows the general idea of the project.

![](https://camo.githubusercontent.com/46521bd0959c1b7347439da0c87cacf38846edc036de2872f03c4eaa36522583/68747470733a2f2f7261772e6769746875622e636f6d2f6d61726b6865646c65796a6f6e65732f646f636b65722d6262712f6d61737465722f6d656469612f64656d6f2e676966)

<p style="text-align: center;">
  <a style="
    background-color: #489be0;
    color: #fff;
    border: none;
    vertical-align: middle;
    line-height: 40px;
    min-height: 42px;
    font-size: 14px;
    text-decoration: none;
    text-align: center;
    display: inline-block;
    padding: 0 25px;
    " href="https://github.com/MarkHedleyJones/docker-bbq">
    View/Download project on GitHub
  </a>
</p>
