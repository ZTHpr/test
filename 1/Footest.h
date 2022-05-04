#pragma once

#include <iostream>
using namespace std;


class FooTest final{
public:
    FooTest(int value = 42): m_value(value){
        cout<<"in normal constracter"<<endl;
    }
    FooTest(const FooTest &t): m_value(t.m_value){
        cout<<"in copy constracter"<<endl;
    }
    ~FooTest(){
        cout<<"in ~FooTest"<<endl;
    }

private:
    int m_value;

};