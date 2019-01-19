// g++ -o filebox-txt filebox-txt.cpp -mconsole -lnana -lgdi32 -lcomdlg32 -IC:/MinGW/include -DNANA_FILESYSTEM_FORCE -DMINGW_HAS_SECURE_API -D_FILE_OFFSET_BITS=64

#include <nana/gui/wvl.hpp>
#include <nana/gui/filebox.hpp>
#include <iostream> 


int main()
{
    using namespace nana;
    filebox fb(0, true);
    fb.add_filter( ("Text File"),  ("*.text;*.doc"));
    fb.add_filter( ("All Files"),  ("*.*"));
    if(fb())
    {
        std::string file = fb.file();
        std::cout << "Selected file:  " << file << std::endl; 
        std::cout << "Selected file:  " << fb.data() << std::endl; 
    }
    char a;
    std::cin >> a;
}