---
layout: post
title:  "Python Tone Generator"
date:   2014-06-29 09:01:13 +0000
permalink: /projects/python-tone-generator
featureimage: logo.svg
thumb: logo.svg
description: Generate tones or frequency sweeps on Linux in Python
---
This script generates a frequency sweep from 50 Hz to 10 kHz and is easily adjustable. Make sure you've installed pyaudio to make this run.

On Ubuntu: `sudo apt-get install python-pyaudio`

Sometimes it can take a while before it starts playing. It doesn't create smooth waveform transitions between each frequency step so you'll hear pops whenever the frequency changes. If you just need to play one particular frequency you can substitute the usage example for (remember to enter your own frequency, duration, and amplitude)

{% highlight python %}
generator = ToneGenerator()
generator.play(frequency, duration, amplitude)
{% endhighlight %}

Script:
{% highlight python %}
#!/usr/bin/env python
 
import numpy
import pyaudio
import math
 
 
class ToneGenerator(object):
 
    def __init__(self, samplerate=44100, frames_per_buffer=4410):
        self.p = pyaudio.PyAudio()
        self.samplerate = samplerate
        self.frames_per_buffer = frames_per_buffer
        self.streamOpen = False
 
    def sinewave(self):
        if self.buffer_offset + self.frames_per_buffer - 1 > self.x_max:
            # We don't need a full buffer or audio so pad the end with 0's
            xs = numpy.arange(self.buffer_offset,
                              self.x_max)
            tmp = self.amplitude * numpy.sin(xs * self.omega)
            out = numpy.append(tmp,
                               numpy.zeros(self.frames_per_buffer - len(tmp)))
        else:
            xs = numpy.arange(self.buffer_offset,
                              self.buffer_offset + self.frames_per_buffer)
            out = self.amplitude * numpy.sin(xs * self.omega)
        self.buffer_offset += self.frames_per_buffer
        return out
 
    def callback(self, in_data, frame_count, time_info, status):
        if self.buffer_offset < self.x_max:
            data = self.sinewave().astype(numpy.float32)
            return (data.tostring(), pyaudio.paContinue)
        else:
            return (None, pyaudio.paComplete)
 
    def is_playing(self):
        if self.stream.is_active():
            return True
        else:
            if self.streamOpen:
                self.stream.stop_stream()
                self.stream.close()
                self.streamOpen = False
            return False
 
    def play(self, frequency, duration, amplitude):
        self.omega = float(frequency) * (math.pi * 2) / self.samplerate
        self.amplitude = amplitude
        self.buffer_offset = 0
        self.streamOpen = True
        self.x_max = math.ceil(self.samplerate * duration) - 1
        self.stream = self.p.open(format=pyaudio.paFloat32,
                                  channels=1,
                                  rate=self.samplerate,
                                  output=True,
                                  frames_per_buffer=self.frames_per_buffer,
                                  stream_callback=self.callback)
 
 
###############################################################################
#                                 Usage Example                               #
###############################################################################
 
generator = ToneGenerator()
 
frequency_start = 50        # Frequency to start the sweep from
frequency_end = 10000       # Frequency to end the sweep at
num_frequencies = 200       # Number of frequencies in the sweep
amplitude = 0.50            # Amplitude of the waveform
step_duration = 0.43        # Time (seconds) to play at each step
 
for frequency in numpy.logspace(math.log(frequency_start, 10),
                                math.log(frequency_end, 10),
                                num_frequencies):
 
    print("Playing tone at {0:0.2f} Hz".format(frequency))
    generator.play(frequency, step_duration, amplitude)
    while generator.is_playing():
        pass                # Do something useful in here (e.g. recording)
{% endhighlight %}
