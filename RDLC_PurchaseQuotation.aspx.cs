using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RDLC_Tutorial
{
    public partial class RDLC_ReportTutorial : System.Web.UI.Page
    {
        static bool _isSqlTypesLoaded = false;

        public RDLC_ReportTutorial()
        {
            if (!_isSqlTypesLoaded)
            {
                SqlServerTypes.Utilities.LoadNativeAssemblies(Server.MapPath("~"));
                _isSqlTypesLoaded = true;
            }

        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Load_Report_Click(object sender, EventArgs e)
        {
            GetData();
        }

        private void GetData()
        {
            using (SqlConnection sqlcon = new SqlConnection(ConfigurationManager.ConnectionStrings["myConnection"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("spPurchaseQuotAnalysis", sqlcon))

                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@requisitionNo", SqlDbType.Text).Value = TextBox1.Text;

                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {

                        DataTable dt = new DataTable("DataTable1");

                        sda.Fill(dt);

                        ReportViewer1.ProcessingMode = ProcessingMode.Local;
                        ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/Reports/rptPurchaseQuotationTest.rdlc");
                        ReportViewer1.LocalReport.DataSources.Clear();
                        ReportViewer1.LocalReport.DataSources.Add(new ReportDataSource("dtsPurchaseQuot", dt));
                        ReportViewer1.LocalReport.Refresh();
                        
                    }
                }
            }
        }
    }
}