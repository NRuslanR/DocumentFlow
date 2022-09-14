unit AbstractDocumentChargeSheetNotifyingMessageBuilder;

interface

uses

  DocumentChargeSheet,
  Document,
  DocumentFileUnit,
  Employee,
  MessagingServiceUnit,
  IDocumentChargeSheetUnit,
  MessagingServiceCommonObjects,
  MessageSpecChars,
  DocumentFullNameCompilationService,
  DocumentChargeSheetNotifyingMessageBuilder,
  DepartmentUnit,
  SysUtils,
  Classes;

type

  TAbstractDocumentChargeSheetNotifyingMessageBuilder =
    class (TInterfacedObject, IDocumentChargeSheetNotifyingMessageBuilder)

      protected

        FMessageSpecChars: IMessageSpecChars;
        FDocumentFullNameCompilationService: IDocumentFullNameCompilationService;
        FDocumentFileStoragePath: String;

      protected

        function AnyOfReceiverEmployeeHasMessageAcceptingContactInfo(
          const ReceiverEmployees: TEmployees
        ): Boolean;

        function HasReceiverEmployeeMessageAcceptingContactInfo(
          const ReceiverEmployee: TEmployee
        ): Boolean; virtual; abstract;

      protected

        function BuildNotyfingMessageForDocumentChargeSheet(
          DocumentChargeSheet: IDocumentChargeSheet;
          RelatedDocument: TDocument;
          RelatedDocumentFiles: TDocumentFiles;
          RelatedDocumentResponsible: TEmployee;
          RelatedDocumentResponsibleDepartment: TDepartment;
          SenderEmployee: TEmployee;
          ReceiverEmployees: TEmployees
        ): IMessage; virtual;

        function CreateMessageInstance: IMessage; virtual;

        procedure PutDocumentInfoInMessage(
          Document: TDocument;
          DocumentFiles: TDocumentFiles;
          DocumentResponsible: TEmployee;
          DocumentResponsibleDepartment: TDepartment;
          Message: IMessage
        ); virtual;

        procedure PutDocumentFilesAsAttachmentsInMessage(
          DocumentFiles: TDocumentFiles;
          Message: IMessage
        ); virtual;
        
        procedure PutDocumentChargeSheetInfoInMessage(
          DocumentChargeSheet: IDocumentChargeSheet;
          Message: IMessage
        ); virtual;

        procedure AssignDocumentChargeSheetMessageSenderEmployee(
          SenderEmployee: TEmployee;
          Message: IMessage
        ); virtual; abstract;

        procedure AssignDocumentChargeSheetMessageReceiverEmployee(
          ReceiverEmployee: TEmployee;
          Message: IMessage
        ); virtual; abstract;

      protected

        procedure AssignDocumentChargeSheetMessageReceiverEmployees(
          ReceiverEmployees: TEmployees;
          Message: IMessage
        );

      protected

        procedure CustomizeMessageForNewDocumentChargeSheet(
          Message: IMessage;
          NewDocumentChargeSheet: IDocumentChargeSheet;
          RelatedDocument: TDocument;
          RelatedDocumentFiles: TDocumentFiles;
          RelatedDocumentResponsible: TEmployee;
          RelatedDocumentResponsibleDepartment: TDepartment;
          SenderEmployee: TEmployee;
          ReceiverEmployees: TEmployees
        ); virtual;

        procedure CustomizeMessageForChangedDocumentChargeSheet(
          Message: IMessage;
          ChangedDocumentChargeSheet: IDocumentChargeSheet;
          RelatedDocument: TDocument;
          RelatedDocumentFiles: TDocumentFiles;
          RelatedDocumentResponsible: TEmployee;
          RelatedDocumentResponsibleDepartment: TDepartment;
          SenderEmployee: TEmployee;
          ReceiverEmployees: TEmployees
        ); virtual;

        procedure CustomizeMessageForRemovedDocumentChargeSheet(
          Message: IMessage;
          RemovedDocumentChargeSheet: IDocumentChargeSheet;
          RelatedDocument: TDocument;
          RelatedDocumentFiles: TDocumentFiles;
          RelatedDocumentResponsible: TEmployee;
          RelatedDocumentResponsibleDepartment: TDepartment;
          SenderEmployee: TEmployee;
          ReceiverEmployees: TEmployees
        ); virtual;
        
      public

        constructor Create(
          MessageSpecChars: IMessageSpecChars;
          DocumentFullNameCompilationService: IDocumentFullNameCompilationService;
          const DocumentFileStoragePath: String 
        );

        function BuildNotifyingMessageForNewDocumentChargeSheet(
          NewDocumentChargeSheet: IDocumentChargeSheet;
          RelatedDocument: TDocument;
          RelatedDocumentFiles: TDocumentFiles;
          RelatedDocumentResponsible: TEmployee;
          RelatedDocumentResponsibleDepartment: TDepartment;
          SenderEmployee: TEmployee;
          ReceiverEmployees: TEmployees
        ): IMessage; virtual;

        function BuildNotifyingMessageForChangedDocumentChargeSheet(
          ChangedDocumentChargeSheet: IDocumentChargeSheet;
          RelatedDocument: TDocument;
          RelatedDocumentFiles: TDocumentFiles;
          RelatedDocumentResponsible: TEmployee;
          RelatedDocumentResponsibleDepartment: TDepartment;
          SenderEmployee: TEmployee;
          ReceiverEmployees: TEmployees
        ): IMessage; virtual;

        function BuildNotifyingMessageForRemovedDocumentChargeSheet(
          RemovedDocumentChargeSheet: IDocumentChargeSheet;
          RelatedDocument: TDocument;
          RelatedDocumentFiles: TDocumentFiles;
          RelatedDocumentResponsible: TEmployee;
          RelatedDocumentResponsibleDepartment: TDepartment;
          SenderEmployee: TEmployee;
          ReceiverEmployees: TEmployees
        ): IMessage; virtual;
        
    end;

implementation

uses

  Variants;

{ TAbstractDocumentChargeSheetNotifyingMessageBuilder }


function TAbstractDocumentChargeSheetNotifyingMessageBuilder.
  AnyOfReceiverEmployeeHasMessageAcceptingContactInfo(
    const ReceiverEmployees: TEmployees
  ): Boolean;
var ReceiverEmployee: TEmployee;
begin

  for ReceiverEmployee in ReceiverEmployees do
    if HasReceiverEmployeeMessageAcceptingContactInfo(ReceiverEmployee) then
    begin

      Result := True;

      Exit;

    end;

  Result := False;

end;

procedure TAbstractDocumentChargeSheetNotifyingMessageBuilder.
  AssignDocumentChargeSheetMessageReceiverEmployees(
    ReceiverEmployees: TEmployees;
    Message: IMessage
  );
var ReceiverEmployee: TEmployee;
begin

  for ReceiverEmployee in ReceiverEmployees do begin

    AssignDocumentChargeSheetMessageReceiverEmployee(
      ReceiverEmployee, Message
    );

  end;

end;

function TAbstractDocumentChargeSheetNotifyingMessageBuilder.
  BuildNotifyingMessageForChangedDocumentChargeSheet(
    ChangedDocumentChargeSheet: IDocumentChargeSheet;
    RelatedDocument: TDocument;
    RelatedDocumentFiles: TDocumentFiles;
    RelatedDocumentResponsible: TEmployee;
    RelatedDocumentResponsibleDepartment: TDepartment;
    SenderEmployee: TEmployee;
    ReceiverEmployees: TEmployees
  ): IMessage;
begin

  Result :=
    BuildNotyfingMessageForDocumentChargeSheet(
      ChangedDocumentChargeSheet,
      RelatedDocument,
      RelatedDocumentFiles,
      RelatedDocumentResponsible,
      RelatedDocumentResponsibleDepartment,
      SenderEmployee,
      ReceiverEmployees
    );

  if Assigned(Result) then begin

    CustomizeMessageForChangedDocumentChargeSheet(
      Result,
      ChangedDocumentChargeSheet,
      RelatedDocument,
      RelatedDocumentFiles,
      RelatedDocumentResponsible,
      RelatedDocumentResponsibleDepartment,
      SenderEmployee,
      ReceiverEmployees
    );

  end;

end;

function TAbstractDocumentChargeSheetNotifyingMessageBuilder.
  BuildNotifyingMessageForNewDocumentChargeSheet(
    NewDocumentChargeSheet: IDocumentChargeSheet;
    RelatedDocument: TDocument;
    RelatedDocumentFiles: TDocumentFiles;
    RelatedDocumentResponsible: TEmployee;
    RelatedDocumentResponsibleDepartment: TDepartment;
    SenderEmployee: TEmployee;
    ReceiverEmployees: TEmployees
  ): IMessage;
begin

  Result :=
    BuildNotyfingMessageForDocumentChargeSheet(
      NewDocumentChargeSheet,
      RelatedDocument,
      RelatedDocumentFiles,
      RelatedDocumentResponsible,
      RelatedDocumentResponsibleDepartment,
      SenderEmployee,
      ReceiverEmployees
    );

  if Assigned(Result) then begin

    CustomizeMessageForNewDocumentChargeSheet(
      Result,
      NewDocumentChargeSheet,
      RelatedDocument,
      RelatedDocumentFiles,
      RelatedDocumentResponsible,
      RelatedDocumentResponsibleDepartment,
      SenderEmployee,
      ReceiverEmployees
    );

  end;

end;

function TAbstractDocumentChargeSheetNotifyingMessageBuilder.
  BuildNotifyingMessageForRemovedDocumentChargeSheet(
    RemovedDocumentChargeSheet: IDocumentChargeSheet;
    RelatedDocument: TDocument;
    RelatedDocumentFiles: TDocumentFiles;
    RelatedDocumentResponsible: TEmployee;
    RelatedDocumentResponsibleDepartment: TDepartment;
    SenderEmployee: TEmployee;
    ReceiverEmployees: TEmployees
  ): IMessage;
begin

  Result :=
    BuildNotyfingMessageForDocumentChargeSheet(
      RemovedDocumentChargeSheet,
      RelatedDocument,
      RelatedDocumentFiles,
      RelatedDocumentResponsible,
      RelatedDocumentResponsibleDepartment,
      SenderEmployee,
      ReceiverEmployees
    );

  if Assigned(Result) then begin

    CustomizeMessageForRemovedDocumentChargeSheet(
      Result,
      RemovedDocumentChargeSheet,
      RelatedDocument,
      RelatedDocumentFiles,
      RelatedDocumentResponsible,
      RelatedDocumentResponsibleDepartment,
      SenderEmployee,
      ReceiverEmployees
    );

  end;
  
end;

function TAbstractDocumentChargeSheetNotifyingMessageBuilder.
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

  if not AnyOfReceiverEmployeeHasMessageAcceptingContactInfo(ReceiverEmployees)
  then begin

    Result := nil;

    Exit;
    
  end;

  Result := CreateMessageInstance;

  try

    PutDocumentInfoInMessage(
      RelatedDocument,
      RelatedDocumentFiles,
      RelatedDocumentResponsible,
      RelatedDocumentResponsibleDepartment,
      Result
    );

    Result.Content.Add(FMessageSpecChars.NewLine + FMessageSpecChars.NewLine);
    
    PutDocumentChargeSheetInfoInMessage(DocumentChargeSheet, Result);

    AssignDocumentChargeSheetMessageSenderEmployee(SenderEmployee, Result);

    AssignDocumentChargeSheetMessageReceiverEmployees(
      ReceiverEmployees, Result
    );
    
  except

    on e: Exception do begin

      FreeAndNil(Result);
      raise;
      
    end;

  end;

end;

constructor TAbstractDocumentChargeSheetNotifyingMessageBuilder.Create(
  MessageSpecChars: IMessageSpecChars;
  DocumentFullNameCompilationService: IDocumentFullNameCompilationService;
  const DocumentFileStoragePath: String 
);
begin

  inherited Create;

  FMessageSpecChars := MessageSpecChars;
  FDocumentFullNameCompilationService := DocumentFullNameCompilationService;
  FDocumentFileStoragePath := DocumentFileStoragePath;
  
end;

function TAbstractDocumentChargeSheetNotifyingMessageBuilder.
  CreateMessageInstance: IMessage;
begin

  Result := TCommonMessage.Create;

end;

procedure TAbstractDocumentChargeSheetNotifyingMessageBuilder.
  CustomizeMessageForChangedDocumentChargeSheet(
    Message: IMessage;
    ChangedDocumentChargeSheet: IDocumentChargeSheet;
    RelatedDocument: TDocument;
    RelatedDocumentFiles: TDocumentFiles;
    RelatedDocumentResponsible: TEmployee;
    RelatedDocumentResponsibleDepartment: TDepartment;
    SenderEmployee: TEmployee;
    ReceiverEmployees: TEmployees
  );
begin

  Message.Name :=
    'Изменения по документу ' +
    FDocumentFullNameCompilationService.CompileFullNameForDocument(
      RelatedDocument
    );

end;

procedure TAbstractDocumentChargeSheetNotifyingMessageBuilder.
  CustomizeMessageForNewDocumentChargeSheet(
    Message: IMessage;
    NewDocumentChargeSheet: IDocumentChargeSheet;
    RelatedDocument: TDocument;
    RelatedDocumentFiles: TDocumentFiles;
    RelatedDocumentResponsible: TEmployee;
    RelatedDocumentResponsibleDepartment: TDepartment;
    SenderEmployee: TEmployee;
    ReceiverEmployees: TEmployees
  );
begin

  Message.Name :=
    'Новый документ ' +
    FDocumentFullNameCompilationService.CompileFullNameForDocument(
      RelatedDocument
    );

end;

procedure TAbstractDocumentChargeSheetNotifyingMessageBuilder.
  CustomizeMessageForRemovedDocumentChargeSheet(
    Message: IMessage;
    RemovedDocumentChargeSheet: IDocumentChargeSheet;
    RelatedDocument: TDocument;
    RelatedDocumentFiles: TDocumentFiles;
    RelatedDocumentResponsible: TEmployee;
    RelatedDocumentResponsibleDepartment: TDepartment;
    SenderEmployee: TEmployee;
    ReceiverEmployees: TEmployees
  );
begin

  Message.Name :=
    'Отозван документ ' +
    FDocumentFullNameCompilationService.CompileFullNameForDocument(
      RelatedDocument
    );
  
end;

procedure TAbstractDocumentChargeSheetNotifyingMessageBuilder.
  PutDocumentChargeSheetInfoInMessage(
    DocumentChargeSheet: IDocumentChargeSheet;
    Message: IMessage
  );
begin

  Message.Content.Add(
    '<b>Информация о поручении:</b>' +
    FMessageSpecChars.NewLine
  );

  if DocumentChargeSheet.ChargeText = '' then begin

    Message.Content.Add(
      FMessageSpecChars.Tabulation +
      'Текст: не указан' +
      FMessageSpecChars.NewLine
    );

  end

  else begin

    Message.Content.Add(
      FMessageSpecChars.Tabulation +
      'Текст:' +
      FMessageSpecChars.NewLine +
      FMessageSpecChars.Tabulation +
      FMessageSpecChars.Tabulation +
      DocumentChargeSheet.ChargeText +
      FMessageSpecChars.NewLine
    );

  end;

  if not VarIsNull(DocumentChargeSheet.TimeFrameStart)
     and not VarIsNull(DocumentChargeSheet.TimeFrameDeadline)
  then begin

    Message.Content.Add(
      FMessageSpecChars.Tabulation +
      'Срок: с ' +
       FormatDateTime('yyyy-mm-dd', DocumentChargeSheet.TimeFrameStart) +
       ' по ' +
       FormatDateTime('yyyy-mm-dd', DocumentChargeSheet.TimeFrameDeadline)
    );
    
  end;

end;

procedure TAbstractDocumentChargeSheetNotifyingMessageBuilder.
  PutDocumentFilesAsAttachmentsInMessage(
    DocumentFiles: TDocumentFiles;
    Message: IMessage
  );
var DocumentFile: TDocumentFile;
    Attachment: IMessageAttachment;
begin

  if not Assigned(DocumentFiles) then Exit;
  
  for DocumentFile in DocumentFiles do begin

    Attachment := Message.Attachments.Add;

    Attachment.FilePath := FDocumentFileStoragePath + DocumentFile.FilePath;
    
  end;

end;

procedure TAbstractDocumentChargeSheetNotifyingMessageBuilder.
  PutDocumentInfoInMessage(
    Document: TDocument;
    DocumentFiles: TDocumentFiles;
    DocumentResponsible: TEmployee;
    DocumentResponsibleDepartment: TDepartment;
    Message: IMessage
  );
var DocumentResponsibleEmail: String;
    DocumentResponsibleTelephoneNumber: String;
begin

  Message.Content.Add(
    '<b>Информация о документе:</b>' +
    FMessageSpecChars.NewLine
  );

  Message.Content.Add(
    FMessageSpecChars.Tabulation +
    'Название: ' +
    Document.Name +
    FMessageSpecChars.NewLine
  );

  Message.Content.Add(
    FMessageSpecChars.Tabulation +
    'Номер: ' +
    Document.Number +
    FMessageSpecChars.NewLine
  );
  
  Message.Content.Add(
    FMessageSpecChars.Tabulation +
    'Дата создания: ' +
    FormatDateTime('yyyy-mm-dd', Document.CreationDate) +
    FMessageSpecChars.NewLine
  );

  Message.Content.Add(
    FMessageSpecChars.Tabulation +
    'Содержание:' +
    FMessageSpecChars.NewLine
  );
  
  Message.Content.Add(
    FMessageSpecChars.Tabulation +
    FMessageSpecChars.Tabulation +
    Document.Content +
    FMessageSpecChars.NewLine
  );

  Message.Content.Add(
    FMessageSpecChars.Tabulation +
    'Примечание: ' +
    FMessageSpecChars.NewLine
  );

  Message.Content.Add(
    FMessageSpecChars.Tabulation +
    FMessageSpecChars.Tabulation +
    Document.Note +
    FMessageSpecChars.NewLine
  );

  Message.Content.Add(
    '<b>Информация об исполнителе:</b>' +
    FMessageSpecChars.NewLine
  );
  
  Message.Content.Add(
    FMessageSpecChars.Tabulation +
    'Имя сотрудника: ' +
    DocumentResponsible.FullName + ' (' +
    DocumentResponsibleDepartment.ShortName + ')' +
    FMessageSpecChars.NewLine
  );

  if DocumentResponsible.Email = '' then
    DocumentResponsibleEmail := 'не указан'

  else
    DocumentResponsibleEmail := DocumentResponsible.ContactInfo.Email;

  if DocumentResponsible.TelephoneNumber = '' then
    DocumentResponsibleTelephoneNumber := 'не указан'

  else
    DocumentResponsibleTelephoneNumber := DocumentResponsible.TelephoneNumber;

    {
  Message.Content.Add(
    FMessageSpecChars.Tabulation +
    'Контактные данные сотрудника:' +
    FMessageSpecChars.NewLine
  ); }

  Message.Content.Add(
    //FMessageSpecChars.Tabulation +
    FMessageSpecChars.Tabulation +
    'E-mail: ' + DocumentResponsibleEmail +
    FMessageSpecChars.NewLine
  );

  Message.Content.Add(
    //FMessageSpecChars.Tabulation +
    FMessageSpecChars.Tabulation +
    'Телефон: ' + DocumentResponsibleTelephoneNumber
  );
  
  //PutDocumentFilesAsAttachmentsInMessage(DocumentFiles, Message);

end;

end.
