unit StandardDocumentChargeSheetCasesNotifier;

interface

uses

  DocumentChargeSheetCasesNotifier,
  DocumentChargeSheet,
  DocumentFileUnit,
  DocumentFilesRepository,
  IDocumentResponsibleRepositoryUnit,
  IDocumentChargeSheetUnit,
  DocumentChargeSheetNotifyingMessageBuilder,
  UserNotificationProfileGroup,
  DocumentRepository,
  Document,
  MessagingServiceUnit,
  Employee,
  DepartmentUnit,
  IEmployeeRepositoryUnit,
  UserNotificationProfileService,
  SysUtils,
  Classes;

type

  TStandardDocumentChargeSheetCasesNotifier =
    class (TInterfacedObject, IDocumentChargeSheetCasesNotifier)

      protected

        FDocumentResponsibleRepository: IDocumentResponsibleRepository;
        FDocumentChargeSheetNotifyingMessageBuilder: IDocumentChargeSheetNotifyingMessageBuilder;
        FDocumentFilesRepository: IDocumentFilesRepository;
        FDocumentRepository: IDocumentRepository;
        FMessagingService: IMessagingService;
        FUserNotificationProfileService: IUserNotificationProfileService;
        FEmployeeRepository: IEmployeeRepository;

        function CreateDocumentChargeSheetMessagesFrom(
          DocumentChargeSheets: TDocumentChargeSheets;
          NotificationSender: TEmployee;
          DocumentChargeSheetsNotificationCase: TDocumentChargeSheetsNotificationCase
        ): IMessages;

        procedure GetRelatedDocumentComponentsForChargeSheet(
          DocumentChargeSheet: IDocumentChargeSheet;
          var RelatedDocument: TDocument;
          var RelatedDocumentFiles: TDocumentFiles;
          var RelatedDocumentResponsible: TEmployee;
          var RelatedDocumentResponsibleDepartment: TDepartment
        );

      protected

        procedure OnMessageSentEventHandler(
          Sender: TObject;
          Message: IMessage;
          RelatedState: TObject
        );

        procedure OnMessageSendingFailedEventHandler(
          Sender: TObject;
          Message: IMessage;
          const Error: Exception;
          RelatedState: TObject
        );

      public

        constructor Create(
          DocumentRepository: IDocumentRepository;
          DocumentFilesRepository: IDocumentFilesRepository;
          DocumentResponsibleRepository: IDocumentResponsibleRepository;
          DocumentChargeSheetNotifyingMessageBuilder: IDocumentChargeSheetNotifyingMessageBuilder;
          MessagingService: IMessagingService;
          UserNotificationProfileService: IUserNotificationProfileService;
          EmployeeRepository: IEmployeeRepository
        );

        procedure SendNotificationAboutDocumentChargeSheets(
          DocumentChargeSheets: TDocumentChargeSheets;
          NotificationSender: TEmployee;
          DocumentChargeSheetsNotificationCase: TDocumentChargeSheetsNotificationCase
        );

        procedure SendNotificationAboutDocumentChargeSheetsAsync(

          DocumentChargeSheets: TDocumentChargeSheets;
          NotificationSender: TEmployee;
          DocumentChargeSheetsNotificationCase: TDocumentChargeSheetsNotificationCase;

          OnDocumentChargeSheetNotificationSentEventHandler:
            TOnDocumentChargeSheetNotificationSentEventHandler;

          OnDocumentChargeSheetNotificationSendingFailedEventHandler:
            TOnDocumentChargeSheetNotificationSendingFailedEventHandler

        );

        function GetSelf: TObject;
        
    end;

implementation

uses

  VariantListUnit,
  Disposable,
  UserNotificationProfile,
  IDomainObjectUnit,
  IDomainObjectListUnit,
  IncomingDocument;

type

  TAsyncDocumentChargeSheetNotificationCasesEventHandlers = class

    public

      TotalUnHandledNotificationCount: Integer;
      
    public

      DocumentChargeSheetNotificationCase:
        TDocumentChargeSheetsNotificationCase;

      OnDocumentChargeSheetNotificationSentEventHandler:
        TOnDocumentChargeSheetNotificationSentEventHandler;

      OnDocumentChargeSheetNotificationSendingFailedEventHandler:
        TOnDocumentChargeSheetNotificationSendingFailedEventHandler;

      constructor Create(

        TotalUnHandledNotificationCount: Integer;
        
        DocumentChargeSheetNotificationCase:
          TDocumentChargeSheetsNotificationCase;

        OnDocumentChargeSheetNotificationSentEventHandler:
          TOnDocumentChargeSheetNotificationSentEventHandler;

        OnDocumentChargeSheetNotificationSendingFailedEventHandler:
          TOnDocumentChargeSheetNotificationSendingFailedEventHandler
          
      );

      procedure HandleAndFreeIfAllNotificationsHandled;

  end;

{ TStandardDocumentChargeSheetCasesNotifier }

constructor TStandardDocumentChargeSheetCasesNotifier.Create(
  DocumentRepository: IDocumentRepository;
  DocumentFilesRepository: IDocumentFilesRepository;
  DocumentResponsibleRepository: IDocumentResponsibleRepository;
  DocumentChargeSheetNotifyingMessageBuilder: IDocumentChargeSheetNotifyingMessageBuilder;
  MessagingService: IMessagingService;
  UserNotificationProfileService: IUserNotificationProfileService;
  EmployeeRepository: IEmployeeRepository
);
begin

  inherited Create;

  FDocumentRepository := DocumentRepository;
  FDocumentFilesRepository := DocumentFilesRepository;
  FDocumentResponsibleRepository := DocumentResponsibleRepository;
  FDocumentChargeSheetNotifyingMessageBuilder := DocumentChargeSheetNotifyingMessageBuilder;
  FMessagingService := MessagingService;
  FUserNotificationProfileService := UserNotificationProfileService;
  FEmployeeRepository := EmployeeRepository;

end;

procedure TStandardDocumentChargeSheetCasesNotifier.
  SendNotificationAboutDocumentChargeSheets(
    DocumentChargeSheets: TDocumentChargeSheets;
    NotificationSender: TEmployee;
    DocumentChargeSheetsNotificationCase: TDocumentChargeSheetsNotificationCase
  );
var DocumentChargeSheetMessages: IMessages;
begin

  DocumentChargeSheetMessages :=
    CreateDocumentChargeSheetMessagesFrom(
      DocumentChargeSheets,
      NotificationSender,
      DocumentChargeSheetsNotificationCase
    );

  FMessagingService.SendMessages(DocumentChargeSheetMessages);
  
end;

procedure TStandardDocumentChargeSheetCasesNotifier.
  SendNotificationAboutDocumentChargeSheetsAsync(

    DocumentChargeSheets: TDocumentChargeSheets;
    NotificationSender: TEmployee;
    DocumentChargeSheetsNotificationCase: TDocumentChargeSheetsNotificationCase;

    OnDocumentChargeSheetNotificationSentEventHandler:
      TOnDocumentChargeSheetNotificationSentEventHandler;

    OnDocumentChargeSheetNotificationSendingFailedEventHandler:
      TOnDocumentChargeSheetNotificationSendingFailedEventHandler

  );
var DocumentChargeSheetMessages: IMessages;
begin

  DocumentChargeSheetMessages :=
    CreateDocumentChargeSheetMessagesFrom(
      DocumentChargeSheets,
      NotificationSender,
      DocumentChargeSheetsNotificationCase
    );

  if not Assigned(DocumentChargeSheetMessages) then
    Exit;

  FMessagingService.SendMessagesAsync(
    DocumentChargeSheetMessages,
    OnMessageSentEventHandler,
    OnMessageSendingFailedEventHandler,

    TAsyncDocumentChargeSheetNotificationCasesEventHandlers.Create(
      DocumentChargeSheetMessages.Count,
      DocumentChargeSheetsNotificationCase,
      OnDocumentChargeSheetNotificationSentEventHandler,
      OnDocumentChargeSheetNotificationSendingFailedEventHandler
    )
  );

end;

function TStandardDocumentChargeSheetCasesNotifier.
  CreateDocumentChargeSheetMessagesFrom(
    DocumentChargeSheets: TDocumentChargeSheets;
    NotificationSender: TEmployee;
    DocumentChargeSheetsNotificationCase: TDocumentChargeSheetsNotificationCase
  ): IMessages;

var

    DocumentChargeSheet: IDocumentChargeSheet;

    RelatedDocument: TDocument;
    FreeRelatedDocument: IDomainObject;

    RelatedDocumentFiles: TDocumentFiles;
    FreeRelatedDocumentFiles: IDomainObjectList;

    RelatedDocumentResponsible: TEmployee;
    FreeRelatedDocumentResponsible: IDomainObject;

    RelatedDocumentResponsibleDepartment: TDepartment;
    FreeRelatedDocumentResponsibleDepartment: IDomainObject;

    DocumentChargeSheetNotificationCaseMessage: IMessage;

    ChargeSheetPerformers: TEmployees;
    FreeChargeSheetPerformers: IDomainObjectList;
    ChargeSheetPerformerIds: TVariantList;

    AllChargeSheetsNotificationsReceiverIds: TVariantList;
    AllChargeSheetsNotificationsReceivers: TEmployees;
    FreeAllChargeSheetsNotificationsReceivers: IDomainObjectList;

    ChargeSheetNotificationsReceiverIds: TVariantList;
    ChargeSheetNotificationsReceiverProfiles: TUserNotificationProfiles;
    FreeChargeSheetNotificationsReceiverProfiles: IDisposable;

    ChargeSheetNotificationReceivers: TEmployees;
    FreeChargeSheetNotificationReceivers: IDomainObjectList;

    PerformerNotificationProfiles: TUserNotificationProfiles;
    PerformerNotificationProfile: TUserNotificationProfile;
begin

  if not Assigned(DocumentChargeSheets) or DocumentChargeSheets.IsEmpty
  then Exit;

  ChargeSheetPerformerIds := nil;
  PerformerNotificationProfiles := nil;
  AllChargeSheetsNotificationsReceiverIds := nil;
  RelatedDocument := nil;
  RelatedDocumentFiles := nil;
  RelatedDocumentResponsible := nil;
  RelatedDocumentResponsibleDepartment := nil;
  ChargeSheetNotificationsReceiverIds := nil;

  ChargeSheetPerformers := DocumentChargeSheets.FetchPerformers;

  FreeChargeSheetPerformers := ChargeSheetPerformers;

  try
  
    ChargeSheetPerformerIds := ChargeSheetPerformers.CreateDomainObjectIdentityList;

    PerformerNotificationProfiles :=
      FUserNotificationProfileService
        .GetNotificationProfilesForUsersAndThoseWhoCanReceiveNotificationsForThem(
          ChargeSheetPerformerIds,
          TUserNotificationProfileGettingOptions.Create.ReceivingNotificationsEnabled(True)
        );

    if not Assigned(PerformerNotificationProfiles) then Exit;

    AllChargeSheetsNotificationsReceiverIds := PerformerNotificationProfiles.FetchUserIds;

    AllChargeSheetsNotificationsReceivers := FEmployeeRepository.FindEmployeesByIdentities(AllChargeSheetsNotificationsReceiverIds);

    if not Assigned(AllChargeSheetsNotificationsReceivers) then begin

      raise TDocumentChargeSheetCasesNotifierException.Create(
        'Не удалось получить информацию о ' +
        'получателях уведомления по документу'
      );
      
    end;

    FreeAllChargeSheetsNotificationsReceivers := AllChargeSheetsNotificationsReceivers;

    Result := FMessagingService.CreateMessagesInstance;

    for DocumentChargeSheet in DocumentChargeSheets do begin

      ChargeSheetNotificationsReceiverProfiles :=
        PerformerNotificationProfiles
          .GetProfilesForUserAndHisOwnNotificationsReceivingUsersRecursively(
            DocumentChargeSheet.Performer.Identity
          );

      if not Assigned(ChargeSheetNotificationsReceiverProfiles) then Continue;

      ChargeSheetNotificationsReceiverIds :=
        ChargeSheetNotificationsReceiverProfiles.FetchUserIds;

      ChargeSheetNotificationReceivers :=
        AllChargeSheetsNotificationsReceivers.FindEmployeesByIdentities(ChargeSheetNotificationsReceiverIds);

      FreeChargeSheetNotificationReceivers := ChargeSheetNotificationReceivers;

      if ChargeSheetNotificationReceivers.IsEmpty then Continue;

      GetRelatedDocumentComponentsForChargeSheet(
        DocumentChargeSheet,
        RelatedDocument,
        RelatedDocumentFiles,
        RelatedDocumentResponsible,
        RelatedDocumentResponsibleDepartment
      );

      FreeRelatedDocument := RelatedDocument;
      FreeRelatedDocumentFiles := RelatedDocumentFiles;
      FreeRelatedDocumentResponsible := RelatedDocumentResponsible;
      FreeRelatedDocumentResponsibleDepartment := RelatedDocumentResponsibleDepartment;

      case DocumentChargeSheetsNotificationCase of

        NewDocumentChargeSheetsCreatedCase:
        begin

          DocumentChargeSheetNotificationCaseMessage :=
            FDocumentChargeSheetNotifyingMessageBuilder.
              BuildNotifyingMessageForNewDocumentChargeSheet(
                DocumentChargeSheet,
                RelatedDocument,
                RelatedDocumentFiles,
                RelatedDocumentResponsible,
                RelatedDocumentResponsibleDepartment,
                NotificationSender,
                ChargeSheetNotificationReceivers
              );

        end;

        DocumentChargeSheetsChangedCase:
        begin

          DocumentChargeSheetNotificationCaseMessage :=
            FDocumentChargeSheetNotifyingMessageBuilder.
              BuildNotifyingMessageForChangedDocumentChargeSheet(
                DocumentChargeSheet,
                RelatedDocument,
                RelatedDocumentFiles,
                RelatedDocumentResponsible,
                RelatedDocumentResponsibleDepartment,
                NotificationSender,
                ChargeSheetNotificationReceivers
              );
            
        end;

        DocumentChargeSheetsRemovedCase:
        begin

          DocumentChargeSheetNotificationCaseMessage :=
            FDocumentChargeSheetNotifyingMessageBuilder.
              BuildNotifyingMessageForRemovedDocumentChargeSheet(
                DocumentChargeSheet,
                RelatedDocument,
                RelatedDocumentFiles,
                RelatedDocumentResponsible,
                RelatedDocumentResponsibleDepartment,
                NotificationSender,
                ChargeSheetNotificationReceivers
              );
            
        end;

      end;

      if Assigned(DocumentChargeSheetNotificationCaseMessage) then
        Result.PutMessage(DocumentChargeSheetNotificationCaseMessage);

    end;

  finally

    FreeAndNil(ChargeSheetPerformerIds);
    FreeAndNil(ChargeSheetNotificationsReceiverIds);
    FreeAndNil(AllChargeSheetsNotificationsReceiverIds);
    FreeAndNil(PerformerNotificationProfiles);

  end;

end;

procedure TStandardDocumentChargeSheetCasesNotifier.
  GetRelatedDocumentComponentsForChargeSheet(
    DocumentChargeSheet: IDocumentChargeSheet;
    var RelatedDocument: TDocument;
    var RelatedDocumentFiles: TDocumentFiles;
    var RelatedDocumentResponsible: TEmployee;
    var RelatedDocumentResponsibleDepartment: TDepartment
  );
begin

  if
    not Assigned(RelatedDocument) or
    (RelatedDocument.Identity <> DocumentChargeSheet.DocumentId)
  then begin

    RelatedDocument :=
      FDocumentRepository.FindDocumentById(DocumentChargeSheet.DocumentId);

    if not Assigned(RelatedDocument) then begin

      raise TDocumentChargeSheetCasesNotifierException.Create(
        'Не найдена информация о документе, необходимая ' +
        'для отправки уведомлений об изменениях в поручениях '
      );
      
    end;

    try

      RelatedDocumentFiles :=
        FDocumentFilesRepository.FindFilesForDocument(RelatedDocument.Identity);

      if
        not Assigned(RelatedDocumentResponsible) or
        (RelatedDocumentResponsible.Identity <> RelatedDocument.ResponsibleId)
      then begin

        RelatedDocumentResponsible :=
          FDocumentResponsibleRepository.FindDocumentResponsibleById(
            RelatedDocument.ResponsibleId
          );

        RelatedDocumentResponsibleDepartment :=
          FDocumentResponsibleRepository.FindDocumentResponsibleDepartmentById(
            RelatedDocumentResponsible.DepartmentIdentity
          );

      end;

    except

      on E: Exception do begin

        FreeAndNil(RelatedDocument);
        FreeAndNil(RelatedDocumentFiles);
        FreeAndNil(RelatedDocumentResponsible);
        FreeAndNil(RelatedDocumentResponsibleDepartment);

        Raise;
        
      end;

    end;

  end;

end;

function TStandardDocumentChargeSheetCasesNotifier.GetSelf: TObject;
begin

  Result := Self;

end;

procedure TStandardDocumentChargeSheetCasesNotifier.
  OnMessageSendingFailedEventHandler(
    Sender: TObject;
    Message: IMessage;
    const Error: Exception;
    RelatedState: TObject
  );

  function CreateMessageReceiverNameListStringFrom(
    MessageReceivers: IMessageMembers
  ): String;
  var MessageReceiver: IMessageMember;
  begin

    for MessageReceiver in MessageReceivers do begin

      if Result = '' then
        Result := MessageReceiver.DisplayName

      else Result := Result + sLineBreak + MessageReceiver.DisplayName;

    end;

  end;

var AsyncEventHandlers:
      TAsyncDocumentChargeSheetNotificationCasesEventHandlers;

    NotificationSendingError: Exception;
begin

  AsyncEventHandlers :=
    RelatedState as TAsyncDocumentChargeSheetNotificationCasesEventHandlers;

  NotificationSendingError := nil;

  try

    if not Assigned(AsyncEventHandlers.OnDocumentChargeSheetNotificationSendingFailedEventHandler)
    then Exit;
    
    NotificationSendingError :=
      TDocumentChargeSheetCasesNotifierException.CreateFmt(
        'Не удалось отправить уведомительное ' +
        'сообщение "%s" следующим адресатам:' +
        sLineBreak +
        '%s' + sLineBreak + sLineBreak + 'Возникшая ошибка:' + sLineBreak +
        '%s',
        [
          Message.Name,
          CreateMessageReceiverNameListStringFrom(Message.Receivers),
          Error.Message
        ]
      );

    AsyncEventHandlers.
      OnDocumentChargeSheetNotificationSendingFailedEventHandler(
        Self,
        NotificationSendingError,
        AsyncEventHandlers.DocumentChargeSheetNotificationCase
      );
    
  finally
    
    AsyncEventHandlers.HandleAndFreeIfAllNotificationsHandled;
    
    FreeAndNil(NotificationSendingError);

  end;

end;

procedure TStandardDocumentChargeSheetCasesNotifier.
  OnMessageSentEventHandler(
    Sender: TObject;
    Message: IMessage;
    RelatedState: TObject
  );
var AsyncEventHandlers: TAsyncDocumentChargeSheetNotificationCasesEventHandlers;
begin

  AsyncEventHandlers :=
    RelatedState as TAsyncDocumentChargeSheetNotificationCasesEventHandlers;

  AsyncEventHandlers.HandleAndFreeIfAllNotificationsHandled;
  
end;

{ TAsyncDocumentChargeSheetNotificationCasesEventHandlers }

constructor TAsyncDocumentChargeSheetNotificationCasesEventHandlers.Create(

  TotalUnHandledNotificationCount: Integer;
  
  DocumentChargeSheetNotificationCase:
    TDocumentChargeSheetsNotificationCase;

  OnDocumentChargeSheetNotificationSentEventHandler:
    TOnDocumentChargeSheetNotificationSentEventHandler;

  OnDocumentChargeSheetNotificationSendingFailedEventHandler:
    TOnDocumentChargeSheetNotificationSendingFailedEventHandler

);
begin

  inherited Create;

  Self.TotalUnHandledNotificationCount := TotalUnHandledNotificationCount;
  
  Self.DocumentChargeSheetNotificationCase :=
    DocumentChargeSheetNotificationCase;

  Self.OnDocumentChargeSheetNotificationSentEventHandler :=
    OnDocumentChargeSheetNotificationSentEventHandler;

  Self.OnDocumentChargeSheetNotificationSendingFailedEventHandler :=
    OnDocumentChargeSheetNotificationSendingFailedEventHandler;
    
end;

procedure TAsyncDocumentChargeSheetNotificationCasesEventHandlers.
  HandleAndFreeIfAllNotificationsHandled;
begin

  Dec(TotalUnHandledNotificationCount);

  if TotalUnHandledNotificationCount = 0 then
    Free;

end;


end.
