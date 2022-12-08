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

namespace CourseWork.Forms
{
    public partial class FormAirports : Form
    {
        int selectedRow;

        public FormAirports()
        {
            InitializeComponent();
            LoadData();
        }

        private void LoadData()       //Заполнение данными датагридвью
        {

            string sqlExpression = "sp_ShowAllAirports";

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
                    data.Add(new string[3]);

                    data[data.Count - 1][0] = reader[0].ToString();
                    data[data.Count - 1][1] = reader[1].ToString();
                    data[data.Count - 1][2] = reader[2].ToString();
                }

                reader.Close();

                connection.Close();

                foreach (string[] s in data)
                    dataGridView1.Rows.Add(s);
            }
        }

        private void dataGridView1_CellClick_1(object sender, DataGridViewCellEventArgs e) //Для переноса данных в текстбокс
        {
            selectedRow = e.RowIndex;
            if (selectedRow >= 0)
            {
                DataGridViewRow row = dataGridView1.Rows[selectedRow];
                textBox1.Text = row.Cells[0].Value.ToString();
                textBox2.Text = row.Cells[1].Value.ToString();
                textBox3.Text = row.Cells[2].Value.ToString();
                //textBox4.Text = row.Cells[3].Value.ToString();

            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            string AirportCode = textBox1.Text;
            string Name = textBox2.Text;
            string City = textBox3.Text;


            string SqlExpression = "sp_AddAirports";

            string connectionString = @"Data Source=WIN-I00JS7JRQF8\RDCB; Initial Catalog=AirCompany;Integrated Security=True";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                SqlCommand command = new SqlCommand(SqlExpression, connection);
                command.CommandType = System.Data.CommandType.StoredProcedure;

                command.Parameters.Add(new SqlParameter("@AirportCode", AirportCode));
                command.Parameters.Add(new SqlParameter("@Name", Name));
                command.Parameters.Add(new SqlParameter("@City", City));

                command.ExecuteNonQuery();

                MessageBox.Show("Вы успешно добавили аэропорт!");
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            string AirportCode = textBox1.Text;
            string Name = textBox2.Text;
            string City = textBox3.Text;

            string SqlExpression = "sp_UpdateAirports";

            string connectionString = @"Data Source=WIN-I00JS7JRQF8\RDCB; Initial Catalog=AirCompany;Integrated Security=True";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                SqlCommand command = new SqlCommand(SqlExpression, connection);
                command.CommandType = System.Data.CommandType.StoredProcedure;

                command.Parameters.Add(new SqlParameter("@AirportCode", AirportCode));
                command.Parameters.Add(new SqlParameter("@Name", Name));
                command.Parameters.Add(new SqlParameter("@City", City));

                command.ExecuteNonQuery();

                MessageBox.Show("Данные успешно обновлены!");
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            string AirportCode = textBox1.Text;

            string SqlExpression = "sp_DeleteAirports";

            string connectionString = @"Data Source=WIN-I00JS7JRQF8\RDCB; Initial Catalog=AirCompany;Integrated Security=True";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                SqlCommand command = new SqlCommand(SqlExpression, connection);
                command.CommandType = System.Data.CommandType.StoredProcedure;

                command.Parameters.Add(new SqlParameter("@AirportCode", AirportCode));

                command.ExecuteNonQuery();

                MessageBox.Show("Данные успешно удалены!");
            }
        }
    }
}
