.DEFAULT_GOAL := buildso-generic

WS=./sick_scan_ws
MB=$(WS)/msgbuild
LB=$(WS)/build
LDMRS_VER=0.1.0
INSTALL_DIR=$(shell pwd)/sickag

mkdirs:
	#setup directory structure
	@mkdir -p $(MB)
	@mkdir -p $(LB)
	@mkdir -p $(INSTALL_DIR)/launch

buildso: clean mkdirs
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
	# finalize install
	cp $(WS)/sick_scan_xd/launch/*.launch $(INSTALL_DIR)/launch

buildso-ros1: 
	# place holder in case
	@echo "not supported"

buildso-ros2: 
	# place holder in case
	@echo "not supported"

module.tar.gz: buildso-generic
	tar czf $@ run.sh main.py requirements.txt components LICENSE sickag

clean:
	@rm -rf $(WS)

clean-all: clean
	@rm -rf $(INSTALL_DIR)
