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
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            InitializeMyControl();
        }

        private void InitializeMyControl()
        {
            // Set to no text.
            textBox2.Text = "";
            // The password character is an asterisk.
            textBox2.PasswordChar = '*';
            // The control will allow no more than 14 characters.
            textBox2.MaxLength = 14;
        }

        private void label3_Click(object sender, EventArgs e)
        {
            this.Hide();
            Form2 register = new Form2();
            register.Show();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            String LoginUser = textBox1.Text;
            String PasswordUser = textBox2.Text;
            string activeRole = "";


            string sqlExpression = "sp_GetUser";

            string connectionString = @"Data Source=WIN-I00JS7JRQF8\RDCB; Initial Catalog=AirCompany;Integrated Security=True";

            SqlDataAdapter adapter = new SqlDataAdapter();
            DataTable table = new DataTable();

            if (textBox1.Text == "" && textBox2.Text == "")
            {
                MessageBox.Show("Заполните все поля");
            }

            else
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    SqlCommand command = new SqlCommand(sqlExpression, connection);
                    command.CommandType = System.Data.CommandType.StoredProcedure;

                    //SqlParameter role = new SqlParameter
                    //{
                    //    ParameterName = "@role",
                    //    SqlDbType = SqlDbType.Int
                    //};

                    

                    command.Parameters.AddWithValue("@login", LoginUser);
                    command.Parameters.AddWithValue("@password", PasswordUser);
                    SqlParameter role = new SqlParameter
                    {
                        ParameterName = "@role",
                        SqlDbType = SqlDbType.Int
                    };
                    role.Direction = ParameterDirection.Output;
                    command.Parameters.Add(role);

                    command.ExecuteNonQuery();

                    activeRole = command.Parameters["@role"].Value.ToString();



                    adapter.SelectCommand = command;
                    adapter.Fill(table);
                    if (table.Rows.Count == 1)
                    {
                        if( activeRole == "0")
                        {
                            MessageBox.Show("Вы успешно вошли");
                            Form3 user = new Form3();
                            this.Hide();
                            user.ShowDialog();
                            this.Show();
                        }
                        else
                        {
                            MessageBox.Show("Вы успешно вошли как администратор");
                            Form4 admin = new Form4();
                            this.Hide();
                            admin.ShowDialog();
                            this.Show();
                        }

                    }
                    else MessageBox.Show("Не введён логин или пароль");
                    connection.Close();
                }
            }
        }

        private void textBox1_Click(object sender, EventArgs e)
        {
            panel1.BackColor = Color.FromArgb(255, 255, 255);
            textBox1.ForeColor = Color.FromArgb(255, 255, 255);
        }

        private void textBox2_Click(object sender, EventArgs e)
        {
            panel1.BackColor = Color.FromArgb(255, 255, 255);
            textBox1.ForeColor = Color.FromArgb(255, 255, 255);
        }
    }
}
