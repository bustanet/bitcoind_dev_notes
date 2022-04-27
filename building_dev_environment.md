# A novice's guide to beginning bitcoin-core development on Ubuntu
The following instructions follow the **Unix Build Notes** located at [bitcoin/doc/build-unix.md](https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md) of the bitcoin-core source code. 

I wanted to provide additional context for the novice (such as myself) as to what all of the compoenent parts are. The following instructions were exected on a docker container running the official ubuntu 20.04 image. 

## Configuring Development Environment
### Build Requirements
```sudo apt-get install build-essential libtool autotools-dev automake pkg-config bsdmainutils python3```
<details>
  <summary>What do these tools do?</summary>
  
- build-essentials - This is a meta package (package that links to multiple other packages) that is necessary for compiling C and C++ programs. The list of actually packages may differ from OS to OS, but for Ubuntu 20.04 using apt-get the packages it contains are: dpkg-dev, g++, gcc, libc6-dev, make. The details for these packages can be found [here](https://packages.ubuntu.com/focal/build-essential). 

- libtool, autotools-dev, automake - [From the docs](https://www.star.bnl.gov/~liuzx/autobook.html): *"Autoconf, Automake, and Libtool were developed separately, to make tackling the problem of software configuration more manageable by partitioning it. But they were designed to be used as a system, and they make more sense when you have documentation for the whole system."* This excerpt is from an entire book dedicated to documenting the history of how these tools became the foundations for C software development. 

- pkg-config - [From the docs](https://www.freedesktop.org/wiki/Software/pkg-config): *"pkg-config is a helper tool used when compiling applications and libraries. It helps you insert the correct compiler options on the command line so an application can use gcc -o test test.c `pkg-config --libs --cflags glib-2.0` for instance, rather than hard-coding values on where to find glib (or other libraries)."*

- bsdmainutils - [From the docs]() *"collection of more utilities from FreeBSD This package contains lots of small programs many people expect to find when they use a BSD-style Unix system."* I have not discovered why a package like this would be required, if anyone knows, please reach out to me. 

- python3 - Certain features, such as ZMQ are built with python. It also appears some CI testing functions utilze python as well. 

</details> 

### Dependency Requirements
```sudo apt-get install libevent-dev libboost-dev```
<details>
  <summary> What do these tools do?</summary>
  
  - libevent-dev - [from the docs](https://libevent.org/) *"The libevent API provides a mechanism to execute a callback function when a specific event occurs on a file descriptor or after a timeout has been reached. Furthermore, libevent also support callbacks due to signals or regular timeouts."*
  
  - libboost-dev - [from the docs](https://www.boost.org/users/) *"In a word, Productivity. Use of high-quality libraries like Boost speeds initial development, results in fewer bugs, reduces reinvention-of-the-wheel, and cuts long-term maintenance costs. And since Boost libraries tend to become de facto or de jure standards, many programmers are already familiar with them."*
</details>

There are two ways to control your dependencies: 
- More Control: This is actually the simpler of the two and is what is used above in this section. It gives you the most flexibility as it lets you "control" your dependencies. You can choose to install the required dependencies through a package manager, like above, or your can install them some other way, such as building them from source. 

- Less Control: The other way is to follow the [dependency instructions](https://github.com/bitcoin/bitcoin/blob/master/depends/README.md) page, which will use the lib versions and build instructions that have been predefined in the bitcoin-core depends scripts. 

This is everything you need for a basic bitcoin-core build. The rest of the dependencies below are to implement additional features. 

### Addtional Feature Requirements (optional)

```
# Descriptor Wallet
sudo apt install libsqlite3-dev

# Port Mapping
sudo apt install libminiupnpc-dev libnatpmp-dev

# ZMQ
sudo apt-get install libzmq3-dev

# USDT
sudo apt install systemtap-sdt-dev

# GUI - I am not compiling the GUI portion. I may come back to this at a later point. 
```
<details>
  <summary>What are these features</summary>
  
  - Descriptor Wallet: There are two types of bitcoin wallet, an old **legacy wallet** and a new **descriptor wallet**. Sqlite is required to use the new descriptor wallet. 
  
  - Port Mapping:  used to autoconfigure open ports one gateway router. 
  
  - ZMQ: TODO
  
  - USDT: TODO
  
  - GUI: bitcoin-core can be operated from the command line or from a gui. 
</details>

## Building Bitcoind
Now with all the dependencies installed, we can copy down the source code from git and compile bitcoin-core. 
```
git clone https://github.com/bitcoin/bitcoin.git
cd bitcoin
./autogen.sh 
./configure
make # use "-j N" for N parallel jobs
make install # optional
```
<details>
  <summary> What do these commands do?</summary>
  
  [Here](https://devmanual.gentoo.org/general-concepts/autotools/index.html) is a great visual and explanation of how these tools work together. 
  - ```./autogen.sh``` runs a series of test to learn capabilites are available in your environment. Its output is a configure script. 
  - ```./configure``` utilizes the output from autogen to configure settings for the build environment. Itt output is a make file.
  - ```make``` uses all the instructions from the makefile created by ./configure. This command does all of the binary compulation. 
  - ```make install``` puts the binary executables into their final destination. 
</details>
  
**Stucture** 

To keep things organized, my have my project folder structured as follows: 
```
bitcoin
    | -----source <- this is where the bitcoin source code gets stored.
    | -----build  <- this is where the build files created by ```./configure``` are stored.
    | -----deploy <- this is where the final install files from ```./make install``` are stored.
 ```   
Revisiting the build instructions again, I run all of these commands from inside the build folder, but keep in mind that autoconf and configure are scripts located in the source code folder, so you will need to provide the path to them. It doesn't appear to matter which directory you are in when you run the autoconf, but without any additional options, configure will output the build files in the directory you are in. Here are the parameters I am using. 

```
./autogen.sh

./configure --without-miniupnpc \
--without-natpmp \
--disable-bench \
--disable-wallet \
--without-gui \ 
--prefix=../deploy

make -j"$(($(nproc)+1))

make install 
```

The additional options here are the suggested parameters to expedite compilation, details can be found [here](https://github.com/bitcoin/bitcoin/blob/master/doc/productivity.md). 



## Units Testing
Unit test instructions can be found [here](https://github.com/bitcoin/bitcoin/blob/master/src/test/README.md). Unit tests are built in c++ and are located in src/test. They are compiled when bitcoin-core is built and can be run with the test_bitcoin binary. Without any options test_bitcoin will run all tests, alternatively you can select a specific test. The test names are same as their source code name without the ```.cpp``` extension. Note that without setting the log level, there wont be any output and it will only notify you upon completion. 

```
# Run all unit tests
./test_bitcoin --log_level=all

# Run specific test
./test_bitcoin --log_level=all --run_test=getarg_tests

# Get help, such as see what the different log levels are
./test_bitcoin --help
```

## Git Workflow













## Just the Commands
```
#Build Requirements Dependencies
sudo apt-get install build-essential libtool autotools-dev automake pkg-config bsdmainutils python3

#Dependency Requirements
sudo apt-get install libevent-dev libboost-dev

# Productivity
sudo apt-get install ccache

```


