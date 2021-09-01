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
* Reverberation time ∝"1/Absorption

### Feedback Delay Network (FDN)

The FDN can be seen as a vector feedback comb filter, obtained by replacing the delay line with a diagonal delay matrix, and replacing the feedback gain by the product of a diagonal matrix times an orthogonal matrix.

* How to implemetation?
  


  * comb filter st

