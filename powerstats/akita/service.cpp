/*
 * Copyright (C) 2021 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "android.hardware.power.stats-service.pixel"

#include <dataproviders/DisplayStateResidencyDataProvider.h>
#include <dataproviders/GenericStateResidencyDataProvider.h>
#include <dataproviders/PowerStatsEnergyConsumer.h>
#include <ZumaCommonDataProviders.h>
#include <PowerStatsAidl.h>

#include <android-base/logging.h>
#include <android-base/properties.h>
#include <android/binder_manager.h>
#include <android/binder_process.h>
#include <log/log.h>
#include <sys/stat.h>

using aidl::android::hardware::power::stats::DisplayStateResidencyDataProvider;
using aidl::android::hardware::power::stats::EnergyConsumerType;
using aidl::android::hardware::power::stats::GenericStateResidencyDataProvider;
using aidl::android::hardware::power::stats::PowerStatsEnergyConsumer;

void addDisplay(std::shared_ptr<PowerStats> p) {
    // Add display residency stats
    struct stat buffer;
    if (stat("/sys/class/drm/card0/device/primary-panel/time_in_state", &buffer)) {
        // time_in_state doesn't exist
        std::vector<std::string> states = {
            "Off",
            "LP: 1080x2400@30",
            "On: 1080x2400@60",
            "On: 1080x2400@120",
            "HBM: 1080x2400@60",
            "HBM: 1080x2400@120"};

        p->addStateResidencyDataProvider(std::make_unique<DisplayStateResidencyDataProvider>(
                "Display",
                "/sys/class/backlight/panel0-backlight/state",
                states));
    } else {
        // time_in_state exists
        addDisplayMRR(p);
    }

    // Add display energy consumer
    p->addEnergyConsumer(PowerStatsEnergyConsumer::createMeterAndEntityConsumer(
            p, EnergyConsumerType::DISPLAY, "Display", {"VSYS_PWR_DISPLAY"}, "Display",
            {{"LP: 1080x2400@30", 1},
             {"On: 1080x2400@60", 2},
             {"On: 1080x2400@120", 3},
             {"HBM: 1080x2400@60", 4},
             {"HBM: 1080x2400@120", 5}}));
}

void addGPS(std::shared_ptr<PowerStats> p)
{
    // A constant to represent the number of microseconds in one millisecond.
    const int US_TO_MS = 1000;

    // gnss power_stats are reported in microseconds. The transform function
    // converts microseconds to milliseconds.
    std::function<uint64_t(uint64_t)> gnssUsToMs = [](uint64_t a) { return a / US_TO_MS; };

    const GenericStateResidencyDataProvider::StateResidencyConfig gnssStateConfig = {
        .entryCountSupported = true,
        .entryCountPrefix = "count:",
        .totalTimeSupported = true,
        .totalTimePrefix = "duration_usec:",
        .totalTimeTransform = gnssUsToMs,
        .lastEntrySupported = true,
        .lastEntryPrefix = "last_entry_timestamp_usec:",
        .lastEntryTransform = gnssUsToMs,
    };

    // External GNSS power stats are controlled by GPS chip side. The power stats
    // would not update while GPS chip is down. This means that GPS OFF state
    // residency won't reflect the elapsed off time. So only GPS ON state
    // residency is present.
    const std::vector<std::pair<std::string, std::string>> gnssStateHeaders = {
        std::make_pair("ON", "GPS_ON:"),
    };

    std::vector<GenericStateResidencyDataProvider::PowerEntityConfig> cfgs;
    cfgs.emplace_back(generateGenericStateResidencyConfigs(gnssStateConfig, gnssStateHeaders),
            "GPS", "");

    p->addStateResidencyDataProvider(std::make_unique<GenericStateResidencyDataProvider>(
            "/data/vendor/gps/power_stats", cfgs));
}

int main() {
    LOG(INFO) << "Pixel PowerStats HAL AIDL Service is starting.";

    // single thread
    ABinderProcess_setThreadPoolMaxThreadCount(0);

    std::shared_ptr<PowerStats> p = ndk::SharedRefBase::make<PowerStats>();

    setEnergyMeter(p);
    addAoC(p);
    addPixelStateResidencyDataProvider(p);
    addCPUclusters(p);
    addSoC(p);
    addGPS(p);
    addMobileRadio(p);
    addNFC(p);
    addPCIe(p);
    addWifi(p);
    addTPU(p);
    addUfs(p);
    addPowerDomains(p);
    addDvfsStats(p);
    addDevfreq(p);
    addGPU(p);
    addDisplay(p);

    const std::string instance = std::string() + PowerStats::descriptor + "/default";
    binder_status_t status = AServiceManager_addService(p->asBinder().get(), instance.c_str());
    LOG_ALWAYS_FATAL_IF(status != STATUS_OK);

    ABinderProcess_joinThreadPool();
    return EXIT_FAILURE;  // should not reach
}
