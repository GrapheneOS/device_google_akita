#!/bin/sh

# Copyright 2023 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

source ../../../common/clear-factory-images-variables.sh
BUILD=10978315
DEVICE=akita
PRODUCT=akita
VERSION=ud2a.231020.001
SRCPREFIX=signed-
BOOTLOADER=akita-14.1-10943696
RADIO=g5300o-231012-231016-B-10954749
source ../../../common/generate-factory-images-common.sh
