# Feedback Delay Network (FDN) in matlab


An implementation of feedback delay network (FDN) in Matlab.

FDN implementation of:

* [Designing Multi-Channel Reverberators][research]

[research]: https://www.jstor.org/stable/3680358

* [Center for Computer Research in Music and Acoustics (CCRMA),   Stanford University][CCRMA]

[CCRMA]: https://ccrma.stanford.edu/~jos/pasp/Feedback_Delay_Networks_FDN.html
# Background

### Reverberation
Reverberation is a sound that continues even after the sound is generated.

<img src="https://user-images.githubusercontent.com/86009768/133998092-b797d53b-953f-4f46-bd78-5ffb00ab3e1f.png" width="500" height="400"/>
 
 [image from https://newenglandsoundproofing.com/reverberation_testing]
 
### Reverberation time

The time it takes for the signal to fall by 60dB.

<img src="https://user-images.githubusercontent.com/86009768/133998450-4a85b29a-53a5-4def-b36b-cb944bb9737e.png" width="500" height="300"/>

* RT 60 : Time required for 60dB reduction of direct sound reflections
* Reverberation time ∝"Room size"
* Reverberation time ∝"1/Absorption"

### Comb filter

Comb filter is the basic building block for digital audio effects and the basic filter for feedback delay newtork. There are two types, Feedforward and Feedback, but the feedback type is used for FDN.

  <img src="https://user-images.githubusercontent.com/86009768/134629256-e86ff561-b439-4d6c-9b72-cf4c0b29bc0b.png" width="500" height="130"/>



* A difference equation describing the feedback comb filter can be written as <img src="https://render.githubusercontent.com/render/math?math=y(n)=x(n-\sigma) %2B g\times y(n-\sigma)">
* The feedback comb filter is a special case of an Infinite Impulse Response (IIR) ("recursive'') digital filter, since there is feedback from the delayed output to the input.
* For stability, and for setting the reverberation time to a desired value, we need to move the poles slightly inside the unit circle in the z plane.
* To define a desired reverberation time for comb filters every gain has to be set according to the following equation. 
![image](https://user-images.githubusercontent.com/86009768/134629416-5e826b16-f27e-471d-adee-dfebceedcb09.png)

### Direct sound, early reflection and late reflection

<img src="https://user-images.githubusercontent.com/86009768/133999561-adab95f9-985b-4b74-bef5-07aa9a4dafdd.png" width="500" height="300"/>

Direct sound 
* Direct sound means the sound that comes directly to our ears from the reverberation space.

Ealry reflection 
* Early reflection means a response that is not high in density because it is reflected twice or more.
* Early reflection is Important cues of time separation, frequency characteristics, and incident angle of the reflections.

Late reflection
* Late reflection means a response with high reflection density.

<img src="https://user-images.githubusercontent.com/86009768/134004415-1b2267e1-fd8a-4b8b-8ab9-20e44e22a9e1.png" width="700" height="300"/>

### Feedback Delay Network (FDN)

Feedback delay networks (FDNs) are recursive filters, which are widely used for artificial reverberation and  built around multiple delays which are feedback to their inputs and by this mimic the sound waves bouncing back and forth in an acoustic space.
 
FDN was first proposed by Gerzon ["Synthetic stereo reverberation, parts i and ii," Studio Sound, vol. 13(I), 14(II), pp. 632-635(I)] as a cross-coupled structure of several comb filters, which is a form of orthogonal matrix feedback after delay lines.
  
Afterwards, stautner and pauckette["Designing multichannel reverberators," Computer Music Journal, vol. 6, no. 1, pp. 52-65, 1982]  proposed a four-channel FDN of rich sound with a hardamard matrix and stability.
  
* How to implemetation?
  
  The FDN can be seen as a vector feedback comb filter, obtained by replacing the delay line with a diagonal delay matrix, and replacing the feedback gain by the product of a feedback matrix which can be understood as a permutation of a 4*4 hadamard matrix.

<p align="center">
<img src="https://user-images.githubusercontent.com/86009768/134004869-203d938a-662d-4b35-82a2-9bdb688de1b5.png" width="800" height="330"/>
</p>

* 4-channel FDN and hadamard matrix.

  <img src="https://user-images.githubusercontent.com/86009768/134613727-e685859e-438e-439c-861b-db4860fbbe4c.png" width="700" height="380"/>


 Feedback matrix = Hadamard matrix * 1/√(2 ) * gain

  ![image](https://user-images.githubusercontent.com/86009768/134623341-b5011c26-9f72-4605-89fc-2f33b1b51b5b.png)

  * How to set parameters?
  
    Direct sound(<img src="https://render.githubusercontent.com/render/math?math=d">) : The amplitude of the sound pressure emanating from a simple source (point source) drops as <img src="https://render.githubusercontent.com/render/math?math=\frac{1}{distance}">. 
    
    Reflection(<img src="https://render.githubusercontent.com/render/math?math=b_n , c_n">) : In general, the attenuation of a ray coming from an image source will be approximately <img src="https://render.githubusercontent.com/render/math?math=att = \frac{k^{m}}{src to lis}">.
    * k is the amplitude reflection coefficient of the wall. The amplitude attenuation k is related to the energy absorption coefficient by     <img src="https://render.githubusercontent.com/render/math?math=k=\sqrt{(1-absortion)}">. 
    * A typical value for absorption coefficients is 0.04 at 500 Hz, yielding yielding <img src="https://render.githubusercontent.com/render/math?math=k=\sqrt{(1-0.04)}=0.98">.
    * m is the numbers of walls.
    * Src_to_lis is the distance from the image source to the listener position.
    
    Delay length(<img src="https://render.githubusercontent.com/render/math?math=m_n">)
    * The corresponding delay is <img src="https://render.githubusercontent.com/render/math?math=Delay = \frac{src to lis}{velocity of sound}\times fs">.
    * Longest delay length were typically about <img src="https://render.githubusercontent.com/render/math?math=\frac{1}{10sec}">(if sampling frequency is 44100Hz, longest delay is 4410 sample).
    * Lengths spanning a ratio of 1:1.5
    * Following Schroeder's original insight, the delay line lengths in an FDN are typically chosen to be mutually prime.

  
### Frequency dependent Feedback Delay Network (FDN)
  
FDN can achieve richer and more realistic reflections when simulating the frequency characteristics reflected from walls and objects in real environments.

Energy absorption occurs at frequencies between 500 Hz and 2000 Hz or higher.

And the reverberation time of the frequency in various spaces is different.

We can simulate this effect by adding a filter (IIR filter or FIR filter) to the FDN structure.
 
  * Structure
  
    <img src="https://user-images.githubusercontent.com/86009768/134628354-90a1135f-300a-44b5-ac95-60600651a515.png" width="700" height="380"/>
 
  * Frequency and reverberation time in various space
  
    <img src="https://user-images.githubusercontent.com/86009768/134627140-a7f2291e-9030-4bd2-aab9-7d8c4a1d211c.png" width="700" height="250"/>

 
### Energy Delay Relief (EDR)
  
EDR (Energy Delay Relief) is a time-frequency distribution of signal energy remaining in reverberator’s impulse response over time in multiple frequency bands.
  
The reverberation time for frequency bands can be confirmed by analyzing the EDR.

![image](https://user-images.githubusercontent.com/86009768/133886691-3479f339-16e6-4dc4-92d4-565c1e9dda7a.png)
 
[image frome https://www.dsprelated.com/freebooks/pasp/Energy_Decay_Relief.html]
 
* How to implemenation?

  ![image](https://user-images.githubusercontent.com/86009768/134629912-5908c12d-42e2-446b-bbae-6c10761f0f4a.png)
  * 𝐻(𝑚,𝑘) denotes bin 𝑘 of the Short Time Fourier transform (STFT) at time – frame 𝑚.

# Experiment result
    
### Comb filter and reverberation time
  
* Input : impulse
* Parmeters 
  * sampling frequency : 1000Hz
  * delay sample : 30 sample
  * reverberation time : 1.2sec
  * gain : 0.8414 (calculation using formulas)
* Results

  ![combfilter_result](https://user-images.githubusercontent.com/86009768/132975148-1acb6055-bbec-4ff1-9fe1-8c865b93c5fa.png)

### FDN impulse response and sound
  
* We can implement room impulse response (RIR) using FDN. RIR consists of direct sound, early reflections, and late reverberation.
* Parameters
  * sampling frequency : 44100Hz
  * src_to_lis : 20m 
  * T_60 : 2sec
* Implementation of RIR and reverberation sound using example audio 
 ![RIR of FDN](https://user-images.githubusercontent.com/86009768/133260397-767db130-8c9b-4a2d-a8e0-aad1cc3736e6.png)
  
  (original sound and reverberation sound)
  
### Frequency dependent FDN
  
* We can achieve richer and more realistic reverberation using frequency dependent FDN.
* FDN was implemented on the premise of an actual large space.
* Implementation1 (FIR filter)
  * input : audio sample
  * samling frequnecy : 44100Hz
  * frequency and reverberation time in large space
    * 125Hz - 3.25sec, 500Hz - 2.75sec, 2000Hz - 2.75sec
    * FIR filters (The gain was obtained by considering the reverberation time corresponding to the frequency, and the filters were also designed.)
      ![image](https://user-images.githubusercontent.com/86009768/133952989-adfd610b-9976-4eab-bb1a-18698cd696a0.png)
  
  * Implementation of EDR and plot energy decay with reverberation time at each frequency
     ![image](https://user-images.githubusercontent.com/86009768/133967559-40669261-0b16-4e80-9c9f-9f5641754a35.png)

  * Implementation of reverberation sound in a large area with frequency dependent FDN
    (sound)

* Implementation2 (IIR filter)
  * When an IIR filter is used, the reverberation time for each frequency cannot be implemented as accurate as the FIR filter, but a reverberator with a small computation can be implemented by designing a similar filter. 
  * We can design first-order IIR filter using DC gain and Nyquist gain. 
     
     First-order IIR filter 
     
     ![image](https://user-images.githubusercontent.com/86009768/133979041-e22a67c1-7974-485f-a03a-439147ed3cd8.png).
  
     The DC gain of this filter is 
     
     ![image](https://user-images.githubusercontent.com/86009768/133979410-8a73a045-0c76-457a-ab1e-b954856b820d.png).

  
     The Nyquist frequency gain of this filter is 
     
     ![image](https://user-images.githubusercontent.com/86009768/134631444-739a71ef-534f-4bce-8aa6-cfbb8e5a516b.png).

     Thus,
     
     ![image](https://user-images.githubusercontent.com/86009768/134632173-e4bfd329-2e8e-4884-bd95-7172db61d927.png)
     
     These two equations can be solved to yield 
     
     ![image](https://user-images.githubusercontent.com/86009768/134632263-0b9b620a-e095-4607-9cdd-ce90994bc0a2.png).

  * input : audio sample
  * samling frequnecy : 44100Hz
  * frequency and reverberation time in large space
    * DC - 3.25sec, Nyquist frequency - 1.0sec
    * IIR filters (With IIR filter, the reverberation time can be similarly implemented for each frequency.)
      ![image](https://user-images.githubusercontent.com/86009768/133982657-6dfb9470-28f1-4f56-a114-bdfbc405d0dd.png)    
    
  * Implementation of EDR and plot energy decay with reverberation time at each frequency
    ![image](https://user-images.githubusercontent.com/86009768/133983939-d7a27cc1-1493-4a61-9e10-7ca06f79e168.png)

  * Implementation of reverberation sound in a large area with frequency dependent FDN
    (sound)

  
