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

<img src="https://user-images.githubusercontent.com/86009768/131354917-b95f56d0-c415-4a98-9f47-b3c00262c1c2.png"  width="250" height="200">

### Reverberation time

The time it takes for the signal to fall by 60dB.

<img src="https://user-images.githubusercontent.com/86009768/131359020-0cfd08f7-8b85-4f60-b6f8-86081af1276d.png"  width="250" height="200">

* RT 60 : Time required for 60dB reduction of direct sound reflections
* Reverberation time ∝"Room size"
* Reverberation time ∝"1/Absorption"

### Comb filter

Comb filter is the basic building block for digital audio effects and the basic filter for feedback delay newtork. There are two types, Feedforward and Feedback, but the feedback type is used for FDN.

<p align="center">
  <img src="https://user-images.githubusercontent.com/86009768/132219635-1a214f4e-d7b5-434b-9656-cbab83b38761.png"  width="500" height="100">
</p>

* A difference equation describing the feedback comb filter can be written as **𝑦(𝑛)=𝑥(𝑛−𝜏)+𝑔∗𝑦(𝑛−𝜏)**.
* The feedback comb filter is a special case of an Infinite Impulse Response (IIR) ("recursive'') digital filter, since there is feedback from the delayed output to the input.
* For stability, and for setting the reverberation time to a desired value, we need to move the poles slightly inside the unit circle in the z plane.
* To define a desired reverberation time for comb filters every gain has to be set according to the following equation. 
<p align="center">
  <img src="https://user-images.githubusercontent.com/86009768/132216787-ad42776d-525e-415d-b1ab-e95b075b9ee6.png"  width="250" height="100">
<p>
  
### Direct sound, early reflection and late reflection
<img src="https://user-images.githubusercontent.com/86009768/132230822-c3676994-879f-44d6-8dd8-14b37731b3e5.png"  width="450" height="250"> <img src="https://user-images.githubusercontent.com/86009768/132230818-affd21b1-f6e4-4945-bb5d-267fc443cd60.png"  width="450" height="250">


Direct sound 
* Direct sound means the sound that comes directly to our ears from the reverberation space.

Ealry reflection 
* Early reflection means a response that is not high in density because it is reflected twice or more.
* Early reflection is Important cues of time separation, frequency characteristics, and incident angle of the reflections.

Late reflection
* Late reflection means a response with high reflection density.


### Feedback Delay Network (FDN)

Feedback delay networks (FDNs) are recursive filters, which are widely used for artificial reverberation and  built around multiple delays which are feedback to their inputs and by this mimic the sound waves bouncing back and forth in an acoustic space.
 
FDN was first proposed by Gerzon ["Synthetic stereo reverberation, parts i and ii," Studio Sound, vol. 13(I), 14(II), pp. 632-635(I)] as a cross-coupled structure of several comb filters, which is a form of orthogonal matrix feedback after delay lines.
  
Afterwards, stautner and pauckette["Designing multichannel reverberators," Computer Music Journal, vol. 6, no. 1, pp. 52-65, 1982]  proposed a four-channel FDN of rich sound with a hardamard matrix and stability.
  
* How to implemetation?
  
  The FDN can be seen as a vector feedback comb filter, obtained by replacing the delay line with a diagonal delay matrix, and replacing the feedback gain by the product of a feedback matrix which can be understood as a permutation of a 4*4 hadamard matrix.

<p align="center">  
    <img src="https://user-images.githubusercontent.com/86009768/131666658-3982d785-f14c-4566-853e-9722849eec2b.png"  width="800" height="300">
<p>


* 4-channel FDN and hadamard matrix.
  <p align="center">  
    <img src="https://user-images.githubusercontent.com/86009768/132512049-35a31185-cdfa-42bd-a407-262003902562.png"  width="400" height="300">
<p>

 Feedback matrix = Hadamard matrix * 1/√(2 ) * gain

<p align="center">  
      <img src="https://user-images.githubusercontent.com/86009768/132512038-ff6ca9cf-a5f7-4cc9-b06f-8a218fbe355d.png"  width="400" height="300">
<p>

  * How to set parameters?
  
    Direct sound(d) : The amplitude of the sound pressure emanating from a simple source (point source) drops as 1/distance. 
  
    Reflection(b_n or c_n) : In general, the attenuation of a ray coming from an image source will be approximately att=k^m/src_to_lis.
    * k is the amplitude reflection coefficient of the wall. The amplitude attenuation k is related to the energy absorption coefficient by k=(1-absortion)^(1/2). A typical value for absorption coefficients is 0.04 at 500 Hz, yielding yielding k=  1/√(1-0.04)=0.98.
    * m is the numbers of walls.
    * Src_to_lis is the distance from the image source to the listener position.
  
    Delay length(m_n)
    * The corresponding delay is Del = src_to_lis/VEL * sampling frequency 
    * Longest delay length were typically about 1/10sec(if sampling frequency is 44100Hz, longest delay is 4410 sample).
    * Lengths spanning a ratio of 1:1.5
    * Following Schroeder's original insight, the delay line lengths in an FDN are typically chosen to be mutually prime.

  # Experiment result
    
    Comb filter and reverberation time
    * Input : impulse
    * Parmeters 
      * sampling frequency : 1000Hz
      * delay sample : 30 sample
      * reverberation time : 1.2sec
      * gain : 0.8414 (calculation using formulas)
    * Results
  
