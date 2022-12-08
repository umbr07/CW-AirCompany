using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CourseWork
{
    public partial class Form2 : Form
    {
        public Form2()
        {
            InitializeComponent();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            this.Hide();
            Form1 login = new Form1();
            login.Show();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            String LoginUser = textBox1.Text;
            String PasswordUser = textBox2.Text;
            String Fname = textBox3.Text;
            String Lname = textBox4.Text;
            String mails = textBox5.Text;

            // string sqlExpression = "sp_InsertUsers";
            // DB db = new DB();

            string sqlExpression = "sp_InsertUsers";

            string connectionString = @"Data Source=WIN-I00JS7JRQF8\RDCB; Initial Catalog=AirCompany;Integrated Security=True";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                SqlCommand command = new SqlCommand(sqlExpression, connection);
                command.CommandType = System.Data.CommandType.StoredProcedure;

                command.Parameters.Add(new SqlParameter("@login", LoginUser));
                command.Parameters.Add(new SqlParameter("@password", PasswordUser));

                command.Parameters.Add(new SqlParameter("@fname", Fname));
                command.Parameters.Add(new SqlParameter("@Lname", Lname));

                command.Parameters.Add(new SqlParameter("@mail", mails));

                command.ExecuteNonQuery();

                MessageBox.Show("Вы успешно зарегистрировались!");

            }
        }
    }
}
