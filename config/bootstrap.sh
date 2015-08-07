#!/bin/bash
rm -rf $GALAXY_DATA
mkdir -p $GALAXY_DATA

./lib/tool_shed/scripts/bootstrap_tool_shed/bootstrap_tool_shed.sh \
		-bootstrap_from_tool_shed $BASE_TOOL_SHED
