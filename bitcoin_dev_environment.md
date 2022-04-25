# A novice's guide to building a bitcoin core dev environment
Most of this information can be found in the docs of the bitcoin core code, I wanted to provide additional context for the novice (such as myself) as what all of the compoenent parts are. The following instructions were exected on a docker container running the official ubuntu 20.04 image. 

```
# Build Requirements
sudo apt-get install build-essential libtool autotools-dev automake pkg-config bsdmainutils python3
```

- build-essentials: This is a meta package (package that links to multiple other packages) that is necessary for compiling C and C++ programs. The list of actually packages may differ from OS to OS, but for Ubuntu 20.04 using apt-get the packages it contains are: dpkg-dev, g++, gcc, libc6-dev, make. The details for these packages can be found [here](https://packages.ubuntu.com/focal/build-essential). 
- libtool: From the docs, *"GNU Libtool is a generic library support script that hides the complexity of using shared libraries behind a consistent, portable interface."*
- autotools-dev
- automake
- pkg-config
- bsdmainutils
- python3
