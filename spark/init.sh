#!/bin/bash

pushd /root > /dev/null

if [ -d "spark" ]; then
  echo "Spark seems to be installed. Exiting."
  return
fi

mkdir spark
pushd spark > /dev/null
git init
repo="https://github.com/zhaozhang/spark.git"
git_hash="streaming-pyKira"
git remote add origin $repo
git fetch origin
git checkout $git_hash
build/mvn -Pyarn -Phadoop-2.4 -Dhadoop.version=2.4.0 -DskipTests clean package
#sbt/sbt clean assembly
#sbt/sbt publish-local
popd > /dev/null


popd > /dev/null
