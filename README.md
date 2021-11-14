# Intro
Steps for compiling / configuring a secure bitcoin core node 
These instructions were completed on a Ubuntu Server 20.04.3 LTS virtual machine, using Proxmox 7 as the hardware hypervisor. 


# Just the commands Commands

```
# Create staging area
mkdir -p ~/code && cd ~/code
cd ~/code

# Clone Bitcoin Repo, we will be compiling from source
git clone https://github.com/bitcoin/bitcoin.git

# Install Dependencies
sudo apt-get update && apt-get -y dist-upgrade
sudo apt-get install build-essential libtool autotools-dev automake pkg-config bsdmainutils python3 libevent-dev
sudo apt-get install -y libboost-system-dev libboost-filesystem-dev libboost-test-dev libboost-thread-dev
sudo apt-get install -y libsqlite3-dev
sudo apt-get install -y libminiupnpc-dev
sudo apt-get install -y libzmq3-dev
sudo apt-get install -y libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools
sudo apt-get install -y libqrencode-dev

# Install DB4 - Berkeley DB Database Library. Used with bitcoin wallet data. 
cd ~/code/bitcoin
./contrib/install_db4.sh `pwd`

# Compile/Install bitcoind from source, feel free to update the version/tag
cd ~/code/bitcoin
git checkout tags/v22.0
./autogen.sh
export BDB_PREFIX='/home/$USER/code/bitcoin/db4'
./configure BDB_LIBS="-L${BDB_PREFIX}/lib -ldb_cxx-4.8" BDB_CFLAGS="-I${BDB_PREFIX}/include"
make
sudo make install


## The following steps are to setup bitcoind as a service

cd ~/code
git clone https://github.com/bustanet/bitcoind_guide

# Create an unpriviledged user to run the bitcoin daemon
sudo useradd -U -r -s /bin/false bitcoin

# Create necessary directories and set permissions
sudo mkdir /var/lib/bitcoind /etc/bitcoin ~/.bitcoin /run/bitcoind
sudo chown bitcoin:bitcoin /var/lib/bitcoind
sudo chmod 750 /var/lib/bitcoind
```

- Update password in global.bitcoin.conf
- Update password in user.bitcoin.conf . Any user that interacts with bitcoin-cli will need the password from the global bitcoin.conf stored in their local bitcoin.conf. 

```
sudo cp bitcoind.service /etc/systemd/system
sudo cp global.bitcoin.conf /etc/bitcoin/bitcoin.conf
sudo cp user.bitcoin.conf ~/.bitcoin/bitcoin.conf
#sudo cp bitcoin.conf /var/lib/bitcoind

systemctl daemon-reload
systemctl start bitcoind

```




# bitcoind_guide
1. Bitcoin Core installation Guide. <sup>[1](#references)[4](#references)</sup>

2. Configure SSH and Google Authenticator for remote management. <sup>[2][5](#references)</sup>

3. Create non-priviledged account for bitcoin daemon.

    ```sudo useradd -U -r -s /bin/false bitcoin```
    <details>
    <summary> Click for Explanation </summary>

        -U create group named bitcoin  
        -r create a system account
          > System users will be created with no aging information in /etc/shadow,
          > and their numeric identifiers are chosen in the SYS_UID_MIN–SYS_UID_MAX
          > range, defined in /etc/login.defs, instead of UID_MIN–UID_MAX (and 
          > their GID counterparts for the creation of groups)."

        -s /bin/false sets the login shell to /bin/false (this way no one can potentially login with this user and get a shell
    </summary>

4. Make new user/group the owner of the bitcoin binary and working directory (I had to do the latter because I synced the blockchain in my regular user home directory before deciding to secure bitcoind.  Otherwise I would have created a single system wide directory with all the bitcoin files. Also my hard drive isn't big enough to move the blockchain data.)

    ```
    sudo chown -R bitcoin: /usr/local/bin/bitcoind ~/.bitcoin
    sudo ln -s ~/.bitcoin /var/lib/bitcoind
    ``` 

    TODO: Move actual data to /var/lib and remove symlink

5. Disable GUI. (I downloaded ubuntu desktop so I have the option of using bitcoind with a GUI if I wanted. I choose to have the GUI disabled unless explicitly using this feature.)

    ```sudo systemctl set-default multi-user```

6. Configure bitcoind to start on boot using non priviledged user <sup>[3](#references)</sup>
  * Copy over bitcoin.service from this repo

    ### Setup    

    ```
    mkdir /var/run/bitcoind/bitcoind.pid
    mkdir /etc/bitcoin
    chown bitcoin:bitcoin /var/run/bitcoind/bitcoind.pid

    ```





    * ```systemctl daemon-reload```
    * ```systemctl enable bitcoind```
    * ```systemctl stop bitcoind```





systemctl enable bitcoind

TODO: Add Log Rotate







sudo find /var/lib/bitcoin -type f -exec chmod 640 {} \;
sudo find /var/lib/bitcoin -type d -exec chmod 750 {} \;




sudo useradd -U -r -s /bin/false bitcoin
sudo chown -R bitcoin: /usr/local/bin/bitcoind ~/.bitcoin
sudo ln -s ~/.bitcoin /var/lib/bitcoind








## References
1. https://bitcoin.org/en/full-node#linux-instructions
2. https://www.rosehosting.com/blog/how-to-set-up-multi-factor-authentication-for-ssh-on-ubuntu-20-04/
3. https://bitcoin.stackexchange.com/questions/13795/ubuntu-linux-how-do-i-start-bitcoind-as-a-service-to-run-automatically#:~:text=To%20start%20bitcoind%20%2C%20run%20sudo,bitcoind%20%2C%20run%20sudo%20stop%20bitcoind%20.
4. https://stopanddecrypt.medium.com/a-complete-beginners-guide-to-installing-a-bitcoin-full-node-on-linux-2021-edition-46bf20fbe8ff
5. https://www.digitalocean.com/community/tutorials/how-to-set-up-multi-factor-authentication-for-ssh-on-ubuntu-16-04


