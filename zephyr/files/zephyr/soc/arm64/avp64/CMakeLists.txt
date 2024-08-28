##############################################################################
#                                                                            #
# Copyright 2024  Nils Bosbach                                               #
#                                                                            #
# This software is licensed under the Apache license.                        #
# A copy of the license can be found in the LICENSE file at the root         #
# of the source tree.                                                        #
#                                                                            #
##############################################################################

zephyr_library_sources_ifdef(CONFIG_ARM_MMU mmu_regions.c)
zephyr_library_sources(soc.c)

set(SOC_LINKER_SCRIPT ${ZEPHYR_BASE}/include/zephyr/arch/arm64/scripts/linker.ld CACHE INTERNAL "")
