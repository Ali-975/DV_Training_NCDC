#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
#include <numeric>
using namespace std;

class student {
    string name;
    int roll_no;
    vector<int> marks;
    double avg;

    void calculate_avg() {
        if (!marks.empty()) {
            avg = accumulate(marks.begin(), marks.end(), 0.0) / marks.size();
        } else {
            avg = 0;
        }
    }

public:
    student(string n, int r, vector<int> m) : name(n), roll_no(r), marks(m) {
        calculate_avg();
    }

    int get_roll_no() const {
        return roll_no;
    }

    double get_avg_marks() const {
        return avg;
    }

    void display() const {
        cout << "Name: " << name << "\nRoll Number: " << roll_no << "\nMarks: ";
        for (int mark : marks) {
            cout << mark << " ";
        }
        cout << "\nAverage Marks: " << avg << "\n-----------------------\n";
    }

    void update_marks(const vector<int>& new_marks) {
        marks = new_marks;
        calculate_avg();
    }
};

void add_student(vector<student>& students) {
    string name;
    int roll, n;
    vector<int> marks;

    cout << "Enter student name: ";
    cin.ignore();
    getline(cin, name);

    cout << "Enter roll number: ";
    cin >> roll;

    cout << "Enter number of subjects: ";
    cin >> n;

    cout << "Enter marks for " << n << " subjects:\n";
    for (int i = 0; i < n; ++i) {
        int mark;
        cin >> mark;
        marks.push_back(mark);
    }

    students.push_back(student(name, roll, marks));
    cout << "Student added successfully!\n";
}

void display(const vector<student>& students) {
    if (students.empty()) {
        cout << "No students available.\n";
        return;
    }
    for (auto it = students.begin(); it != students.end(); ++it) {
        it->display();
    }
}

void search(const vector<student>& students) {
    int roll;
    cout << "Enter roll number to search: ";
    cin >> roll;

    for (auto it = students.begin(); it != students.end(); ++it) {
        if (it->get_roll_no() == roll) {
            it->display();
            return;
        }
    }
    cout << "student not found.\n";
}

void update(vector<student>& students) {
    int roll, n;
    cout << "Enter roll number to update marks: ";
    cin >> roll;

    for (auto& student : students) {
        if (student.get_roll_no() == roll) {
            cout << "Enter new number of subjects: ";
            cin >> n;
            vector<int> new_marks;
            cout << "Enter new marks:\n";
            for (int i = 0; i < n; ++i) {
                int mark;
                cin >> mark;
                new_marks.push_back(mark);
            }
            student.update_marks(new_marks);
            cout << "Marks updated successfully!\n";
            return;
        }
    }
    cout << "student not found.\n";
}

void sort(vector<student>& students) {
    sort(students.begin(), students.end(), [](const student& a, const student& b) {
        return a.get_avg_marks() > b.get_avg_marks();
    });
    cout << "Students sorted by average marks in descending order.\n";
}

int main() {
    vector<student> students;
    int choice;

    do {
        cout << "\nStudent Record Management System\n";
        cout << "Press 1. Add student\n";
        cout << "Press 2. Display All students\n";
        cout << "Press 3. Search student by Roll Number\n";
        cout << "Press 4. Update Marks\n";
        cout << "Press 5. Sort students by Average Marks\n";
        cout << "Press 6. Exit\n";
        cout << "Enter your choice: ";
        cin >> choice;

        switch (choice) {
            case 1: add_student(students); break;
            case 2: display(students); break;
            case 3: search(students); break;
            case 4: update(students); break;
            case 5: sort(students); break;
            case 6: cout << "Exiting...\n"; break;
            default: cout << "Invalid choice!\n";
        }

    } while (choice != 6);

    return 0;
}
