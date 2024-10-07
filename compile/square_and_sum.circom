template SquareAndSum() {
  signal input x;
  signal input y;
  signal output z;

  signal x2;
  signal y2;

  // x^2 + y^2 = z
  x2 <== x * x;
  y2 <== y * y;
  z <== x2 + y2;
}

component main = SquareAndSum();
