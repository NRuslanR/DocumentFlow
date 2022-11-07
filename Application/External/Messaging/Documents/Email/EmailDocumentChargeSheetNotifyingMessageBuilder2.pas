unit EmailDocumentChargeSheetNotifyingMessageBuilder2;

interface

uses

  EmailDocumentChargeSheetNotifyingMessageBuilder1,
  Document,
  DocumentFileUnit,
  IDocumentChargeSheetUnit,
  Employee,
  Department,
  DocumentChargeSheet,
  MessagingServiceUnit,
  SysUtils,
  Classes;

type

  TEmailDocumentChargeSheetNotifyingMessageBuilder2 =
    class (TEmailDocumentChargeSheetNotifyingMessageBuilder1)

      protected

        FDocumentChargeSheetSenderEmployee: TEmployee;

        function BuildNotyfingMessageForDocumentChargeSheet(
          DocumentChargeSheet: IDocumentChargeSheet;
          RelatedDocument: TDocument;
          RelatedDocumentFiles: TDocumentFiles;
          RelatedDocumentResponsible: TEmployee;
          RelatedDocumentResponsibleDepartment: TDepartment;
          SenderEmployee: TEmployee;
          ReceiverEmployees: TEmployees
        ): IMessage; override;
        
        procedure PutDocumentInfoInMessage(
          Document: TDocument;
          DocumentFiles: TDocumentFiles;
          DocumentResponsible: TEmployee;
          DocumentResponsibleDepartment: TDepartment;
          Message: IMessage
        ); override;

      protected

        procedure PutDocumentChargeSheetSenderEmployeeInfoInMessageContent(
          DocumentChargeSheetSenderEmployee: TEmployee;
          MessageContent: TStrings
        );

    end;

implementation

uses

  Variants;
  
{ TEmailDocumentChargeSheetNotifyingMessageBuilder2 }

procedure TEmailDocumentChargeSheetNotifyingMessageBuilder2.
  PutDocumentInfoInMessage(
    Document: TDocument;
    DocumentFiles: TDocumentFiles;
    DocumentResponsible:
    TEmployee; DocumentResponsibleDepartment: TDepartment;
    Message: IMessage
  );
begin

  inherited;

  if Assigned(FDocumentChargeSheetSenderEmployee) then begin

    PutDocumentChargeSheetSenderEmployeeInfoInMessageContent(
      FDocumentChargeSheetSenderEmployee, Message.Content
    );

    FDocumentChargeSheetSenderEmployee := nil;

  end;

end;

function TEmailDocumentChargeSheetNotifyingMessageBuilder2.
  BuildNotyfingMessageForDocumentChargeSheet(
    DocumentChargeSheet: IDocumentChargeSheet;
    RelatedDocument: TDocument;
    RelatedDocumentFiles: TDocumentFiles;
    RelatedDocumentResponsible: TEmployee;
    RelatedDocumentResponsibleDepartment: TDepartment;
    SenderEmployee: TEmployee;
    ReceiverEmployees: TEmployees
  ): IMessage;
begin

  FDocumentChargeSheetSenderEmployee := SenderEmployee;
  
  Result :=
    inherited BuildNotyfingMessageForDocumentChargeSheet(
      DocumentChargeSheet,
      RelatedDocument,
      RelatedDocumentFiles,
      RelatedDocumentResponsible,
      RelatedDocumentResponsibleDepartment,
      SenderEmployee,
      ReceiverEmployees
    );
    
end;

procedure TEmailDocumentChargeSheetNotifyingMessageBuilder2.
  PutDocumentChargeSheetSenderEmployeeInfoInMessageContent(
    DocumentChargeSheetSenderEmployee: TEmployee;
    MessageContent: TStrings
  );
begin
                {
  MessageContent.Insert(
    0,
    '<b>Информация об отправителе поручения:</b>' +
    FMessageSpecChars.NewLine
  );

  MessageContent.Insert(
    1,
    FMessageSpecChars.Tabulation +
    'Имя: ' + DocumentChargeSheetSenderEmployee.FullName +
    FMessageSpecChars.NewLine
  );

  MessageContent.Insert(
    2,
    FMessageSpecChars.Tabulation +
    'E-mail: ' + DocumentChargeSheetSenderEmployee.ContactInfo.Email +
    FMessageSpecChars.NewLine +
    FMessageSpecChars.NewLine
  );                    }
  
end;

end.
