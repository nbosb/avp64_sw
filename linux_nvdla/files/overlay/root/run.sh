#!/bin/sh
modprobe drm
insmod opendla.ko
echo "start"
./nvdla_runtime --loadable basic.nvdla --image nine.pgm --rawdump
./nvdla_runtime --loadable basic.nvdla --image nine.pgm --rawdump
./nvdla_runtime --loadable basic.nvdla --image nine.pgm --rawdump
./nvdla_runtime --loadable basic.nvdla --image nine.pgm --rawdump
./nvdla_runtime --loadable basic.nvdla --image nine.pgm --rawdump
echo "end"
echo "result:"
cat output.dimg
