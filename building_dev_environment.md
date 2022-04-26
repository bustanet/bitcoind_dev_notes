# A novice's guide to building a bitcoin core dev environment on Ubuntu
The following instructions follow the **Unix Build Notes** located at [bitcoin/doc/build-unix.md](https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md) of the source code. 

I wanted to provide additional context for the novice (such as myself) as to what all of the compoenent parts are. The following instructions were exected on a docker container running the official ubuntu 20.04 image. 


## Build Requirements
```
sudo apt-get install build-essential libtool autotools-dev automake pkg-config bsdmainutils python3
```
<details>
  <summary>What do these tools do?</summary>
  
- build-essentials: This is a meta package (package that links to multiple other packages) that is necessary for compiling C and C++ programs. The list of actually packages may differ from OS to OS, but for Ubuntu 20.04 using apt-get the packages it contains are: dpkg-dev, g++, gcc, libc6-dev, make. The details for these packages can be found [here](https://packages.ubuntu.com/focal/build-essential). 

- libtool, autotools-dev, automake: [From the docs](https://www.star.bnl.gov/~liuzx/autobook.html): *"Autoconf, Automake, and Libtool were developed separately, to make tackling the problem of software configuration more manageable by partitioning it. But they were designed to be used as a system, and they make more sense when you have documentation for the whole system."* This excerpt is from an entire book dedicated to documenting the history of how these tools became the foundations for C software development. 

- pkg-config: [From the docs](https://www.freedesktop.org/wiki/Software/pkg-config) From the docs: *"pkg-config is a helper tool used when compiling applications and libraries. It helps you insert the correct compiler options on the command line so an application can use gcc -o test test.c `pkg-config --libs --cflags glib-2.0` for instance, rather than hard-coding values on where to find glib (or other libraries)."*

- bsdmainutils: [From the docs]() *"collection of more utilities from FreeBSD This package contains lots of small programs many people expect to find when they use a BSD-style Unix system."* I have not discovered why a package like this would be required, if anyone knows, please reach out to me. 

- python3: Certain features, such as ZMQ are built with python. It also appears some CI testing functions utilze python as well. 

</details> 

## Dependency Requirements
```sudo apt-get install libevent-dev libboost-dev```
<details>
  <summary> What do these tools do?</summary>
  
</details>

There are two ways to control your dependencies: 
- More Control: This is actually the simpler of the two and is what is used above in this section. It gives you the most flexibility as it lets you "control" your dependencies. You can choose to install the required dependencies through a package manager, like above, or your can install them some other way, such as building them from source. 

- Less Control: The other way is to follow the [dependency instructions](https://github.com/bitcoin/bitcoin/blob/master/depends/README.md) page, which will use the lib versions and installation instructions that have been predefined. 



