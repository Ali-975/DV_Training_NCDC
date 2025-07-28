#include<iostream>
#include<string>
#include<vector>

using namespace std;

class student{
    private:
        string name;
        vector<int>marks;
    public:
        student(){
            cout << "Enter the student's name: ";
            cin >> name;
        }
        void add_mark(int m){
            marks.push_back(m);
        }
        void display(){
            cout << "Name: " << name << endl;
            for(int i = 0; i < marks.size(); i++){
                cout << "marks for subject " << i + 1 << ": " << marks[i] << endl;
            }
        }
        string getname() const{
            return name;
        }

        friend float calculate_average(const student&);
};

float calculate_average(const student& stud){
    float avg = 0;
    for(int i = 0; i < stud.marks.size(); i++){
        avg += stud.marks[i];
    }
    avg /= stud.marks.size();
    return avg;
}

int main(){
    int sub;
    vector<student>students;
    students.push_back(student());
    students.push_back(student());
    students.push_back(student());

    cout << "How many subject's marks would you like to enter: ";
    cin >> sub;

    for(int i = 0; i < students.size(); i++){
        float avg;
        cout << "Enter the marks for: " << students[i].getname() << endl;
        for (int j = 0; j < sub; j++){
            int marks;
            cout << "Enter subject " << j + 1 << " marks: ";
            cin>>marks;
            students[i].add_mark(marks);
        }
        cout << endl;
    }
    auto filterStudent = [](const student& stud){return calculate_average(stud) > 75;};    

    void (*funcptr)(const student&) = [](const student& stud){
        cout << "Name: " << stud.getname() << endl;
        cout << "Average: " << calculate_average(stud) << endl;
    };

    cout << "Selected students (via function pointer): " << endl;
    for(int i = 0; i < students.size(); i++){
        if(filterStudent(students[i])){
            funcptr(students[i]);
            cout << endl;
        }
    }
    
    return 0;
}
