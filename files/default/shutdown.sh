#!/bin/bash

# Copyright 1999-2018 Alibaba Group Holding Ltd.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
cd `dirname $0`/../target
target_dir=`pwd`

pid_file="/var/run/nacos/nacos.pid"
if [ -f "$pid_file" ]; then
    pid=$(cat "$pid_file")
else
    # Get the PID from the process list
    pid=`pgrep 'nacos.nacos'`
fi
if [ -z "$pid" ] ; then
    echo "No nacosServer running."
    exit -1;
fi

echo "The nacosServer(${pid}) is running..."

kill ${pid}

echo "Send shutdown request to nacosServer(${pid}) OK"

rm -f $pid_file
exit 0;
