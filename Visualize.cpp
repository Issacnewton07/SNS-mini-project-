#include <iostream>
#include <thread>
#include <chrono>

int main() {

    // Hardcoded 4x5 EEG dataset
    double eeg_data[4][5] = {
        {0.1, 0.2, 0.3, 0.1, 0.0},
        {0.3, 0.1, 0.4, 0.2, 0.1},
        {0.5, 0.2, 0.1, 0.4, 0.3},
        {0.6, 0.5, 0.2, 0.1, 0.0}
    };

    const int channels = 4;
    const int samples = 5;

    while (true) {
        for (int s = 0; s < samples; s++) {
            std::cout << "Sample " << s << ": ";

            for (int c = 0; c < channels; c++) {
                std::cout << eeg_data[c][s] << " ";
            }

            std::cout << std::endl;

            // Simulate real-time sampling (256Hz → ~4 ms per sample)
            std::this_thread::sleep_for(std::chrono::milliseconds(4));
        }

        // Loop again from start (simulate continuous streaming)
    }

    return 0;
}
