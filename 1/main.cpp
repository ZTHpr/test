#include <iostream>
#include <string>
#include <vector>
#include <new>
#include <variant>
#include <array>
#include <cstdio>
#include <cstdlib>
#include<tuple>
#include "Footest.h"
using  namespace std::string_literals;


struct type_t{
    type_t(int a): value(a){}
    int value;
};


int main(){
    std::aligned_storage_t<sizeof(FooTest),4096> new_f4[4];
    // std::cout<<"addr(new_f4[0])= " << &new_f4[0] << std::endl;
    // std::cout<<"addr(new_f4[1])= " << &new_f4[1] << std::endl;
    // std::cout<<"addr(new_f4[2])= " << &new_f4[2] << std::endl;
    // std::cout<<"addr(new_f4[3])= " << &new_f4[3] << std::endl;

    std::tuple c(3,3.24,"as"); 


}