/**
 * a simple cross-language pseudorandom number generator (PRNG)
 * based on XorShift, implemented in Processing (Java)
 * inspired by https://stackoverflow.com/a/34659107/7207622
 */
class RandAnywhere {
  long seed;
  long a;
  long c;
  long m32;
  /**
   * Constructor
   * 
   * Defaults to current system time in milliseconds.
   */
  RandAnywhere() {
    this(System.currentTimeMillis());
  }
  /** 
   * @param  seed  starting seed value 
   */
  RandAnywhere(long seed) {
    this.a = 1664525;
    this.c = 1013904223;
    this.m32 = 0xFFFFFFFFL;
    this.randomSeed(seed);
  }
  /**
   * Updates seed based on past value, returns new value.
   * 
   * @return  unsigned 32bit value stored in a long
   */
  long nextLong() {
    this.seed = this.seed * a + c & m32;
    return this.seed;
  }
  /**
   * Returns next long wrapped to the max integer value.
   * Implemented so that calls to nextInt or nextLong stay in sync,
   * the next seed internally is always updated to the next long.
   * 
   * @return  positive 
   */
  int nextInt() {
    return (int)(this.nextLong()%Integer.MAX_VALUE);
  }
  /**
   * Set the current seed.
   * 
   * @param  newSeed  the new seed value
   */
  void randomSeed(long newSeed) {
    this.seed = newSeed%Integer.MAX_VALUE;
  }
  /**
   * @return  a random float between 0 and 1
   */
  float random() {
    return random(0, 1);
  }
  /**
   * @param   max  maximum value to return
   * @return  a random float between 0 and max
   */
  float random(float max) {
    return random(0, max);
  }  
  /**
   * @param   min  minimum value to return
   * @param   max  maximum value to return
   * @return       a random float in the specified range (min, max)
   */
  float random(float min, float max) {
    return map(this.nextInt(), 0, Integer.MAX_VALUE, min, max);
  }
}
