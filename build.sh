#!/bin/bash

image=/home/albert/mb-42/infrastructure/containers/lpt-apptainer/build/lpt.sif

apptainer exec $image make all