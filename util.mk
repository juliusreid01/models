################################################################################
# 
# Author: J Reid
# Created: 12/28/2021
# 
# Description:
#     Include file for Make to keep utilities in one spot
#
# Notes:
#     To use simply type include $(PATH_TO)/util.mk
#     where PATH_TO is the location of this file
# 
# to print targets use this https://unix.stackexchange.com/questions/230047/how-to-list-all-targets-in-make
#    make -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}'
#   works all the time
################################################################################

# library files to generate
INCLUDE_LIBS = \
    interface_lib \
    item_lib

# template to create a shorter target
define SHORT_INCLUDE_TEMPLATE
   $(1): $(VERIF_DIR)/unit_tests/$(strip $(1)).svh
endef

# creates the shorter target i.e. make item_lib
$(foreach inclib, $(INCLUDE_LIBS), $(eval $(call SHORT_INCLUDE_TEMPLATE, $(inclib))))

# template to create the libraries
define LONG_INCLUDE_TEMPLATE
   $(1): 
	@echo $(notdir $(1)) ...
	@echo "// Generated by make. Do not edit" > $(1)
	@echo $(2) | tr ' ' '\012' | sed 's/^\(.*\)/`include "\1"/' >> $(1)
endef

# the call creates the targets to create the files
$(eval $(call LONG_INCLUDE_TEMPLATE, $(VERIF_DIR)/unit_tests/interface_lib.svh, $(INTERFACES)))
$(eval $(call LONG_INCLUDE_TEMPLATE, $(VERIF_DIR)/unit_tests/item_lib.svh, $(SEQ_ITEMS)))

# get unit tests
UNIT_TESTS = $(notdir $(wildcard $(VERIF_DIR)/unit_tests/*_test.sv))

# template to create a target for each unit test
define UNIT_TEST_TEMPLATE
   $(1): $(INCLUDE_LIBS)
	$(XRUN_CMD) $(1)
endef

# the call creates the actual target
$(foreach unit_test, $(UNIT_TESTS), $(eval $(call UNIT_TEST_TEMPLATE, $(unit_test))))

# used to store the date in a variable as YYYYMMDD_HHMMSS
DATE = `date "+%Y%m%d_%H%M%S"`

# print the value of a variable
print-%:
	@echo $* = $($*)

# print the value of a variable as a list
printn-%:
	@echo $* =
	@echo $($*) | tr ' ' '\012'

# confirm the target variable exists
ls-%:
	@ls $($*)
