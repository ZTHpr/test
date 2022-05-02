#include <iostream>

using std::cout;
using std::endl;
struct S {
  int value;
};
long double operator"" _cm(long double x) { return x * 10; }

long double operator"" _m(long double x) { return x * 1000; }

long double operator"" _mm(long double x) { return x; }

// 用户定义字面量运算符的实现
S operator""_mysuffix(unsigned long long v) {
  S s_;
  s_.value = (int)v;
  return s_;
}

void fun0(void){
  int i=0;
}
void fun1(void){
  for(int i=0;i<200;i++){
    fun0();
  }
}

int main(void) {
  // height = 30.0
  auto height = 3.0_cm;

  // length = 1230.0
  auto length = 1.23_m;
  while(1){
    fun1;
  }
  cout << length << endl;
  cout << height << endl;
}