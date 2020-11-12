#################################################################################
#  Copyright 2020 ARM Ltd.
#  
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#  
#      http://www.apache.org/licenses/LICENSE-2.0
#  
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#################################################################################

# RX GCC COMPILLER FLAGS

macro(SET_COMPILER_DBG_RLZ_FLAG flag value)
    SET(${flag}_DEBUG "${${flag}_DEBUG} ${value}")
    SET(${flag}_RELEASE "${${flag}_RELEASE} ${value}")

    if (0)
        message("flag = ${flag}")
        message("value = ${value}")
        message("MY_C_FLAGS_RELEASE2 = ${CMAKE_C_FLAGS_RELEASE}")
    endif(0) # comment end
endmacro(SET_COMPILER_DBG_RLZ_FLAG)

SET_COMPILER_DBG_RLZ_FLAG (CMAKE_C_FLAGS "")
SET_COMPILER_DBG_RLZ_FLAG (CMAKE_CXX_FLAGS "")

# The flags generated by E2 Studio IDE (RX65N Cloud Kit example project)
SET(CMAKE_COMPILE_FLAGS_COMMON "\
-ffunction-sections \
-fdata-sections \
-Wstack-usage=8192 \
-mcpu=rx64m \
-misa=v2 \
-mlittle-endian-data \
-Wa,-adlnh=\"$(basename $(notdir $<)).lst\" \
-MMD \
-MP \
")


### ASM FLAGS ###
SET(CMAKE_ASM_FLAGS_DEBUG "${CMAKE_ASM_FLAGS_DEBUG} -DDEBUG -g2 -O0")
SET(CMAKE_ASM_FLAGS_RELEASE "${CMAKE_ASM_FLAGS_RELEASE} -O0")
SET_COMPILER_DBG_RLZ_FLAG (CMAKE_ASM_FLAGS "${CMAKE_COMPILE_FLAGS_COMMON}")


### C/C++ FLAGS ###
SET(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -DDEBUG -g2 -O0")
SET(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O0")

SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DDEBUG -g2 -O0")
SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O0")

message("${CMAKE_SOURCE_DIR}/include_file.txt")
SET_COMPILER_DBG_RLZ_FLAG (CMAKE_C_FLAGS "@${CMAKE_SOURCE_DIR}/include_file.txt")
SET_COMPILER_DBG_RLZ_FLAG (CMAKE_CXX_FLAGS "@${CMAKE_SOURCE_DIR}/include_file.txt")

SET_COMPILER_DBG_RLZ_FLAG (CMAKE_C_FLAGS "${CMAKE_COMPILE_FLAGS_COMMON} -std=gnu99")
SET_COMPILER_DBG_RLZ_FLAG (CMAKE_CXX_FLAGS "${CMAKE_COMPILE_FLAGS_COMMON}")


### LINKER FLAGS ###
SET_COMPILER_DBG_RLZ_FLAG (CMAKE_EXE_LINKER_FLAGS "-Wl,--start-group -lm -lc -lgcc -Wl,--end-group -nostartfiles")

if (PAL_MEMORY_STATISTICS) #currently working only in gcc based compilers
	SET_COMPILER_DBG_RLZ_FLAG (CMAKE_EXE_LINKER_FLAGS "-Wl,--wrap=malloc")
	SET_COMPILER_DBG_RLZ_FLAG (CMAKE_EXE_LINKER_FLAGS "-Wl,--wrap=free")
	SET_COMPILER_DBG_RLZ_FLAG (CMAKE_EXE_LINKER_FLAGS "-Wl,--wrap=calloc")
	add_definitions("-DPAL_MEMORY_STATISTICS")
endif()

# \todo Remove flags duplication. Check new TOOLCHAIN-flag.cmake structure.
message("CMAKE_ASM_FLAGS_DEBUG: ${CMAKE_ASM_FLAGS_DEBUG}")
message("CMAKE_C_FLAGS_DEBUG: ${CMAKE_C_FLAGS_DEBUG}")
message("CMAKE_CXX_FLAGS_DEBUG: ${CMAKE_CXX_FLAGS_DEBUG}")
message("CMAKE_EXE_LINKER_FLAGS_DEBUG: ${CMAKE_EXE_LINKER_FLAGS_DEBUG}")