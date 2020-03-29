using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Phyo.Lab.NotificationListener
{
  class MessageCommand
  {
    public void EndConversation(IDbTransaction transaction, Message message)
    {
      var connection = transaction.Connection;
      var sql = @"end conversation @id";

      connection.Execute(sql, message, transaction);
    }
  }
}
