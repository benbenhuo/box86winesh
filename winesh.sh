#!/bin/bash

BLUE='\033[36m'
RED='\e[91m'
GREEN='\e[32;m'
NC='\033[0m'

#将脚本装进系统
sudo mv -f winesh.sh /usr/local/bin/winesh
sudo chmod 777 /usr/local/bin/winesh
sudo sed -i '8,14d' /usr/local/bin/winesh
echo -e "${BLUE}脚本已安装完成，可以输入winesh进入脚本${NC}"
echo -e "${BLUE}----------------------------------------------------${NC}"

    #主菜单
    echo -e "${BLUE}1. box86${NC}"
    echo -e "${BLUE}2. wine${NC}"
    echo -e "${BLUE}3. 卸载脚本${NC}"
    echo -e "${BLUE}4. 退出脚本${NC}"
    read -p "请输入选项序号: " choice
case $choice in

    1)
    #检测box86是否安装
    box86 -v
    if [ $? -ne 0 ];then
    echo -e "${RED}box86未安装，请安装${NC}"
    else
    echo -e "${GREEN}box86已安装${NC}"
    fi
        #box86菜单
            echo -e "${GREEN}_____________________________${NC}"
            echo -e "${BLUE}1. box86安装和更新${NC}"
            echo -e "${BLUE}2. 卸载box86${NC}"
            echo -e "${BLUE}3. 返回${NC}"
            read -p "请输入选项序号: " choice
            case $choice in
            1)
            #安装box86
            sudo apt install box86-generic-arm
            if [ $? -ne 0 ];then
            sudo apt update && sudo apt install gpg -y
            sudo rm /etc/apt/sources.list.d/box86.list
            sudo touch /etc/apt/sources.list.d/box86.list
            sudo chmod 777 /etc/apt/sources.list.d/box86.list
            sudo echo "deb https://github.moeyy.xyz/https://raw.githubusercontent.com/ryanfortner/box86-debs/master/debian ./" > /etc/apt/sources.list.d/box86.list
            wget -qO- https://mirror.ghproxy.com/https://raw.githubusercontent.com/ryanfortner/box86-debs/master/KEY.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/box86-debs-archive-keyring.gpg 
            sudo apt update && sudo apt install box86-generic-arm -y
            echo -e "${BLUE}box86安装和更新已完成${NC}"
            fi
            winesh
            ;;

            2)
            #卸载box86
            sudo apt purge box86-generic-arm -y
            sudo rm -f /etc/apt/sources.list.d/box86.list /etc/apt/trusted.gpg.d/box86-debs-archive-keyring.gpg
            echo -e "${BLUE}box86已卸载完成${NC}"
            winesh
            ;;
            
            3)
            winesh
            ;;
            
            *)
            echo -e "${GREEN}无效的选择，请重新输入${NC}"
            winesh
            ;;
            esac
    ;;
    
    2)
            #wine菜单
            echo -e "${GREEN}_____________________________${NC}"
            echo -e "${BLUE}1. wine安装和更新${NC}"
            echo -e "${BLUE}2. wine卸载${NC}"
            echo -e "${BLUE}3. 返回${NC}"
            read -p "请输入选项序号: " choice
            case $choice in
            1)
            echo -e "${BLUE}默认安装wine版本为9.9${NC}"
            echo -e "${BLUE}是否保持默认wine安装版本，y是/n否${NC}"
            read -p "(y/n): " gujian
            if [ "$gujian" = "y" ]; then
           version='9.9'
            echo -e "${BLUE}不修改wine默认安装版本${NC}"
            elif [ "$gujian" = "n" ]; then
            echo -e "${BLUE}请前往https://github.com/Kron4ek/Wine-Builds/releases查看可安装版本${NC}"
            echo -e "${BLUE}只需输入版本号，例如输入9.9即设置为wine9.9版本${NC}"
            read -p "请输入版本号: " version
            fi
            sudo apt update && sudo apt install tightvncserver -y
            wget https://github.moeyy.xyz/https://github.com/Kron4ek/Wine-Builds/releases/download/${version}/wine-${version}-x86.tar.xz
            tar -Jxvf wine-${version}-x86.tar.xz
            rm wine-${version}-x86.tar.xz
            mv -f wine-${version}-x86 wine
            mv wine/bin/wineserver wine/bin/wineserver1
            touch wine/bin/wineserver
            sudo chmod 777 wine/bin/wineserver
            echo "#!/bin/bash" > wine/bin/wineserver
            echo "box86 wineserver1" >> wine/bin/wineserver
            sudo ln -s wine/bin/wineserver /usr/bin/wineserver
            lujing=$(pwd)
            sudo rm /etc/profile.d/1.sh
            sudo touch /etc/profile.d/1.sh
            sudo chmod 777 /etc/profile.d/1.sh
            sudo echo "export DISPLAY=:0" > /etc/profile.d/1.sh
            sudo echo "vncserver :0 -geometry 1280x720" >> /etc/profile.d/1.sh
            sudo echo "export BOX86_PATH=${lujing}/wine/bin/" >> /etc/profile.d/1.sh
            sudo echo "export BOX86_LD_LIBRARY_PATH=${lujing}/wine/lib/" >> /etc/profile.d/1.sh
            sudo echo "export BOX86_NOBANNER=1" >> /etc/profile.d/1.sh
            export DISPLAY=:0
            vncserver :0 -geometry 1280x720
            export BOX86_PATH=${lujing}/wine/bin/
            export BOX86_LD_LIBRARY_PATH=${lujing}/wine/lib/
            export BOX86_NOBANNER=1
            karch=$(uname -m)
            if [ "$karch" = "aarch64" ] || [ "$karch" = "aarch64-linux-gnu" ] || [ "$karch" = "arm64" ] || [ "$karch" = "aarch64_be" ]; then                   sudo dpkg --add-architecture armhf && sudo apt-get update # enable multi-arch
            sudo apt-get install -y libasound2:armhf libc6:armhf libglib2.0-0:armhf libgphoto2-6:armhf libgphoto2-port12:armhf \
            libgstreamer-plugins-base1.0-0:armhf libgstreamer1.0-0:armhf libldap-2.4-2:armhf libopenal1:armhf libpcap0.8:armhf \
            libpulse0:armhf libsane1:armhf libudev1:armhf libusb-1.0-0:armhf libvkd3d1:armhf libx11-6:armhf libxext6:armhf \
            libasound2-plugins:armhf ocl-icd-libopencl1:armhf libncurses6:armhf libncurses5:armhf libcap2-bin:armhf libcups2:armhf \
            libdbus-1-3:armhf libfontconfig1:armhf libfreetype6:armhf libglu1-mesa:armhf libglu1:armhf libgnutls30:armhf \
            libgssapi-krb5-2:armhf libkrb5-3:armhf libodbc1:armhf libosmesa6:armhf libsdl2-2.0-0:armhf libv4l-0:armhf \
            libxcomposite1:armhf libxcursor1:armhf libxfixes3:armhf libxi6:armhf libxinerama1:armhf libxrandr2:armhf \
            libxrender1:armhf libxxf86vm1:armhf libc6:armhf libcap2-bin:armhf
            fi
            sudo touch /usr/local/bin/wine
            sudo chmod 777 /usr/local/bin/wine
            sudo echo "#!/bin/bash" > /usr/local/bin/wine
            sudo -E echo 'box86 '"$HOME/wine/bin/wine "'"$@"' >> /usr/local/bin/wine
            sudo chmod +x /usr/local/bin/wine
            sudo apt install language-pack-zh-hans fonts-wqy-zenhei -y
            
            wine wineboot
           wget https://mirrors.ustc.edu.cn/wine/wine/wine-gecko/2.47.4/wine-gecko-2.47.4-x86.msi
           wine msiexec /i wine-gecko-2.47.4-x86.msi
           wget https://mirrors.ustc.edu.cn/wine/wine/wine-mono/9.1.0/wine-mono-9.1.0-x86.msi
           wine msiexec /i wine-mono-9.1.0-x86.tar.xz
           rm wine-gecko-2.47.4-x86.msi
           rm wine-mono-9.1.0-x86.msi
           echo -e "${BLUE}wine已安装完成${NC}"
            
            winesh
            ;;
            
            2)
            lujing=&(pwd)
           karch=$(uname -m)
              if [ "$karch" = "aarch64" ] || [ "$karch" = "aarch64-linux-gnu" ] || [ "$karch" = "arm64" ] || [ "$karch" = "aarch64_be" ]; then
              sudo apt purge -y libasound2:armhf libc6:armhf libglib2.0-0:armhf libgphoto2-6:armhf libgphoto2-port12:armhf \
              libgstreamer-plugins-base1.0-0:armhf libgstreamer1.0-0:armhf libldap-2.4-2:armhf libopenal1:armhf libpcap0.8:armhf \
              libpulse0:armhf libsane1:armhf libudev1:armhf libusb-1.0-0:armhf libvkd3d1:armhf libx11-6:armhf libxext6:armhf \
              libasound2-plugins:armhf ocl-icd-libopencl1:armhf libncurses6:armhf libncurses5:armhf libcap2-bin:armhf libcups2:armhf \
              libdbus-1-3:armhf libfontconfig1:armhf libfreetype6:armhf libglu1-mesa:armhf libglu1:armhf libgnutls30:armhf \
              libgssapi-krb5-2:armhf libkrb5-3:armhf libodbc1:armhf libosmesa6:armhf libsdl2-2.0-0:armhf libv4l-0:armhf \
              libxcomposite1:armhf libxcursor1:armhf libxfixes3:armhf libxi6:armhf libxinerama1:armhf libxrandr2:armhf \
              libxrender1:armhf libxxf86vm1:armhf libc6:armhf libcap2-bin:armhf
              fi
              sudo apt purge cabextract unzip tightvncserver -y
            rm wine*x86.tar.xz
            rm -r wine
            rm -r .wine
            echo -e "${BLUE}wine卸载完成${NC}"
            ;;
            3)
            winesh
            ;;
            
            *)
            echo -e "${RED}无效的选择${NC}"
            esac
            winesh

    ;;
            
    3)
    sudo rm /usr/local/bin/winesh         echo -e "${BLUE}卸载脚本完成${NC}"
    ;;
    
    4)
    exit 1
    ;;
    
    *)
    echo -e "${RED}无效的选择${NC}"
    winesh
    ;;

esac