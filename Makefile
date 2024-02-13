WS=./sick_scan_ws
MB=$(WS)/msgbuild
LB=$(WS)/build
LIB=./lib
LDMRS_VER=0.1.0
INSTALL_DIR=$(shell pwd)/sickag

buildso:
	# build so
	@mkdir -p $(WS)
	@mkdir -p $(MB)
	@mkdir -p $(LB)
	@mkdir -p $(INSTALL_DIR)
	# ldmrs
	@cd $(WS); git clone https://github.com/SICKAG/libsick_ldmrs.git
	@cd $(WS); git clone https://github.com/SICKAG/msgpack11.git
	@cd $(WS); git clone https://github.com/SICKAG/sick_scan_xd.git
	@cd $(WS)/libsick_ldmrs; mkdir -p ./build
	@cd $(WS)/libsick_ldmrs/build; cmake -DCMAKE_INSTALL_PREFIX=$(INSTALL_DIR) -G "Unix Makefiles" ..; make -j4; make -j4 install
	# msgpack
	@cd $(MB); cmake -DCMAKE_INSTALL_PREFIX=$(INSTALL_DIR) -G "Unix Makefiles" -DMSGPACK11_BUILD_TESTS=0 -DCMAKE_POSITION_INDEPENDENT_CODE=ON ../msgpack11; make -j4; make -j4 install
	# support for multiScan100/picoScan100
	@cd $(LB); export ROS_VERSION=0; cmake -DCMAKE_INSTALL_PREFIX=$(INSTALL_DIR) -DCMAKE_CXX_FLAGS=-I\ $(INSTALL_DIR)/include -DROS_VERSION=0 -G "Unix Makefiles" ../sick_scan_xd; make -j4; make -j4 install

buildso-generic: buildso
	# build lidar shared object

buildso-ros1: 
	@echo "not supported"

buildso-ros2: 
	@echo "not supported"

install:
	# install libraries as required
	@mkdir -p $(LIB)
	cp $(WS)/libsick_ldmrs/build/src/libsick_ldmrs.so.$(LDMRS_VER) $(LIB)
	@cd $(LIB); ln -s libsick_ldmrs.so.$(LDMRS_VER) libsick_ldmrs.so.0
	@cd $(LIB); ln -s libsick_ldmrs.so.$(LDMRS_VER) libsick_ldmrs.so
	
clean:
	@rm -rf $(WS)
	@rm -rf $(LIB)
	@rm -rf $(INSTALL_DIR)
