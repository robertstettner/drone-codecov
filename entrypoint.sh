#!/usr/bin/env bash

set -e

starttime=$(date +%s.%N)
files="${FILES:-$PLUGIN_FILES}"
flags="${FLAGS:-$PLUGIN_FLAGS}"

echo "-- Pushing coverage to Codecov..."

# check codecov token exist.
if [[ -z $PLUGIN_TOKEN ]] && [[ -z $CODECOV_TOKEN ]]; then
    echo "-- Error: missing Codecov token"
    exit 1
fi

set +e

sfiles=""
for f in $(echo $files | tr -d '[[:space:]]' | tr "," "\n"); do
    if [[ -f $PWD/$f ]]; then
      sfiles="$sfiles -f $PWD/$f"
    fi
done

sflags=""
if [[ -n $flags ]]; then
    sflags="-F $flags"
fi

token=""
branch=""
commit=""
pr=""
buildnum=""
tag=""

if [[ -n $PLUGIN_TOKEN ]]; then
    token="-t $PLUGIN_TOKEN"
fi
if [[ -n $CODECOV_TOKEN ]]; then
    token="-t $CODECOV_TOKEN"
fi
if [[ -n $DRONE_BRANCH ]]; then
    branch="-B $DRONE_BRANCH"
fi
if [[ -n $DRONE_COMMIT ]]; then
    commit="-C $DRONE_COMMIT"
fi
if [[ -n $DRONE_PULL_REQUEST ]]; then
    pr="-P $DRONE_PULL_REQUEST"
fi
if [[ -n $DRONE_BUILD_NUMBER ]]; then
    buildnum="-b $DRONE_BUILD_NUMBER"
fi
if [[ -n $DRONE_TAG ]]; then
    tag="-T $DRONE_TAG"
fi

if [[ $PLUGIN_DEBUG = "true" ]]; then
    echo "-- DEBUG: running following command..."
    echo "-- DEBUG: codecov $token $sfiles $sflags $branch $commit $pr $buildnum $tag"
fi

exitcode=`codecov -Z $token $sfiles $sflags \
    $branch \
    $commit \
    $pr \
    $buildnum \
    $tag &> output.log; echo $?`

if [[ $PLUGIN_DEBUG = "true" ]]; then
    cat output.log
fi

endtime=$(date +%s.%N)
echo "duration: $(echo "$endtime $starttime" | awk '{printf "%f", $1 - $2}')s"

if [[ $exitcode -eq 0 ]]; then
    echo "-- Coverage successfully pushed to Codecov!"
else
    echo "-- Coverage failed to push to Codecov!"
fi
