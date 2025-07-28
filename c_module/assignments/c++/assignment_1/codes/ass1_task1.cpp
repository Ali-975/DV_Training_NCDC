#include <iostream>
#include <string>
using namespace std;

class com_emp { // Commision Employee ki paghar
private:
    string f_name;
    string l_name;
    string security_no;
    double gross_sales;
    double com_rate;

public:
    // Setters
    void set_first_name(string ft_name) { f_name = ft_name; }
    void set_last_name(string lt_name) { l_name = lt_name; }
    void set_social_sec_num(string sec_no) { security_no = sec_no; }
    void set_gross_sale(double gr_sale) { gross_sales = (gr_sale < 0) ? 0 : gr_sale; }
    void set_commission_rate(double comm_rate) { com_rate = (comm_rate > 0 && comm_rate < 1) ? comm_rate : 0; }

    // Getters
    string get_first_name() const { return f_name; }
    string get_last_name() const { return l_name; }
    string get_social_sec_num() const { return security_no; }
    double get_gross_sale() const { return gross_sales; }
    double get_commission_rate() const { return com_rate; }

    // Earnings function
    virtual double earnings() const {
        return gross_sales * com_rate;
    }
};

class bs_com_emp : public com_emp { // Base plus Commision Employee ki paghar
private:
    double bs_salary;

public:
    void set_base_sal(double bs_sal) { bs_salary = (bs_sal < 0) ? 0 : bs_sal; }
    double get_base_sal() const { return bs_salary; }

    double earnings() const override { // Now earning override function
        return get_base_sal() + com_emp::earnings();
    }
};

int main() {
    com_emp c; // Commission Employee's object
    bs_com_emp b; // Base Plus Commission Employee's object

    c.set_first_name("Muddassir");
    c.set_last_name("Ali");
    c.set_social_sec_num("42401-3768894-9");
    c.set_gross_sale(500000);
    c.set_commission_rate(0.10);

    cout << "\nCommission Employee Earnings: " << c.earnings() << endl;

    b.set_first_name("Ali");
    b.set_last_name("Siddiqui");
    b.set_social_sec_num("42000-8420981-3");
    b.set_gross_sale(100000);
    b.set_commission_rate(0.08);
    b.set_base_sal(100000);

    cout << "\nBase Plus Commission Employee Earnings: " << b.earnings() << endl << endl;

    return 0;
}
