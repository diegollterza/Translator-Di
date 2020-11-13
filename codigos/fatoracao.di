main{
  int n;
  read(n);
  int i;
  for(i = 2; i < n; i = i + 1){
    if(n%i==0){
      print(i);
      print(' ');
    }
  }
}
