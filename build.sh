#!/bin/bash

image=$HOME/mb-42/infrastructure/containers/lpt-apptainer/build/lpt.sif

apptainer exec $image make all