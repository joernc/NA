#!/bin/bash

pmeta=$( ls -t pickup.0*.meta |head -1 )
plabel=$( echo $pmeta | sed 's/pickup.\(.*\).meta/\1/' )


iter=$plabel

# update iteration number
# sed -i.bak -e 's/nIter0 =\(.*\)/nIter0 =$iter' data
sed -i.bak -e "s/nIter0      =\(.*\)/nIter0      =$iter,$extra/I" data

echo "Updated data: pickup $iter ($plabel)"
