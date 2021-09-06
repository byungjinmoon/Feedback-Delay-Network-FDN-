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

<img src="https://user-images.githubusercontent.com/86009768/131359020-0cfd08f7-8b85-4f60-b6f8-86081af1276d.png"  width="350" height="200">

* RT 60 : Time required for 60dB reduction of direct sound reflections
* Reverberation time ∝"Room size"
* Reverberation time ∝"1/Absorption"

### Comb filter

Comb filter is the basic building block for digital audio effects and the basic filter for feedback delay newtork. There are two types, Feedforward and Feedback, but the feedback type is used for FDN.
* ![Comb filter](https://user-images.githubusercontent.com/86009768/132219635-1a214f4e-d7b5-434b-9656-cbab83b38761.png)
* A difference equation describing the feedback comb filter can be written as **𝑦(𝑛)=𝑥(𝑛−𝜏)+𝑔∗𝑦(𝑛−𝜏)**.
* The feedback comb filter is a special case of an Infinite Impulse Response (IIR) ("recursive'') digital filter, since there is feedback from the delayed output to the input.
* For stability, and for setting the reverberation time to a desired value, we need to move the poles slightly inside the unit circle in the z plane.
* To define a desired reverberation time for comb filters every gain has to be set according to the following equation. ![image](https://user-images.githubusercontent.com/86009768/132216787-ad42776d-525e-415d-b1ab-e95b075b9ee6.png)

### Direct sound, early reflection and late reflection


### Feedback Delay Network (FDN)

Feedback delay networks (FDNs) are recursive filters, which are widely used for artificial reverberation and  built around multiple delays which are feedback to their inputs and by this mimic the  sound waves bouncing back and forth in an acoustic space.

* How to implemetation?
  
  The FDN can be seen as a vector feedback comb filter, obtained by replacing the delay line with a diagonal delay matrix, and replacing the feedback gain by the product of a diagonal matrix times an orthogonal matrix.
  
  ![Comfilter to FDN](https://user-images.githubusercontent.com/86009768/131666658-3982d785-f14c-4566-853e-9722849eec2b.png)


  FDN structure - 4channel example 
  (각 parameter 구하는 밥법 정리 필요)
  
  ![FDN structure](https://user-images.githubusercontent.com/86009768/131669077-b834450b-f8f2-48bf-aec5-2f484338fe01.png)


