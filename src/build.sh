#!/bin/bash

image=$1
comp=$2

apptainer exec $image make $comp