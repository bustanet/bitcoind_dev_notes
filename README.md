# Intro
Heres my guide to setting up a secure bitcoin core and lightning node. 

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

## References
1. https://bitcoin.org/en/full-node#linux-instructions
2. https://www.rosehosting.com/blog/how-to-set-up-multi-factor-authentication-for-ssh-on-ubuntu-20-04/
3. https://bitcoin.stackexchange.com/questions/13795/ubuntu-linux-how-do-i-start-bitcoind-as-a-service-to-run-automatically#:~:text=To%20start%20bitcoind%20%2C%20run%20sudo,bitcoind%20%2C%20run%20sudo%20stop%20bitcoind%20.
4. https://stopanddecrypt.medium.com/a-complete-beginners-guide-to-installing-a-bitcoin-full-node-on-linux-2021-edition-46bf20fbe8ff
5. https://www.digitalocean.com/community/tutorials/how-to-set-up-multi-factor-authentication-for-ssh-on-ubuntu-16-04
