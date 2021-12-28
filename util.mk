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
