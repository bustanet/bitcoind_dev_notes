# A novice's guide to building a bitcoin core dev environment on Ubuntu
The following instructions follow the **Unix Build Notes** located at [bitcoin/doc/build-unix.md](https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md) of the source code. 

I wanted to provide additional context for the novice (such as myself) as to what all of the compoenent parts are. The following instructions were exected on a docker container running the official ubuntu 20.04 image. 


## Build Requirements
```
sudo apt-get install build-essential libtool autotools-dev automake pkg-config bsdmainutils python3
```

- build-essentials: This is a meta package (package that links to multiple other packages) that is necessary for compiling C and C++ programs. The list of actually packages may differ from OS to OS, but for Ubuntu 20.04 using apt-get the packages it contains are: dpkg-dev, g++, gcc, libc6-dev, make. The details for these packages can be found [here](https://packages.ubuntu.com/focal/build-essential). 

- libtool, autotools-dev, automake: [From the docs](https://www.star.bnl.gov/~liuzx/autobook.html): *"Autoconf, Automake, and Libtool were developed separately, to make tackling the problem of software configuration more manageable by partitioning it. But they were designed to be used as a system, and they make more sense when you have documentation for the whole system."* This excerpt is from an entire book dedicated to documenting the history of how these tools became the foundations for C software development. 

- pkg-config: [From the docs](https://www.freedesktop.org/wiki/Software/pkg-config) From the docs: *"pkg-config is a helper tool used when compiling applications and libraries. It helps you insert the correct compiler options on the command line so an application can use gcc -o test test.c `pkg-config --libs --cflags glib-2.0` for instance, rather than hard-coding values on where to find glib (or other libraries)."*
-
- bsdmainutils: [From the docs]() *"collection of more utilities from FreeBSD This package contains lots of small programs many people expect to find when they use a BSD-style Unix system."* I have not discovered why a package like this would be required, if anyone knows, please reach out to me. 

- python3: Certain features, such as ZMQ are built with python. It also appears some CI testing functions utilze python as well. 

## Dependency Requirements
There are a couple of ways in which you can build your dev environment (choose one): 

| Level | Commands | Rationale |
| :---: | --- | --- |
| Most Control - Install your own dependencies | ```sudo apt-get install libevent-dev libboost-dev```| This is the simplest, but also gives you the most flexibility as it lets you "control" your dependencies. You can choose to install the required dependencies through a package manager (as seen here) or your can install them some other way, such as building them from source. | 
| Least Conrol - Use predefined dependencies | ```I dont fully understand this process, I'll have to come back to it. ``` | The commands here are explicitly spelled out in the unix build instructions and it is left up to the developer to have knowledge of how to build these dependencies, so I consider it a bit more challengeing. Having that said, this provides less control over the your dependencies because you are using the lib versions that have been predefined. |



