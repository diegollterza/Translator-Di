main{
  real a;
  real b;
  real c;
  real x1;
  real x2;
  read(a);
  read(b);
  read(c);
  real delta;
  delta = b^2 - 4*a*c;
  if(delta>0){
    x1 = (-b + delta^0.5)/(2*a);
    x2 = (-b - delta^0.5)/(2*a);
    print(x1);
    print(' ');
    print(x2);
  }else{
    print('E');
    print('r');
    print('r');
    print('o');
  }
}
