using Dapper;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Phyo.Lab.NotificationListener
{
  class MessageQuery
  {
    private string queueSchema;
    private string queueName;
    private int? timeoutMilliseconds;
    private const int defaultTimeoutMilliseconds = 5000;

    private string QueueSchema
    {
      get => queueSchema ?? (queueSchema = ConfigurationManager.AppSettings["MessageQueueSchema"]);
      set => queueSchema = value;
    }

    private string QueueName
    {
      get => queueName ?? (queueName = ConfigurationManager.AppSettings["MessageQueueName"]);
      set => queueName = value;
    }

    private int Timeout
    {
      get
      {
        if (timeoutMilliseconds.HasValue)
          return timeoutMilliseconds.Value;
        else
        {
          var value = ConfigurationManager.AppSettings["TimeoutMilliseconds"];
          if (int.TryParse(value, out int timeout))
          {
            timeoutMilliseconds = timeout;
            return timeoutMilliseconds.Value;
          }
          else
          {
            return defaultTimeoutMilliseconds;
          }
        }
      }
    }

    public Message FindOne(IDbTransaction transaction)
    {
      var connection = transaction.Connection;

      var sql = string.Format(@"
waitfor ( 
  receive top(1)
    conversation_handle as id,
    message_type_name as messagetype,
    message_body as messagebody
  from
    {0}.{1}
), timeout {2}",
        BracketizeName(QueueSchema),
        BracketizeName(QueueName),
        Timeout);

      var message = connection
        .Query<Message>(sql, transaction: transaction)
        .FirstOrDefault();

      return message;
    }


    /// <summary>
    /// Wraps the given Sql Server sysname in brackets and escapes any closing brackets already present in the name.
    /// </summary>
    private static string BracketizeName(string sysname)
    {
      return string.Format("[{0}]", sysname.Replace("]", "]]"));
    }
  }
}
