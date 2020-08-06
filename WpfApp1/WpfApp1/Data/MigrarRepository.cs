using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Text;
using Microsoft.Extensions.Configuration;
using WpfApp1.Models;

namespace WpfApp1.Data
{
    public class MigrarRepository
    {

        private readonly string _connectionString;
  
        public MigrarRepository(IConfiguration configuration)
        {
            this._connectionString = configuration.GetConnectionString("conexion");
          
        }


        public  List<RespSpNroFactura> SpRespSpNroFactura()
        {
            using (SqlConnection sql = new SqlConnection(_connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("SpNroFactura", sql))
                {
                    cmd.CommandTimeout = 5000;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    var response = new List<RespSpNroFactura>();
                     sql.Open();

                    using (var reader =  cmd.ExecuteReader())
                    {
                        while ( reader.Read())
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
