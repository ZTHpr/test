#pragma once
#include <iostream>
#include <string>

class Singleton{
public:
    static Singleton &GetInstance(){
        static Singleton s_instance("Sun");
        return s_instance;
    }
private:
    Singleton(const std::string& s): m_name(s){};
    ~Singleton(){};
    Singleton() = delete;
    Singleton(const Singleton&) = delete;
    Singleton
    std::string m_name;


};