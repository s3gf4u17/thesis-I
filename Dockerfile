FROM ubuntu:20.04

RUN apt update

# install add-apt-repository tool
RUN apt install software-properties-common -y

# configure restricted, universe and multiverse repositories
RUN add-apt-repository restricted
RUN add-apt-repository universe
RUN add-apt-repository multiverse

# setup sources list
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

# setup keys
RUN apt install curl -y
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

RUN apt update

# ROS installation
RUN apt install ros-noetic-desktop-full -y

# environment setup
RUN chmod a+x /opt/ros/noetic/setup.bash
RUN echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc

# initialize rosdep
RUN apt install python3-rosdep -y
RUN rosdep init
RUN rosdep update

# prepare folder for volume connection
RUN mkdir -p /root/catkinws/src

# install screen to run multiple windows
RUN apt install screen -y

# install nano as text editor
RUN apt install nano -y

# install git to pull and push changes
RUN apt install git -y

# define colors for debug prints
RUN echo "color0='\033[0m'" >> /root/.bashrc
RUN echo "colorY='\033[0;33m'" >> /root/.bashrc
RUN echo "colorR='\033[0;31m'" >> /root/.bashrc
RUN echo "colorG='\033[0;32m'" >> /root/.bashrc

# debug the environment setup from previous step
RUN echo 'if [[ -z "${ROS_DISTRO}" ]]; then' >> /root/.bashrc
RUN echo '  echo "${colorR}ROS_DISTRO environment variable not defined. corrupted ros installation or environment setup${color0}"' >> /root/.bashrc
RUN echo 'else' >> /root/.bashrc
RUN echo '  echo "${colorG}ROS_DISTRO environment variable defined. correct ros installation and environment setup${color0}"' >> /root/.bashrc
RUN echo 'fi' >> /root/.bashrc

# run workspace setup script generated with catkin_make
RUN echo 'if [ -d "/root/catkinws/devel" ]; then' >> /root/.bashrc
RUN echo '  echo "${colorG}/root/catkinws/devel directory exits. running setup script${color0}"' >> /root/.bashrc
RUN echo '  source /root/catkinws/devel/setup.bash' >> /root/.bashrc
RUN echo 'else' >> /root/.bashrc
RUN echo '  echo "${colorR}/root/catkinws/devel directory does not exist. catkin workspace corrupted or catkin_make not called${color0}"' >> /root/.bashrc
RUN echo 'fi' >> /root/.bashrc

RUN echo 'screen -S "roscore" -dm bash -c "export DISPLAY=host.docker.internal:0; roscore"' >> /root/.bashrc
RUN echo 'echo "${colorY}waiting 5s for roscore to initialize${color0}" && sleep 5' >> /root/.bashrc
RUN echo 'screen -S "rqt_console" -dm bash -c "export DISPLAY=host.docker.internal:0; rosrun rqt_console rqt_console"' >> /root/.bashrc
RUN echo 'screen -S "rqt_logger_level" -dm bash -c "export DISPLAY=host.docker.internal:0; rosrun rqt_logger_level rqt_logger_level"' >> /root/.bashrc
RUN echo 'screen -S "rqt_graph" -dm bash -c "export DISPLAY=host.docker.internal:0; rosrun rqt_graph rqt_graph"' >> /root/.bashrc
RUN echo 'screen -S "rqt_plot" -dm bash -c "export DISPLAY=host.docker.internal:0; rosrun rqt_plot rqt_plot"' >> /root/.bashrc
RUN echo "cd root/catkinws" >> /root/.bashrc