#!/bin/bash

clear
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt install curl
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
sudo apt update
sudo apt install ros-noetic-desktop-full
echo "source /opt/ros/noetic/setup.bash" > .bashrc
source /opt/ros/noetic/setup.bash
echo "What brand of RPLidar Sensor you have?"
echo "1: Slamtec	2: RoboPeak"
read lidarselect
if  [$lidarselect -eq 1]
then
	mkdir -p catkin_ws/src
	cd catkin_ws/src
	git clone https://github.com/Slamtec/rplidar_ros.git
	git clone https://github.com/tu-darmstadt-ros-pkg/hector_slam.git
	sed -i '<arg name="base_frame" default="base_footprint"/>/c\<arg name="base_frame" default="base_link"/>' hector_slam/hector_mapping/launch/mapping_default.launch
	sed -i '<arg name="odom_frame" default="nav"/>/c\<arg name="odom_frame" default="base_link"/>' hector_slam/hector_mapping/launch/mapping_default.launch
	sed -i '<!--<node pkg="tf" type="static_transform_publisher" name="map_nav_broadcaster" args="0 0 0 0 0 0 map nav 100"/>-->/c\<node pkg="tf" type="static_transform_publisher" name="base_to_laser_broadcaster" args="0 0 0 0 0 0 base_link laser 100"/>' hector_slam/hector_mapping/launch/mapping_default.launch
	sed -i '<param name="/use_sim_time" value="true"/>/c\<param name="/use_sim_time" value="false"/>' hector_slam/hector_slam_launch/launch/tutorial.launch
	cd ..
	catkin_make
	source devel/setup.bash
else
	mkdir -p catkin_ws/src
	cd catkin_ws/src
	git clone https://github.com/robopeak/rplidar_ros.git
	git clone https://github.com/tu-darmstadt-ros-pkg/hector_slam.git
	sed -i '<arg name="base_frame" default="base_footprint"/>/c\<arg name="base_frame" default="base_link"/>' hector_slam/hector_mapping/launch/mapping_default.launch
	sed -i '<arg name="odom_frame" default="nav"/>/c\<arg name="odom_frame" default="base_link"/>' hector_slam/hector_mapping/launch/mapping_default.launch
	sed -i '<!--<node pkg="tf" type="static_transform_publisher" name="map_nav_broadcaster" args="0 0 0 0 0 0 map nav 100"/>-->/c\<node pkg="tf" type="static_transform_publisher" name="base_to_laser_broadcaster" args="0 0 0 0 0 0 base_link laser 100"/>' hector_slam/hector_mapping/launch/mapping_default.launch
	sed -i '<param name="/use_sim_time" value="true"/>/c\<param name="/use_sim_time" value="false"/>' hector_slam/hector_slam_launch/launch/tutorial.launch
	cd ..
	catkin_make
	source devel/setup.bash
fi
clear
echo "ROS install done"
