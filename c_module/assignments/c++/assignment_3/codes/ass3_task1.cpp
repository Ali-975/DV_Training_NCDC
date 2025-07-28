#include<iostream>
#include<string>

using namespace std;

class rect{
    private:
        float* height = new float;
        float* width = new float;

    public:
        rect(float h, float w){
            cout << "Memory allocated for height and width" << endl;
            *height = h;
            *width = w;
        }
        
        ~rect(){
            delete height;
            delete width;
            cout<<"The memory for height and width has been released"<<endl;
        }
        
        float area(){
            return (*height)*(*width);
        }

        float perimeter(){
            return (*height) + (*width);
        }

        void display(){
            cout<<"Height: "<<*height<<endl;
            cout<<"Widht: "<<*width<<endl;
            cout<<"Area: "<<area()<<endl;
            cout<<"Perimeter: "<<perimeter()<<endl<<endl;
        }
};

int main(){
    float height, width;
    cout<<"Enter the height and width for the 1st Rectangle"<<endl;
    cin>>height;
    cin>>width;
    rect r1(height, width);

    cout<<"Enter the height and width for the 2nd Rectangle"<<endl;
    cin>>height;
    cin>>width;
    rect r2(height, width);
    
    r1.display();
    r2.display();
}
