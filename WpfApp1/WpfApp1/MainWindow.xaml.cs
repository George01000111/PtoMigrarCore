using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Data.OleDb;
using System.Data.SqlClient;
using WpfApp1.Data;
using WpfApp1.Models;

namespace WpfApp1
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    /// 


    public partial class MainWindow : Window
    {
        DataSet ds = new DataSet();
        string connection = System.Configuration.ConfigurationManager.ConnectionStrings["conexion"].ConnectionString;

        public MainWindow()
        {
            InitializeComponent();
        }

        private void btnImportar_Click(object sender, RoutedEventArgs e)
        {
            OpenFileDialog of = new OpenFileDialog();
            of.Filter = "Excel Files |*.xls;*xlsx;*xlsm";
            of.Title = "Importar Datos";

            if (of.ShowDialog()==true)
            {
                //llamamos metodo ImportarArchivoExcel
                txtRuta.Text = of.FileName;
                dgvDatos.ItemsSource = ImportarArchivoExcel(of.FileName);

            }

        }

        DataView ImportarArchivoExcel(string ruta)
        {
            string conexion = string.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties = 'Excel 12.0 Macro;HDR=YES'; ", ruta);

            OleDbConnection origen = default(OleDbConnection);
            origen = new OleDbConnection(conexion);

            OleDbCommand seleccion = default(OleDbCommand);
            seleccion = new OleDbCommand("Select * From [Hoja1$]", origen);

            OleDbDataAdapter adaptador = new OleDbDataAdapter();
            adaptador.SelectCommand = seleccion;

             ds = new DataSet();

            adaptador.Fill(ds);

            origen.Close();

            return ds.Tables[0].DefaultView; 
        }

        private void btnMigrar_Click(object sender, RoutedEventArgs e)
        {

           SqlConnection conexion_destino = new SqlConnection();
            conexion_destino.ConnectionString = connection;

            SqlCommand command = new SqlCommand("Delete from dbo.Migrar", conexion_destino);
            command.Connection.Open();
            command.CommandTimeout = 7200;
            command.ExecuteNonQuery();
            command.Connection.Close();


            conexion_destino.Open();
            SqlBulkCopy importar = default(SqlBulkCopy);
            importar = new SqlBulkCopy(conexion_destino);
            importar.DestinationTableName = "Migrar";
            importar.WriteToServer(ds.Tables[0]);
            conexion_destino.Close();


            SqlCommand cmd = new SqlCommand("SP_INSERT_TMP_MOVIDET  ", conexion_destino);
            cmd.CommandType = CommandType.StoredProcedure;
            conexion_destino.Open();
            cmd.CommandTimeout = 7200;
            cmd.ExecuteNonQuery();
            conexion_destino.Close();


            //MigrarRepository migrarRepository = new MigrarRepository();
            List<RespSpNroFactura> lst = new List<RespSpNroFactura>();

            lst = SpRespSpNroFactura();

 
            foreach (var dto in lst)
            {


            string nromovi;
            using (micontext db = new micontext())
            {
                nromovi= db.Tipomovi.Where(x=> (x.Cdtipomov.Contains("03"))).FirstOrDefault().Correlativo.ToString();
            }



                cmd = new SqlCommand("CUR_TMP_MOVIDET_2", conexion_destino);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@VALNROFACTURA", dto.NroFactura.ToString()));
                cmd.Parameters.Add(new SqlParameter("@NROMOVI", nromovi.ToString()));
                conexion_destino.Open();
                cmd.CommandTimeout = 7200;
                cmd.ExecuteNonQuery();
                conexion_destino.Close();





                cmd = new SqlCommand("CUR_INSERT_MOVIDET", conexion_destino);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@VALNROFACTURA", dto.NroFactura.ToString()));
                cmd.Parameters.Add(new SqlParameter("@NROMOVI", nromovi.ToString()));
                conexion_destino.Open();
                cmd.CommandTimeout = 7200;
                cmd.ExecuteNonQuery();
                conexion_destino.Close();


                cmd = new SqlCommand("SP_INSERT_MOVICAB", conexion_destino);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@VALNROFACTURA", dto.NroFactura.ToString()));
                cmd.Parameters.Add(new SqlParameter("@NROMOVI", nromovi.ToString()));
                conexion_destino.Open();
                cmd.CommandTimeout = 7200;
                cmd.ExecuteNonQuery();
                conexion_destino.Close();

            }



            //cmd = new SqlCommand("CUR_GENERAL  ", conexion_destino);
            //cmd.CommandType = CommandType.StoredProcedure;
            //conexion_destino.Open();
            //cmd.CommandTimeout = 7200;
            //cmd.ExecuteNonQuery();
            //conexion_destino.Close();





            MessageBox.Show("La Migracion fue con Exito");


        }

        public List<RespSpNroFactura> SpRespSpNroFactura()
        {
            using (SqlConnection sql = new SqlConnection(connection))
            {
                using (SqlCommand cmd = new SqlCommand("SpNroFactura", sql))
                {
                    cmd.CommandTimeout = 5000;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    var response = new List<RespSpNroFactura>();
                    sql.Open();

                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            response.Add(MapToRespSpNroFactura(reader));
                        }
                    }

                    return response;
                }
            }
        }


        private RespSpNroFactura MapToRespSpNroFactura(SqlDataReader reader)
        {
            return new RespSpNroFactura()
            {
                NroFactura = reader["nrofactura"].ToString(),
            };
        }


    }
}
