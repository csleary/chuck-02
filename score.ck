BPM bpm;
bpm.setTempo(68);
bpm.wholeNote => dur bar;
bpm.sixteenthNote => dur sixteenth;
spork ~ bpm.barLoop();
Euclidean E;

// dac => WvOut2 render => blackhole; 
// "second_mix.wav" => render.wavFilename;

GVerb reverb => dac;
1. => reverb.gain;
fun void tone (float pitch, dur length, float velocity)
{
    // <<< "Pitch: " + pitch >>>;
    Step pitchMod => ADSR envPitch => SinOsc oscil => ADSR envAmp => dac;
    envAmp => Gain send => reverb;
    .3 => send.gain;

    2 => oscil.sync;
    (velocity/127) * (1./10) => oscil.gain;

    Std.mtof(.1) => pitchMod.next;
    .2 => envPitch.gain;

    Std.mtof(pitch) => oscil.freq;
    envPitch.set(10::ms, length, 1, 2::sixteenth);
    envAmp.set(10::ms, length, .1, 4::sixteenth);
    envPitch.keyOn();
    envAmp.keyOn();
    length/2 => now;
    envPitch.keyOff();
    envAmp.keyOff();
    envAmp.releaseTime() => now;
}

fun void seq (int array[], float pitch, float velocity)
{
    bar/array.size() => dur div;

    for (0 => int i; i < array.size(); i++)
    {
        if (array[i])
        {
            spork ~ tone(pitch, div, velocity);
        }
        div => now;
    }
    bar => now;
}

while (bpm.locator < 80)
{
    repeat (6)
    {
        partA();
        bar => now;
    }
        partB();
        bar => now;
        partC();
        bar => now;
}
bar => now;
// render.closeFile();

fun void partA()
{
    spork ~ seq(E.pattern(2, 11), 84, 30);
    spork ~ seq(E.pattern(3, 9), 76, 30);
    spork ~ seq(E.pattern(2, 7), 74, 30);
    spork ~ seq(E.pattern(1, 16), 72, 30);
    
    spork ~ seq(E.pattern(2, 17), 60, 127);
    spork ~ seq(E.pattern(6, 13), 58, 127);
    spork ~ seq(E.pattern(3, 7), 55, 127);

    spork ~ seq(E.pattern(3, 14), 48, 127);
    spork ~ seq(E.pattern(3, 10), 36, 127);
    spork ~ seq(E.pattern(1, 2), 24, 127);
}

fun void partB()
{
    spork ~ seq(E.pattern(2, 11), 82, 30);
    spork ~ seq(E.pattern(3, 9), 74, 30);
    spork ~ seq(E.pattern(2, 7), 72, 30);
    spork ~ seq(E.pattern(1, 16), 70, 30);
    
    spork ~ seq(E.pattern(2, 17), 60, 127);
    spork ~ seq(E.pattern(6, 13), 58, 127);
    spork ~ seq(E.pattern(3, 7), 55, 127);

    spork ~ seq(E.pattern(3, 14), 43, 127);
    spork ~ seq(E.pattern(3, 10), 31, 127);
    spork ~ seq(E.pattern(1, 2), 19, 127);
}

fun void partC()
{
    spork ~ seq(E.pattern(3, 11), 84, 30);
    spork ~ seq(E.pattern(3, 7), 76, 30);
    spork ~ seq(E.pattern(2, 7), 72, 30);
    spork ~ seq(E.pattern(1, 16), 69, 30);
    spork ~ seq(E.pattern(4, 9), 67, 30);
    
    spork ~ seq(E.pattern(2, 17), 60, 127);
    spork ~ seq(E.pattern(6, 13), 57, 127);
    spork ~ seq(E.pattern(3, 7), 53, 127);

    spork ~ seq(E.pattern(3, 14), 41, 127);
    spork ~ seq(E.pattern(3, 10), 29, 127);
    spork ~ seq(E.pattern(1, 2), 17, 127);
}