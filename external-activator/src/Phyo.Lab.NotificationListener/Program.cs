using log4net;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Phyo.Lab.NotificationListener
{
  class Program
  {
    private static readonly ILog log = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

    static void Main(string[] args)
    {
      try
      {
        var query = new MessageQuery();
        var command = new MessageCommand();

        var connectionString = ConfigurationManager.ConnectionStrings["mydb"].ConnectionString;
        using (var conn = new SqlConnection(connectionString))
        {
          conn.Open();

          var hasMessage = false;

          do
          {
            hasMessage = false;

            using (var txn = conn.BeginTransaction())
            {
              var message = query.FindOne(txn);

              if (message == null)
              {
                txn.Commit();
                continue;
              }

              hasMessage = true;

              try
              {
                log.Info($"{message.MessageType} - {message.MessageBodyValue}");
                command.EndConversation(txn, message);
                txn.Commit();
              }
              catch
              {
                command.EndConversation(txn, message);
                txn.Commit();
                throw;
              }
            }

          } while (hasMessage);
        }
      }
      catch (Exception e)
      {
        log.Error(e.Message, e);
      }
    }
  }
}