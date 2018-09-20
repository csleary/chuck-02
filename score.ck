BPM bpm;
bpm.setTempo(68);
bpm.wholeNote => dur bar;
bpm.sixteenthNote => dur sixteenth;
spork ~ bpm.barLoop();

fun string error(string message) {
    <<< message >>>;
}

fun int[] pattern(int pulses, int steps) {
    if (pulses > steps) {
        error("Steps should be > pulses.");
    }

    if (steps % pulses == 0) {
        int array[0];
        steps / pulses => int quotient; 
        for (0 => int i; i < pulses; i++) {
            array << 1;
            repeat(quotient - 1) array << 0;
        }
        return array;
    }

    int array[steps][0];
    steps - pulses => int rests;
    for (0 => int i; i < pulses; i++) {
        array[i] << 1;
    }
    for (pulses => int i; i < steps; i++) {
        array[i] << 0;
    }

    int m, k, limit, quotient;
    if (pulses > rests) {
        pulses => m; rests => k;
    } else {
        pulses => k; rests => m;
    }

    while (k > 0) {
        // To see stages.
        <<< "STAGE: " + m, k, limit >>>;
        for (0 => int i; i < array.size(); i++) {
            for (0 => int j; j < array[i].size(); j++) {
                <<< array[i][j] >>>;
            }
            <<< "***" >>>;
        }

        // <<< array[array.size()-1].size(), array[array.size()-2].size() >>>;
        repeat (quotient + 1) {
            if (array[array.size()-2].size() > array[array.size()-1].size()) break;
            <<< "WORKING!" >>>;
            <<< "ARRAY SIZE: " + array.size() >>>;
            for (m => int i; i < array.size(); i++) {
                for (0 => int j; j < array[i].size(); j++) {
                    array[i][j] => int remainder;
                    <<< "MOVING: " + i + " to " + (i - m)>>>;
                    array[i - m] << remainder;
                }
                if (array[i].size() > 0) {
                <<< "POPPING " + array[i].size() + " ARRAYS!" >>>;
                    repeat(array[i].size()) array[i].popBack();
                }
            }

            while (array[array.size() - 1].size() == 0) {
                array.popBack();
            }
        }
        <<< "AFTER PROCESSING: " + m, k >>>;
        for (0 => int i; i < array.size(); i++) {
            for (0 => int j; j < array[i].size(); j++) {
                <<< array[i][j] >>>;
            }
            <<< "***" >>>;
        }

        m/k => quotient;
        k => int tmp;
        m % k => k;
        tmp => m;
    }

    int flattened[0];
    for (0 => int i; i < array.size(); i++) {
        for (0 => int j; j < array[i].size(); j++) {
            flattened << array[i][j];
        }
    }
    return flattened;
}

pattern(13, 24) @=> int result[];
for (0 => int i; i < result.size(); i++) {
    <<< "RESULTS: " + result[i] >>>;
}

fun void tone (float freq, dur length) {
    SinOsc oscil => ADSR envAmp => dac;
    1./8 => oscil.gain;
    Std.mtof(freq) => oscil.freq;
    envAmp.set(10::ms, length, .1, 4::sixteenth);
    envAmp.keyOn();
    length/2 => now;
    envAmp.keyOff();
    envAmp.releaseTime() => now;
}

fun void seq (int array[], float pitch) {
    bar/array.size() => dur div;

    for (0 => int i; i < array.size(); i++) {
        if (array[i]) {
            spork ~ tone(pitch, div);
        }
        div => now;
    }
    bar => now;
}

// while(true) {
//     // spork ~ seq(pattern(4, 9), 82);
//     // spork ~ seq(pattern(3, 9), 79);
//     spork ~ seq(pattern(1, 16), 72);
//     spork ~ seq(pattern(2, 7), 74);
//     spork ~ seq(pattern(6, 13), 58);
//     spork ~ seq(pattern(3, 7), 55);
//     spork ~ seq(pattern(3, 14), 48);
//     spork ~ seq(pattern(3, 10), 36);
//     spork ~ seq(pattern(1, 2), 24);
//     bar => now;
// }