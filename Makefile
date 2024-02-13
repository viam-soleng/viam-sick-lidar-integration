WS=./sick_scan_ws
MB=$(WS)/msgbuild
LB=$(WS)/build

initsb:
	# update lidar submodule
	@git submodule init
	@git submodule update

buildso: initsb
	# build so
	@mkdir -p $(WS)
	@mkdir -p $(MB)
	@mkdir -p $(LB)
	# ldmrs
	@cd $(WS); git clone https://github.com/SICKAG/libsick_ldmrs.git
	@cd $(WS); git clone https://github.com/SICKAG/msgpack11.git
	@cd $(WS); git clone https://github.com/SICKAG/sick_scan_xd.git
	@cd $(WS)/libsick_ldmrs; mkdir -p ./build
	@cd $(WS)/libsick_ldmrs/build; cmake -G "Unix Makefiles" ..; make 
	# msgpack
	@cd $(MB); cmake -G "Unix Makefiles" -DMSGPACK11_BUILD_TESTS=0	-DCMAKE_POSITION_INDEPENDENT_CODE=ON ../msgpack; make
	# support for multiScan100/picoScan100
	@cd $(LB); export ROS_VERSION=0; cmake -DROS_VERSION=0 -G "Unix Makefiles" ../sick_scan_xd; make

buildso-generic: buildso
	# build lidar shared object

buildso-ros1: buildso
	# build lidar shared object

buildso-ros2: buildso
	# build lidar shared object

clean:
	@rm -rf $(WS)
