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

namespace CourseWork.UserForms
{
    public partial class ProfileForms : Form
    {
        public ProfileForms()
        {
            InitializeComponent();
            LoadData();
        }

        private void LoadData()
        {
            string activeId = "";

            string sqlExpression = "";

            string connectionString = @"Data Source=WIN-I00JS7JRQF8\RDCB; Initial Catalog=AirCompany;Integrated Security=True";
            using(SqlConnection connection  = new SqlConnection(connectionString))
            {
                connection.Open();
                SqlCommand command = new SqlCommand(sqlExpression, connection);
                command.CommandType = System.Data.CommandType.StoredProcedure;


                //SqlParameter id_user = new SqlParameter
                //{
                //    ParameterName = "@id_users",
                //    SqlDbType = SqlDbType.Int
                //};

                //id_user.Direction = ParameterDirection.Output;
                //command.Parameters.Add(id_user);

                //command.ExecuteNonQuery();

                //activeId = command.Parameters["@id_users"].Value.ToString();

                SqlDataReader reader = command.ExecuteReader();

                List<string[]> data = new List<string[]>();
                while (reader.Read())
                {
                    data.Add(new string[5]);

                    data[data.Count - 1][0] = reader[0].ToString();
                    data[data.Count - 1][1] = reader[1].ToString();
                    data[data.Count - 1][2] = reader[2].ToString();
                    data[data.Count - 1][3] = reader[3].ToString();
                    data[data.Count - 1][4] = reader[4].ToString();
                }

                reader.Close();

                connection.Close();

                foreach (string[] s in data)
                    dataGridView1.Rows.Add(s);
            }
        }
    }
}
