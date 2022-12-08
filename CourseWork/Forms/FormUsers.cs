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

namespace CourseWork.AdminForms
{
    public partial class FormUsers : Form
    {
        public FormUsers()
        {
            InitializeComponent();
            LoadData();
        }

        int selectedRow;
        private void LoadData()       //Заполнение данными датагридвью
        {

            string sqlExpression = "sp_SelectUsersInAdmin";

            string connectionString = @"Data Source=WIN-I00JS7JRQF8\RDCB; Initial Catalog=AirCompany;Integrated Security=True";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                SqlCommand command = new SqlCommand(sqlExpression, connection);
                command.CommandType = System.Data.CommandType.StoredProcedure;

                SqlDataReader reader = command.ExecuteReader();

                List<string[]> data = new List<string[]>();
                while (reader.Read())
                {
                    data.Add(new string[7]);

                    data[data.Count - 1][0] = reader[0].ToString();
                    data[data.Count - 1][1] = reader[1].ToString();
                    data[data.Count - 1][2] = reader[2].ToString();
                    data[data.Count - 1][3] = reader[3].ToString();
                    data[data.Count - 1][4] = reader[4].ToString();
                    data[data.Count - 1][5] = reader[5].ToString();
                    data[data.Count - 1][6] = reader[6].ToString();
                }

                reader.Close();

                connection.Close();

                foreach (string[] s in data)
                    dataGridView1.Rows.Add(s);
            }
        }

        private void dataGridView1_CellClick(object sender, DataGridViewCellEventArgs e)   //Для переноса данных в текстбокс
        {
            selectedRow = e.RowIndex;
            if(selectedRow >= 0)
            {
                DataGridViewRow row = dataGridView1.Rows[selectedRow];

                textBox7.Text = row.Cells[0].Value.ToString();
                textBox1.Text = row.Cells[1].Value.ToString();
                textBox2.Text = row.Cells[2].Value.ToString();
                textBox3.Text = row.Cells[3].Value.ToString();
                textBox4.Text = row.Cells[4].Value.ToString();
                textBox5.Text = row.Cells[5].Value.ToString();
                textBox6.Text = row.Cells[6].Value.ToString();
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            string LoginUser = textBox1.Text;
            string PasswordUser = textBox2.Text;
            string Fname = textBox3.Text;
            string Lname = textBox4.Text;
            string mails = textBox5.Text;
            string role = textBox6.Text;
            string id_user = textBox7.Text;


            string sqlExpression = "sp_UpdateInfoInAdminPanel";
            string connectionString = @"Data Source=WIN-I00JS7JRQF8\RDCB; Initial Catalog=AirCompany;Integrated Security=True";

            using(SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                SqlCommand command = new SqlCommand(sqlExpression, connection);
                command.CommandType = System.Data.CommandType.StoredProcedure;

                Convert.ToInt32(id_user);
                Convert.ToInt32(role);

                command.Parameters.Add(new SqlParameter("@login", LoginUser));
                command.Parameters.Add(new SqlParameter("@password", PasswordUser));

                command.Parameters.Add(new SqlParameter("@fname", Fname));
                command.Parameters.Add(new SqlParameter("@Lname", Lname));

                command.Parameters.Add(new SqlParameter("@mail", mails));
                command.Parameters.Add(new SqlParameter("@role", role));
                command.Parameters.Add(new SqlParameter("@id_users", id_user));

                command.ExecuteNonQuery();

                MessageBox.Show("Данные успешно обновлены!");
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            string id_user = textBox7.Text;

            string sqlExpression = "sp_DeleteUsers";
            string connectionString = @"Data Source=WIN-I00JS7JRQF8\RDCB; Initial Catalog=AirCompany;Integrated Security=True";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                SqlCommand command = new SqlCommand(sqlExpression, connection);
                command.CommandType = System.Data.CommandType.StoredProcedure;

                Convert.ToInt32(id_user);

                command.Parameters.Add(new SqlParameter("@id_user", id_user));

                command.ExecuteNonQuery();

                MessageBox.Show("Вы успешно удалили пользователя!");
            }
        }
    }
}
