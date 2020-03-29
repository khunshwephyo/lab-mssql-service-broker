using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Phyo.Lab.NotificationListener
{
  class Message
  {
    private const string errorType = @"http://schemas.microsoft.com/SQL/ServiceBroker/Error";
    private const string dialogType = @"http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog";

    public Guid Id { get; set; }

    public string MessageType { get; set; }

    public byte[] MessageBody { get; set; }

    public string MessageBodyValue
    {
      get
      {
        return MessageBody != null
          ? System.Text.Encoding.Unicode.GetString(MessageBody)
          : null;
      }
    }

    public bool IsError
    {
      get
      {
        return !string.IsNullOrEmpty(MessageType) &&
               MessageType.Equals(errorType, StringComparison.OrdinalIgnoreCase);
      }
    }

    public bool IsEndDialog
    {
      get
      {
        return !string.IsNullOrEmpty(MessageType) &&
               MessageType.Equals(dialogType, StringComparison.OrdinalIgnoreCase);
      }
    }
  }
}
