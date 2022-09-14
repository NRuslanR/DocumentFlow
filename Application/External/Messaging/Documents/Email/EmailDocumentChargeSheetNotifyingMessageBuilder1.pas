unit EmailDocumentChargeSheetNotifyingMessageBuilder1;

interface

uses

  Document,
  DocumentFileUnit,
  Employee,
  DocumentChargeSheet,
  MessagingServiceUnit,
  AbstractDocumentChargeSheetNotifyingMessageBuilder,
  SysUtils,
  Classes;

type

  TEmailDocumentChargeSheetNotifyingMessageBuilder1 =
    class (TAbstractDocumentChargeSheetNotifyingMessageBuilder)

      protected

        function HasReceiverEmployeeMessageAcceptingContactInfo(
          const ReceiverEmployee: TEmployee
        ): Boolean; override;

      protected

        procedure AssignDocumentChargeSheetMessageSenderEmployee(
          SenderEmployee: TEmployee;
          Message: IMessage
        ); override;

        procedure AssignDocumentChargeSheetMessageReceiverEmployee(
          ReceiverEmployee: TEmployee;
          Message: IMessage
        ); override;
      
    end;

implementation

{ TEmailDocumentChargeSheetNotifyingMessageBuilder1 }

procedure TEmailDocumentChargeSheetNotifyingMessageBuilder1.
  AssignDocumentChargeSheetMessageReceiverEmployee(
    ReceiverEmployee: TEmployee;
    Message: IMessage
  );
var MessageReceiver: IMessageMember;
begin

  if not HasReceiverEmployeeMessageAcceptingContactInfo(ReceiverEmployee)
  then Exit;
  
  MessageReceiver := Message.Receivers.Add;

  MessageReceiver.Identifier := ReceiverEmployee.ContactInfo.Email;
  MessageReceiver.DisplayName := ReceiverEmployee.FullName;
  
end;

procedure TEmailDocumentChargeSheetNotifyingMessageBuilder1.
  AssignDocumentChargeSheetMessageSenderEmployee(
    SenderEmployee: TEmployee;
    Message: IMessage
  );
begin

  Message.Sender.Identifier := SenderEmployee.ContactInfo.Email;
  Message.Sender.DisplayName := SenderEmployee.FullName;

end;

function TEmailDocumentChargeSheetNotifyingMessageBuilder1.
  HasReceiverEmployeeMessageAcceptingContactInfo(
    const ReceiverEmployee: TEmployee
  ): Boolean;
begin

  Result := Trim(ReceiverEmployee.ContactInfo.Email) <> '';
  
end;

end.
