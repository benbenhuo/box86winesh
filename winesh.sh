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

 while true; do
    #主菜单
    echo -e "${BLUE}1. box86${NC}"
    echo -e "${BLUE}2. wine${NC}"   
    echo -e "${BLUE}3. box64${NC}"
    echo -e "${BLUE}4. wine64${NC}"
    echo -e "${BLUE}5. VNC${NC}"
    echo -e "${BLUE}6. Winetricks${NC}"
    echo -e "${BLUE}7. 卸载脚本${NC}"
    echo -e "${RED}q. 退出脚本${NC}"
    read -p "请输入选项序号: " choice
case $choice in

    1)
    while true; do
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
            echo -e "${RED}Q. 返回${NC}"
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
            karch=$(uname -m)
            if [ "$karch" = "aarch64" ] || [ "$karch" = "aarch64-linux-gnu" ] || [ "$karch" = "arm64" ] || [ "$karch" = "aarch64_be" ]; then  
            sudo dpkg --add-architecture armhf 
            sudo apt update && sudo apt install libc6:armhf box86-generic-arm -y
            else
            sudo apt update && sudo apt install box86-generic-arm -y
            fi
            echo -e "${BLUE}box86安装和更新已完成${NC}"
            fi
            ;;

            2)
            #卸载box86
            sudo apt purge box86-generic-arm -y
            sudo apt purge libc6:armhf -y
            sudo rm -f /etc/apt/sources.list.d/box86.list /etc/apt/trusted.gpg.d/box86-debs-archive-keyring.gpg
            echo -e "${BLUE}box86已卸载完成${NC}"
            ;;
            
            q | Q)
                break
            ;;
            
            *)
            echo -e "${GREEN}无效的选择，请重新输入${NC}"
                ;;
            esac
            echo "按任意键继续..."
            read -n 1 -s -r -p ""
        done
        ;;
    
    2)
    while true; do
            #wine菜单
            echo -e "${GREEN}_____________________________${NC}"
            echo -e "${BLUE}1. wine安装和更新${NC}"
            echo -e "${BLUE}2. wine卸载${NC}"
            echo -e "${RED}q. 返回${NC}"
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
            lujing=$(pwd)
            sudo rm /etc/profile.d/wine.sh /etc/profile.d/vnc.sh
            sudo touch /etc/profile.d/wine.sh /etc/profile.d/vnc.sh
            sudo chmod 777 /etc/profile.d/wine.sh /etc/profile.d/vnc.sh
            sudo echo "export DISPLAY=:0" > /etc/profile.d/vnc.sh
            sudo echo "vncserver :0 -geometry 1280x720" >> /etc/profile.d/vnc.sh
            sudo echo "export BOX86_PATH=${lujing}/wine/bin/" > /etc/profile.d/wine.sh
            sudo echo "export BOX86_LD_LIBRARY_PATH=${lujing}/wine/lib/" >> /etc/profile.d/wine.sh
            sudo echo "export BOX86_NOBANNER=1" >> /etc/profile.d/wine.sh
            export DISPLAY=:0
            echo -e "${RED}请务必设置6位数以上的vnc密码不然会安装失败${NC}"
            vncserver :0 -geometry 1280x720
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
            #安装中文字体
            echo -e "${BLUE}正在安装中文字体${NC}"
            WINEPREFIX=$(pwd)/.wine box86 wine wineboot
            wget -O ${lujing}/.wine/drive_c/windows/Fonts/simsun.ttc https://github.moeyy.xyz/https://raw.githubusercontent.com/benbenhuo/boxwinesh/main/simsun.ttc
            sudo chmod 755 ${lujing}/.wine/drive_c/windows/Fonts/simsun.ttc
            wget https://github.moeyy.xyz/https://raw.githubusercontent.com/benbenhuo/boxwinesh/main/zh.reg
            WINEPREFIX=$(pwd)/.wine box86 wine regedit zh.reg
            rm zh.reg
            sudo rm /usr/local/bin/wine
            sudo touch /usr/local/bin/wine
            sudo chmod 777 /usr/local/bin/wine
            sudo echo "export WINEPREFIX=$(pwd)/.wine" > /usr/local/bin/wine
            sudo -E echo 'LC_ALL=zh_CN.UTF8 box86 '"${lujing}/wine/bin/wine "'"$@"' >> /usr/local/bin/wine
            sudo chmod +x /usr/local/bin/wine
            #安装gecko和momo
            echo -e "${BLUE}正在安装wine-gecko和wine-momo${NC}"
           wget https://mirrors.ustc.edu.cn/wine/wine/wine-gecko/2.47.4/wine-gecko-2.47.4-x86.msi
           wget https://mirrors.ustc.edu.cn/wine/wine/wine-mono/9.1.0/wine-mono-9.1.0-x86.msi
           wine msiexec /i wine-gecko-2.47.4-x86.msi
           wine msiexec /i wine-mono-9.1.0-x86.msi
           rm wine-gecko-2.47.4-x86.msi
           rm wine-mono-9.1.0-x86.msi
           echo -e "${BLUE}wine已安装完成${NC}"
            ;;
            
            2)
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
            rm wine*x86.tar.xz
            rm -r wine
            rm -r .wine
            sudo rm /usr/local/bin/wine
            sudo rm /etc/profile.d/wine.sh
            echo -e "${BLUE}wine卸载完成${NC}"
            ;;
            
            q | Q)
                break
                ;;
            
            *)
             echo -e "${GREEN}无效的选择，请重新输入${NC}"
                ;;
            esac
            echo "按任意键继续..."
            read -n 1 -s -r -p ""
        done
        ;;
            
    3)
    while true; do
      karch=$(uname -m)
      if [ "$karch" = "aarch64" ] || [ "$karch" = "aarch64-linux-gnu" ] || [ "$karch" = "arm64" ] || [ "$karch" = "aarch64_be" ]; then
       echo -e "${BLUE}当前架构arm64${NC}"
       else
       echo -e "${RED}当前架构不为arm64无法安装box64${NC}"
        break
        fi
      #box64
    #检测box64是否安装
    box64 -v
          if [ $? -ne 0 ];then
    echo -e "${RED}box64未安装，请安装${NC}"
           else
    echo -e "${GREEN}bo64已安装${NC}"
            fi
        #box64菜单
            echo -e "${GREEN}_____________________________${NC}"
            echo -e "${BLUE}1. box64安装和更新${NC}"
            echo -e "${BLUE}2. 卸载box64${NC}"
            echo -e "${RED}q. 返回${NC}"
            read -p "请输入选项序号: " choice
            case $choice in
            1)
            #安装box64
            sudo apt install box64
            if [ $? -ne 0 ];then
            sudo apt update && sudo apt install gpg -y
            sudo wget https://cdn05042023.gitlink.org.cn/shenmo7192/box64-debs/raw/branch/master/box64-CN.list -O /etc/apt/sources.list.d/box64.list
            wget -qO- https://cdn05042023.gitlink.org.cn/shenmo7192/box64-debs/raw/branch/master/KEY.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg 
             sudo apt update && sudo apt install box64 -y
            echo -e "${BLUE}box64安装和更新已完成${NC}"
            fi
            ;;
            
            2)
            #卸载box64
            sudo apt purge box64 -y
            sudo rm -f /etc/apt/sources.list.d/box64.list /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg
            echo -e "${BLUE}box64已卸载完成${NC}"
            ;;
            
            q | Q)
                break
                ;;
            
            *)
            echo -e "${GREEN}无效的选择，请重新输入${NC}"
                ;;
            esac
            echo "按任意键继续..."
            read -n 1 -s -r -p ""
        done
        ;;
            
    4)
    while true; do
      karch=$(uname -m)
      if [ "$karch" = "aarch64" ] || [ "$karch" = "aarch64-linux-gnu" ] || [ "$karch" = "arm64" ] || [ "$karch" = "aarch64_be" ]; then
       echo -e "${BLUE}当前架构arm64${NC}"
       else
       echo -e "${RED}当前架构不为arm64无法安装wine64${NC}"
        break
        fi
            #wine64菜单
            echo -e "${GREEN}_____________________________${NC}"
            echo -e "${BLUE}1. wine64安装和更新${NC}"
            echo -e "${BLUE}2. wine64卸载${NC}"
            echo -e "${BLUE}q. 返回${NC}"
            read -p "请输入选项序号: " choice
            case $choice in
            1)
            echo -e "${BLUE}默认安装wine64版本为9.9${NC}"
            echo -e "${BLUE}是否保持默认wine64安装版本，y是/n否${NC}"
            read -p "(y/n): " gujian
            if [ "$gujian" = "y" ]; then
           version='9.9'
            echo -e "${BLUE}不修改wine64默认安装版本${NC}"
            elif [ "$gujian" = "n" ]; then
            echo -e "${BLUE}请前往https://github.com/Kron4ek/Wine-Builds/releases查看可安装版本${NC}"
            echo -e "${BLUE}只需输入版本号，例如输入9.9即设置为wine64的9.9版本${NC}"
            read -p "请输入版本号: " version
            fi
            sudo apt update && sudo apt install tightvncserver -y
            wget https://github.moeyy.xyz/https://github.com/Kron4ek/Wine-Builds/releases/download/${version}/wine-${version}-amd64.tar.xz
            tar -Jxvf wine-${version}-amd64.tar.xz
            rm wine-${version}-amd64.tar.xz
            mv -f wine-${version}-amd64 wine64
            mv wine64/bin/wineserver wine64/bin/wineserver1
            touch wine64/bin/wineserver
            sudo chmod 777 wine64/bin/wineserver
            echo "#!/bin/bash" > wine64/bin/wineserver
            echo "box64 wineserver1" >> wine64/bin/wineserver
            lujing=$(pwd)
            sudo rm /etc/profile.d/wine64.sh /etc/profile.d/vnc.sh
            sudo touch /etc/profile.d/wine64.sh /etc/profile.d/vnc.sh
            sudo chmod 777 /etc/profile64.d/wine.sh /etc/profile.d/vnc.sh
            sudo echo "export DISPLAY=:0" > /etc/profile.d/vnc.sh
            sudo echo "vncserver :0 -geometry 1280x720" >> /etc/profile.d/vnc.sh
            sudo echo "export BOX64_PATH=${lujing}/wine64/bin/" > /etc/profile.d/wine64.sh
            sudo echo "export BOX64_LD_LIBRARY_PATH=${lujing}/wine64/lib/" >> /etc/profile.d/wine64.sh
            sudo echo "export BOX64_NOBANNER=1" >> /etc/profile.d/wine64.sh
            export DISPLAY=:0
            echo -e "${RED}请务必设置6位数以上的vnc密码不然会安装失败${NC}"
            vncserver :0 -geometry 1280x720
            vncserver :0 -geometry 1280x720
            export BOX64_PATH=${lujing}/wine64/bin/
            export BOX64_LD_LIBRARY_PATH=${lujing}/wine64/lib/
            export BOX64_NOBANNER=1
            #安装中文字体
            echo -e "${BLUE}正在安装中文字体${NC}"
            WINEPREFIX=$(pwd)/.wine64 box64 wine64 wineboot
            wget -O ${lujing}/.wine64/drive_c/windows/Fonts/simsun.ttc https://github.moeyy.xyz/https://raw.githubusercontent.com/benbenhuo/boxwinesh/main/simsun.ttc
            sudo chmod 755 ${lujing}/.wine64/drive_c/windows/Fonts/simsun.ttc
            wget https://github.moeyy.xyz/https://raw.githubusercontent.com/benbenhuo/boxwinesh/main/zh.reg -O zh.reg
            WINEPREFIX=$(pwd)/.wine64 box64 wine64 regedit zh.reg
            rm zh.reg
            sudo rm /usr/local/bin/wine64
            sudo touch /usr/local/wine64
            sudo chmod 777 /usr/local/bin/wine64
            sudo echo "export WINEPREFIX=$(pwd)/.wine64" > /usr/local/bin/wine64
            sudo -E echo 'LC_ALL=zh_CN.UTF8 box64 '"${lujing}/wine64/bin/wine64 "'"$@"' >> /usr/local/bin/wine64
            sudo chmod +x /usr/local/bin/wine64
            #安装gecko
            echo -e "${BLUE}正在安装wine-gecko${NC}"
           wget https://mirrors.ustc.edu.cn/wine/wine/wine-gecko/2.47.4/wine-gecko-2.47.4-x86_64.msi
           wine64 msiexec /i wine-gecko-2.47.4-x86_64.msi
           rm wine-gecko-2.47.4-x86_64.msi
           echo -e "${BLUE}wine64已安装完成${NC}"
            ;;
            
            2)
            rm wine*amd64.tar.xz
            rm -r wine64
            rm -r .wine64
            sudo rm /usr/local/bin/wine64
            sudo rm /etc/profile.d/wine64.sh
            echo -e "${BLUE}wine64卸载完成${NC}"
            ;;
            
            q | Q)
                break
                ;;
            
            *)
            echo -e "${GREEN}无效的选择，请重新输入${NC}"
                ;;
            esac
            echo "按任意键继续..."
            read -n 1 -s -r -p ""
        done
        ;;
            
    5)
    while true; do
      #vnc
    #检测vnc是否安装
    vncserver :0 -geometry 1280x720
    if [ $? -ne 0 ];then
    echo -e "${RED}VNC未安装，请安装${NC}"
    else
    echo -e "${GREEN}VNC已安装${NC}"
    fi
    echo -e "${GREEN}安装wine和wine64时都会自动安装VNC${NC}"
        #VNC菜单
            echo -e "${GREEN}_____________________________${NC}"
            echo -e "${BLUE}1. vnc安装和更新${NC}"
            echo -e "${BLUE}2. 卸载VNC${NC}"
            echo -e "${RED}q. 返回${NC}"
            read -p "请输入选项序号: " choice
            case $choice  in
            
            1)
            sudo apt update && sudo apt install tightvncserver -y
            sudo rm /etc/profile.d/vnc.sh
            sudo touch /etc/profile.d/vnc.sh
            sudo chmod 777 /etc/profile.d/vnc.sh
            sudo echo "export DISPLAY=:0" > /etc/profile.d/vnc.sh
            sudo echo "vncserver :0 -geometry 1280x720" >> /etc/profile.d/vnc.sh
            export DISPLAY=:0
            echo -e "${RED}请务必设置6位数以上的vnc密码不然会安装失败${NC}"
            vncserver :0 -geometry 1280x720
            vncserver :0 -geometry 1280x720
            echo -e "${GREEN}VNC已安装完成${NC}"
            ;;
            
            2)
            sudo apt purge tightvncserver -y
            sudo rm /etc/profile.d/vnc.sh
            echo -e "${GREEN}VNC已卸载完成${NC}"
            ;;
            
            q | Q)
                break
                ;;
            
            *)
            echo -e "${GREEN}无效的选择，请重新输入${NC}"
                ;;
            esac
            echo "按任意键继续..."
            read -n 1 -s -r -p ""
        done
        ;;
        
    6)
    while true; do
            echo -e "${GREEN}_____________________________${NC}"
            echo -e "${BLUE}1. winetricks安装和更新(用于wine)${NC}"
            echo -e "${BLUE}2. 卸载winetricks${NC}"
            echo -e "${BLUE}3. winetricks64安装和更新(用于wine64)${NC}"
            echo -e "${BLUE}4. 卸载winetricks64${NC}"
            echo -e "${RED}q. 返回${NC}"
            read -p "请输入选项序号: " choice
            case $choice  in
            
            1)
            sudo apt update $$ apt install cabextract unzip -y
            sudo wget -O /usr/local/bin/winetricks1 http://github.moeyy.xyz/https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks 
            sudo touch /usr/local/bin/winetricks
            sudo chmod 777 /usr/local/bin/winetricks1 /usr/local/bin/winetricks
            sudo echo "#!/bin/bash" > /usr/local/bin/winetricks
            sudo echo "export BOX86_NOBANNER=1 WINE=wine WINEPREFIX=$(pwd)/.wine WINESERVER=$(pwd)/wine/bin/wineserver" >> /usr/local/bin/winetricks
            sudo echo 'winetricks1 "$@"' >> /usr/local/bin/winetricks
            echo -e "${BLUE}1. winetricks已安装完成${NC}"
            ;;
            
            2)
            sudo rm /usr/local/bin/winetricks /usr/local/bin/winetricks1
            echo -e "${BLUE}1. winetricks已卸载完成${NC}"
            ;;
             3)
            sudo apt update $$ apt install cabextract unzip -y
      karch=$(uname -m)
      if [ "$karch" = "aarch64" ] || [ "$karch" = "aarch64-linux-gnu" ] || [ "$karch" = "arm64" ] || [ "$karch" = "aarch64_be" ]; then
       echo -e "${BLUE}当前架构arm64${NC}"
       else
       echo -e "${RED}当前架构不为arm64无法安装winetricks64${NC}"
        break
        fi
            sudo wget -O /usr/local/bin/winetricks2 http://github.moeyy.xyz/https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks 
            sudo touch /usr/local/bin/winetricks64
            sudo chmod 777 /usr/local/bin/winetricks2 /usr/local/bin/winetricks64
            sudo echo "#!/bin/bash" > /usr/local/bin/winetricks64
            sudo echo "export BOX86_NOBANNER=1 WINE=wine WINEPREFIX=$(pwd)/.wine WINESERVER=$(pwd)/wine/bin/wineserver" >> /usr/local/bin/winetricks64
            sudo echo 'winetricks1 "$@"' >> /usr/local/bin/winetricks64
            echo -e "${BLUE}1. winetricks64已安装完成${NC}"
            ;;
            
            4)
            sudo rm /usr/local/bin/winetricks64 /usr/local/bin/winetricks2
            echo -e "${BLUE}1. winetricks64已卸载完成${NC}"
            ;;
             
            q | Q)
                break
                ;;
            
            *)
            echo -e "${GREEN}无效的选择，请重新输入${NC}"
                ;;
            esac
            echo "按任意键继续..."
            read -n 1 -s -r -p ""
        done
        ;;
        
    7)
    sudo rm /usr/local/bin/winesh         echo -e "${BLUE}卸载脚本完成${NC}"
    exit 1
    ;;
    
    q | Q)
    exit 1
    ;;
    
    *)
      echo -e "${GREEN}无效的选择，请重新输入${NC}"    ;;
esac
done