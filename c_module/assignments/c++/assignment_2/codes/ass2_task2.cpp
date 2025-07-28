#include <iostream>
#include <string>
using namespace std;

class bank_acc {
    string acc_holder;
    double balance;

public:
    bank_acc(string name, double bal) {
        acc_holder = name;
        balance = bal;
    }

    bank_acc* deposit(double amount) {
        if (amount > 0) {
            balance += amount;
            cout << "Deposited $" << amount << endl;
        } else {
            cout << "Invalid deposit amount.\n";
        }
        return this;
    }

    bank_acc* withdraw(double amount) {
        if (amount > 0 && balance >= amount) {
            balance -= amount;
            cout << "Withdrew $" << amount << endl;
        } else {
            cout << "Insufficient balance or invalid amount.\n";
        }
        return this;
    }

    bank_acc* display() {
        cout << "\nAccount Holder: " << acc_holder << "\nCurrent Balance: $" << balance << endl;
        return this;
    }
};

int main() {
    string name;
    double initial_balance;

    cout << "Enter account holder name: ";
    getline(cin, name);

    cout << "Enter initial balance: ";
    cin >> initial_balance;

    bank_acc acc(name, initial_balance);

    // Demonstrating method chaining using `this` pointer
    acc.deposit(50000)->withdraw(10000)->display();

    return 0;
}
