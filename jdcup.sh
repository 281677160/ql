#!/usr/bin/env bash
  [[ -f /etc/bianliang.sh ]] && source /etc/bianliang.sh
  if [[ `docker images | grep -c "nvjdc"` -ge '1' ]] || [[ `docker ps -a | grep -c "nvjdc"` -ge '1' ]]; then
    dockernv=$(docker ps -a|grep nvjdc) && dockernvid=$(awk '{print $(1)}' <<<${dockernv})
    imagesnv=$(docker images|grep nvjdc) && imagesnvid=$(awk '{print $(3)}' <<<${imagesnv})
    docker stop -t=5 "${dockernvid}" > /dev/null 2>&1
    docker rm "${dockernvid}"
    docker rmi "${imagesnvid}"
  fi
  cd ${QL_PATH}
  rm -rf nvjdcbf
  cp -Rf nolanjdc nvjdcbf
  rm -rf nolanjdc
  echo -e "\033[32;1m 下载源码，请耐心等候... \033[0m"
  git clone "${ghproxy_Path}"https://github.com/NolanHzy/nvjdcdocker.git ${QL_PATH}/nolanjdc
  cp -Rf nvjdcbf/Config nolanjdc/Config
  cp -Rf nvjdcbf/.local-chromium nolanjdc/.local-chromium
  cd /root
  echo -e "\033[32;1m 安装镜像，请耐心等候... \033[0m"
  sudo docker pull nolanhzy/nvjdc:latest
  cd ${Home}
  sudo docker run   --name nolanjdc -p ${JDC_PORT}:80 -d  -v  "$(pwd)":/app \
  -v /etc/localtime:/etc/localtime:ro \
  -it --privileged=true  nolanhzy/nvjdc:latest
  rm -rf ${QL_PATH}/nvjdcbf
  if [[ `docker ps -a | grep -c "nvjdc"` -ge '1' ]]; then
    echo -e "\033[32;1m nvjdc镜像启动成功 \033[0m"
  else
    echo -e "\033[32;1m nvjdc镜像启动失败 \033[0m"
    exit 1
  fi
  timeout -k 1s 4s docker logs -f nolanjdc
  echo -e "\033[32;1m nvjdc升级完成 \033[0m"
  exit 0
