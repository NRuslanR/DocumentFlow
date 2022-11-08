{ refactor: удалить информацию о документе ещё и через службу просмотра 
}
unit StandardDocumentStorageService;

interface

uses

  DocumentOperationService,
  EmployeeDocumentOperationService,
  IDocumentUnit,
  Document,
  Employee,
  Department,
  DocumentFileUnit,
  DocumentRelationsUnit,
  Session,
  DocumentDirectory,
  DepartmentRepository,
  DocumentUsageEmployeeAccessRightsInfo,
  DocumentFilesRepository,
  DocumentRelationsRepository,
  IDocumentFileServiceClientUnit,
  DocumentUsageEmployeeAccessRightsInfoDTO,
  DocumentUsageEmployeeAccessRightsService,
  DocumentObjectsDTODomainMapper,
  EmployeeDocumentWorkingRules,
  IEmployeeRepositoryUnit,
  DocumentStorageService,
  DocumentRegistrationService,
  IDocumentResponsibleRepositoryUnit,
  DocumentInfoReadService,
  DocumentResponsibleInfoDTO,
  DocumentFlowEmployeeInfoDTO,
  DocumentFullInfoDTO,
  NewDocumentInfoDTO,
  ChangedDocumentInfoDTO,
  DocumentApprovingCycleResultRepository,
  DocumentStorageServiceCommandsAndRespones,
  DocumentUsageEmployeeAccessRightsInfoDTOMapper,
  DocumentResponsibleInfoDTOMapper,
  DocumentCreatingService,
  VariantListUnit,
  DocumentFullInfoDTOMapper,
  SysUtils,
  Classes;

type

  TStandardDocumentStorageService =
    class (
      TEmployeeDocumentOperationService,
      IDocumentStorageService
    )

      protected

        FDocumentCreatingService: IDocumentCreatingService;
        FDocumentInfoReadService: IDocumentInfoReadService;
        FDocumentUsageEmployeeAccessRightsService: IDocumentUsageEmployeeAccessRightsService;

        FDocumentObjectsDTODomainMapper: TDocumentObjectsDTODomainMapper;
        FDocumentFullInfoDTOMapper: TDocumentFullInfoDTOMapper;
        FDocumentResponsibleInfoDTOMapper: TDocumentResponsibleInfoDTOMapper;
        FDocumentUsageEmployeeAccessRightsInfoDTOMapper: TDocumentUsageEmployeeAccessRightsInfoDTOMapper;
        
      protected

        procedure RegisterDocumentForEmployeeIfNecessary(Document: TDocument);

      protected

        procedure EnsureEmployeeMayRemoveDocuments(
          RemovingEmployee: TEmployee;
          RemovableDocuments: TDocuments
        ); virtual;

        procedure EnsureEmployeeMayRemoveDocument(
          RemovingEmployee: TEmployee;
          RemovableDocument: TDocument
        ); virtual;

      protected
      
        procedure RemoveDocuments(
          RemovableDocumentIds: TVariantList;
          RemovingEmployee: TEmployee
        ); virtual;

      protected

        function EnsureThatEmployeeHasDocumentUsageAccessRights(
          Document: IDocument;
          RequestingEmployee: TEmployee
        ): IDocumentUsageEmployeeAccessRightsInfoDTO; virtual;

        function MapDocumentUsageEmployeeAccessRightsInfoDTOFrom(
          DocumentUsageEmployeeAccessRightsInfo:
            TDocumentUsageEmployeeAccessRightsInfo
        ): IDocumentUsageEmployeeAccessRightsInfoDTO;

      protected

        procedure RaiseExceptionIfGettingDocumentFullInfoCommandIsNotCorrect(
          Command: TGettingDocumentFullInfoCommand
        );

        procedure RaiseExceptionIfAddNewDocumentFullInfoCommandIsNotCorrect(
          Command: TAddNewDocumentFullInfoCommand
        );

        procedure RaiseExceptionIfChangeDocumentInfoCommandIsNotCorrect(
          Command: TChangeDocumentInfoCommand
        );

        procedure RaiseExceptionIfRemoveDocumentsInfoCommandIsNotCorrect(
          Command: TRemoveDocumentsInfoCommand
        );

      protected

        function CreateAddingNewDocumentFullInfoCommandResultFrom(
          Document: TDocument;
          Employee: TEmployee
        ): IAddNewDocumentFullInfoCommandResult;

      public

        constructor Create(

          Session: ISession;
          DocumentDirectory: IDocumentDirectory;
          EmployeeRepository: IEmployeeRepository;
          DocumentCreatingService: IDocumentCreatingService;
          DocumentInfoReadService: IDocumentInfoReadService;
          DocumentUsageEmployeeAccessRightsService: IDocumentUsageEmployeeAccessRightsService;
          DocumentObjectsDTODomainMapper: TDocumentObjectsDTODomainMapper;
          DocumentFullInfoDTOMapper: TDocumentFullInfoDTOMapper;
          DocumentUsageEmployeeAccessRightsInfoDTOMapper: TDocumentUsageEmployeeAccessRightsInfoDTOMapper;
          DocumentResponsibleInfoDTOMapper: TDocumentResponsibleInfoDTOMapper

        ); virtual;

        function CreateDocument(
          DocumentCreatingCommand: IDocumentCreatingCommand
        ): IDocumentCreatingCommandResult; virtual;

        function GetDocumentFullInfo(
          GettingDocumentFullInfoCommand: TGettingDocumentFullInfoCommand
        ): IGettingDocumentFullInfoCommandResult; virtual;
      
        function AddNewDocumentFullInfo(
          AddNewDocumentFullInfoCommand: TAddNewDocumentFullInfoCommand
        ): IAddNewDocumentFullInfoCommandResult; virtual;

        procedure ChangeDocumentInfo(
          ChangeDocumentInfoCommand: TChangeDocumentInfoCommand
        ); virtual;

        procedure ChangeDocumentApprovingsInfo(
          ChangeDocumentApprovingsInfoCommand: TChangeDocumentApprovingsInfoCommand
        ); virtual;

        procedure RemoveDocumentsInfo(
          RemoveDocumentsInfoCommand: TRemoveDocumentsInfoCommand
        ); virtual;

    end;

    TStandardDocumentStorageServiceClass = class of TStandardDocumentStorageService;

implementation

uses

  Disposable,
  DocumentChargeInterface,
  IDomainObjectBaseUnit,
  IDomainObjectUnit,
  AuxDebugFunctionsUnit,
  IDomainObjectListUnit,
  Variants,
  BusinessProcessService, AbstractApplicationService;

{ TStandardDocumentStorageService }

constructor TStandardDocumentStorageService.Create(

  Session: ISession;
  DocumentDirectory: IDocumentDirectory;
  EmployeeRepository: IEmployeeRepository;
  DocumentCreatingService: IDocumentCreatingService;
  DocumentInfoReadService: IDocumentInfoReadService;
  DocumentUsageEmployeeAccessRightsService: IDocumentUsageEmployeeAccessRightsService;
  DocumentObjectsDTODomainMapper: TDocumentObjectsDTODomainMapper;
  DocumentFullInfoDTOMapper: TDocumentFullInfoDTOMapper;
  DocumentUsageEmployeeAccessRightsInfoDTOMapper: TDocumentUsageEmployeeAccessRightsInfoDTOMapper;
  DocumentResponsibleInfoDTOMapper: TDocumentResponsibleInfoDTOMapper

);
begin

  inherited Create(
    Session,
    DocumentDirectory,
    EmployeeRepository
  );

  FDocumentCreatingService := DocumentCreatingService;
  FDocumentInfoReadService := DocumentInfoReadService;
  FDocumentUsageEmployeeAccessRightsService := DocumentUsageEmployeeAccessRightsService;
 
  FDocumentObjectsDTODomainMapper :=
    DocumentObjectsDTODomainMapper;

  FDocumentFullInfoDTOMapper := DocumentFullInfoDTOMapper;
  
  FDocumentUsageEmployeeAccessRightsInfoDTOMapper :=
    DocumentUsageEmployeeAccessRightsInfoDTOMapper;
  FDocumentResponsibleInfoDTOMapper := DocumentResponsibleInfoDTOMapper;
end;

function TStandardDocumentStorageService.
  CreateAddingNewDocumentFullInfoCommandResultFrom(
    Document: TDocument;
    Employee: TEmployee
  ): IAddNewDocumentFullInfoCommandResult;
  
var AddNewDocumentFullInfoCommandResult: TAddNewDocumentFullInfoCommandResult;
begin
                                   
  AddNewDocumentFullInfoCommandResult := TAddNewDocumentFullInfoCommandResult.Create;

  Result := AddNewDocumentFullInfoCommandResult;

  AddNewDocumentFullInfoCommandResult.NewDocumentId := Document.Identity;

  AddNewDocumentFullInfoCommandResult.CurrentNewDocumentWorkCycleStageNumber :=
    Document.CurrentWorkCycleStageNumber;

  AddNewDocumentFullInfoCommandResult.CurrentNewDocumentWorkCycleStageName :=
    Document.CurrentWorkCycleStageName;

  AddNewDocumentFullInfoCommandResult.AssignedNewDocumentNumber :=
    Document.Number;

  AddNewDocumentFullInfoCommandResult.DocumentAuthorDto :=
    TDocumentFlowEmployeeInfoDTO.Create;

  { refactor: to use employee mapper }
  
  AddNewDocumentFullInfoCommandResult.DocumentAuthorDto.Id :=
    Document.Author.Identity;

  AddNewDocumentFullInfoCommandResult.DocumentAuthorDto.FullName :=
    Document.Author.FullName;

  AddNewDocumentFullInfoCommandResult
    .NewDocumentUsageEmployeeAccessRightsInfoDTO :=
      EnsureThatEmployeeHasDocumentUsageAccessRights(
        Document, Employee
      );
      
end;

function TStandardDocumentStorageService.CreateDocument(
  DocumentCreatingCommand: IDocumentCreatingCommand
): IDocumentCreatingCommandResult;
var
    Employee: TEmployee;
    FreeEmployee: IDomainObjectBase;

    Document: IDocument;

    AccessRights: TDocumentUsageEmployeeAccessRightsInfo;
    FreeAccessRights: IDomainObjectBase;

    DocumentFullInfoDTO: TDocumentFullInfoDTO;
    FreeDocumentFullInfoDTO: IDisposable;

    AccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO;
    FreeAccessRightsInfoDTO: IDocumentUsageEmployeeAccessRightsInfoDTO;
begin

  Employee :=
    GetEmployeeOrRaise(
      DocumentCreatingCommand.EmployeeId,
      'Не найден сотрудник во время запроса на создание документа'
    );

  FreeEmployee := Employee;

  Document :=
    FDocumentCreatingService.CreateDefaultDraftedDocumentForEmployee(Employee);

  AccessRights :=
    FDocumentUsageEmployeeAccessRightsService
      .EnsureThatEmployeeHasDocumentUsageAccessRights(
        Document, Employee
      );

  FreeAccessRights := AccessRights;

  DocumentFullInfoDTO :=
    FDocumentFullInfoDTOMapper
      .MapDocumentFullInfoDTOFrom(TDocument(Document.Self), Employee);

  FreeDocumentFullInfoDTO := DocumentFullInfoDTO;

  AccessRightsInfoDTO :=
    FDocumentUsageEmployeeAccessRightsInfoDTOMapper
      .MapDocumentUsageEmployeeAccessRightsInfoDTOFrom(AccessRights);

  FreeAccessRightsInfoDTO := AccessRightsInfoDTO;

  Result :=
    TDocumentCreatingCommandResult.Create(
      DocumentFullInfoDTO, AccessRightsInfoDTO
    );

end;

procedure TStandardDocumentStorageService.EnsureEmployeeMayRemoveDocument(
  RemovingEmployee: TEmployee;
  RemovableDocument: TDocument
);
begin

  RemovableDocument
    .WorkingRules
      .DocumentRemovingRule
        .EnsureThatIsSatisfiedFor(
          RemovingEmployee, RemovableDocument
        );
        
end;

function TStandardDocumentStorageService.
  EnsureThatEmployeeHasDocumentUsageAccessRights(
    Document: IDocument;
    RequestingEmployee: TEmployee
  ): IDocumentUsageEmployeeAccessRightsInfoDTO;
begin

  Result :=
    MapDocumentUsageEmployeeAccessRightsInfoDTOFrom(
      FDocumentUsageEmployeeAccessRightsService.
        EnsureThatEmployeeHasDocumentUsageAccessRights(
          Document, RequestingEmployee
        )
    );

end;

function TStandardDocumentStorageService.GetDocumentFullInfo(
  GettingDocumentFullInfoCommand: TGettingDocumentFullInfoCommand

): IGettingDocumentFullInfoCommandResult;
var
    FreeCommand: IDocumentStorageServiceCommand;
    DocumentId: Variant;
    RequestingEmployeeId: Variant;

    Document: IDocument;
    
    RequestingEmployee: TEmployee;
    FreeRequestingEmployee: IDomainObject;
    
    DocumentFullInfoDTO: TDocumentFullInfoDTO;
    DocumentUsageEmployeeAccessRightsInfoDTO:
      IDocumentUsageEmployeeAccessRightsInfoDTO;
begin

  FreeCommand := GettingDocumentFullInfoCommand;

  RaiseExceptionIfGettingDocumentFullInfoCommandIsNotCorrect(
    GettingDocumentFullInfoCommand
  );

  Document := nil;
  RequestingEmployee := nil;
  DocumentFullInfoDTO := nil;
  DocumentUsageEmployeeAccessRightsInfoDTO := nil;

  try

    DocumentId :=
      GettingDocumentFullInfoCommand.DocumentId;

    RequestingEmployeeId :=
      GettingDocumentFullInfoCommand.RequestingEmployeeId;

    FSession.Start;

    Document := GetDocument(DocumentId);

    RequestingEmployee := GetEmployee(RequestingEmployeeId);

    if not Assigned(RequestingEmployee) then begin

      RaiseFailedBusinessProcessServiceException(
        'Запрашивающий документ ' +
        'сотрудник не найден'
      );

    end;

    FreeRequestingEmployee := RequestingEmployee;
    
    DocumentUsageEmployeeAccessRightsInfoDTO :=
      EnsureThatEmployeeHasDocumentUsageAccessRights(
        Document, RequestingEmployee
      );

    FSession.Commit;

    DocumentFullInfoDTO :=
      FDocumentInfoReadService.GetDocumentFullInfo(DocumentId);

    Result := TGettingDocumentFullInfoCommandResult.Create(
                DocumentFullInfoDTO,
                DocumentUsageEmployeeAccessRightsInfoDTO
              );

  except

    on e: Exception do begin

      FreeAndNil(DocumentFullInfoDTO);
      FreeAndNil(DocumentUsageEmployeeAccessRightsInfoDTO);
      
      FSession.Rollback;
      
      RaiseFailedBusinessProcessServiceException(e.Message);
      
    end;

  end;

end;

function TStandardDocumentStorageService.
  MapDocumentUsageEmployeeAccessRightsInfoDTOFrom(
    DocumentUsageEmployeeAccessRightsInfo:
      TDocumentUsageEmployeeAccessRightsInfo
    ): IDocumentUsageEmployeeAccessRightsInfoDTO;
begin

  Result :=
    FDocumentUsageEmployeeAccessRightsInfoDTOMapper.
      MapDocumentUsageEmployeeAccessRightsInfoDTOFrom(
        DocumentUsageEmployeeAccessRightsInfo
      );

end;

function TStandardDocumentStorageService.AddNewDocumentFullInfo(
  AddNewDocumentFullInfoCommand: TAddNewDocumentFullInfoCommand
): IAddNewDocumentFullInfoCommandResult;

var
    FreeCommand: IDocumentStorageServiceCommand;
    CreatingNewDocumentEmployee: TEmployee;
    FreeEmployee: IDomainObject;
    DocumentDomainObjects: TDocumentObjects;
begin

  DocumentDomainObjects := nil;
  
  FreeCommand := AddNewDocumentFullInfoCommand;
  
  RaiseExceptionIfAddNewDocumentFullInfoCommandIsNotCorrect(
    AddNewDocumentFullInfoCommand
  );

  try

    try

      FSession.Start;

      CreatingNewDocumentEmployee :=
        FEmployeeRepository.FindEmployeeById(
          AddNewDocumentFullInfoCommand.CreatingNewDocumentEmployeeId
        );

      FreeEmployee := CreatingNewDocumentEmployee;

      DocumentDomainObjects :=
        FDocumentObjectsDTODomainMapper.MapNewDocumentObjectsBy(
          AddNewDocumentFullInfoCommand.NewDocumentInfoDTO,
          CreatingNewDocumentEmployee
        );

      with DocumentDomainObjects do begin

        FDocumentDirectory.PutDocumentAndRelatedObjects(
          Document,
          DocumentRelations,
          DocumentFiles,
          DocumentResponsible
        );
        
      end;

      FSession.Commit;

      Result := CreateAddingNewDocumentFullInfoCommandResultFrom(
                  DocumentDomainObjects.Document,
                  CreatingNewDocumentEmployee
                );
    except

      on e: Exception do begin

        FSession.Rollback;

        RaiseFailedBusinessProcessServiceException(e.Message);
        
      end;

    end;

  finally

    FreeAndNil(DocumentDomainObjects);
    
  end;

end;

procedure TStandardDocumentStorageService.ChangeDocumentApprovingsInfo(
  ChangeDocumentApprovingsInfoCommand: TChangeDocumentApprovingsInfoCommand
);
var
    FreeCommand: IDocumentStorageServiceCommand;

    Document: IDocument;

    ChangingEmployee: TEmployee;
    FreeEmployee: IDomainObject;
begin

  FreeCommand := ChangeDocumentApprovingsInfoCommand;

  try

    FSession.Start;

    Document :=
      GetDocument(
        ChangeDocumentApprovingsInfoCommand.DocumentId
      );

    ChangingEmployee :=
      GetEmployee(
        ChangeDocumentApprovingsInfoCommand.ChangingEmployeeId
      );

    FreeEmployee := ChangingEmployee;

    FDocumentObjectsDTODomainMapper.ChangeDocumentApprovingsFrom(
      ChangeDocumentApprovingsInfoCommand.ChangedDocumentApprovingsInfoDTO,
      TDocument(Document.Self),
      ChangingEmployee
    );

    FDocumentDirectory.ModifyDocument(TDocument(Document.Self));
    
    FSession.Commit;
    
  except

    on e: Exception do begin

      FSession.Rollback;

      RaiseFailedBusinessProcessServiceException(e.Message);

    end;

  end;

end;

procedure TStandardDocumentStorageService.ChangeDocumentInfo(
  ChangeDocumentInfoCommand: TChangeDocumentInfoCommand
);
var
    FreeCommand: IDocumentStorageServiceCommand;

    ChangingEmployee: TEmployee;
    FreeChangingEmployee: IDomainObject;

    ChangeableDocument: IDocument;

    ChangedDocumentDomainObjects: TDocumentObjects;
begin

  ChangedDocumentDomainObjects := nil;
  
  FreeCommand := ChangeDocumentInfoCommand;

  RaiseExceptionIfChangeDocumentInfoCommandIsNotCorrect(
    ChangeDocumentInfoCommand
  );

  try

    try

      FSession.Start;

      ChangingEmployee :=
        GetEmployee(
          ChangeDocumentInfoCommand.ChangingDocumentInfoEmployeeId
        );

      FreeChangingEmployee := ChangingEmployee;

      ChangeableDocument :=
        GetDocument(
          ChangeDocumentInfoCommand.
            ChangedDocumentInfoDTO.ChangedDocumentDTO.Id
        );

      ChangedDocumentDomainObjects :=
        FDocumentObjectsDTODomainMapper.MapChangedDocumentObjectsBy(
          ChangeDocumentInfoCommand.ChangedDocumentInfoDTO,
          ChangeableDocument,
          ChangingEmployee
        );

      with ChangedDocumentDomainObjects do begin

        FDocumentDirectory.ModifyDocumentAndRelatedObjects(
          TDocument(ChangeableDocument.Self),
          DocumentRelations,
          DocumentFiles,
          DocumentResponsible
        );
        
      end;
      
      FSession.Commit;

    except

      on e: Exception do begin

        FSession.Rollback;

        RaiseFailedBusinessProcessServiceException(e.Message);
      
      end;

    end;

  finally

    FreeAndNil(ChangedDocumentDomainObjects);
    
  end;          

end;

procedure TStandardDocumentStorageService.
  RaiseExceptionIfAddNewDocumentFullInfoCommandIsNotCorrect(
    Command: TAddNewDocumentFullInfoCommand
  );
begin

  if not Assigned(Command) then begin

    RaiseFailedBusinessProcessServiceException(
      'Нераспознанная команда ' +
      'на создание нового документа. ' +
      'Ошибка программиста'
    );

  end;

  if
      not Assigned(Command.NewDocumentInfoDTO) or
      not Assigned(Command.NewDocumentInfoDTO.DocumentDTO) or
      not Assigned(Command.NewDocumentInfoDTO.DocumentDTO.AuthorDTO) or
      not Assigned(Command.NewDocumentInfoDTO.DocumentDTO.ResponsibleInfoDTO)
  then begin

    RaiseFailedBusinessProcessServiceException(
      'Попытка создать документ ' +
      'на основе неполных данных'
    );

  end;

  if
      VarIsNull(Command.CreatingNewDocumentEmployeeId) or
      VarIsEmpty(Command.CreatingNewDocumentEmployeeId)
  then begin
  
    RaiseFailedBusinessProcessServiceException(
      'Попытка создать документ ' +
      'от имени сотрудника, ' +
      'данные о котором не ' +
      'известны'
    );

  end;

end;

procedure TStandardDocumentStorageService.
  RaiseExceptionIfChangeDocumentInfoCommandIsNotCorrect(
    Command: TChangeDocumentInfoCommand
  );
begin

  if not Assigned(Command) then begin

    RaiseFailedBusinessProcessServiceException(
      'Нераспознанная команда на ' +
      'внесение изменений в документ. ' +
      'Ошибка программиста'
    );

  end;
  if not Assigned(Command.ChangedDocumentInfoDTO) and
     not Assigned(Command.ChangedDocumentInfoDTO.ChangedDocumentDTO) and
     not Assigned(Command.ChangedDocumentInfoDTO.ChangedDocumentFilesInfoDTO) and
     not Assigned(Command.ChangedDocumentInfoDTO.ChangedDocumentRelationsInfoDTO) 
  then begin

    RaiseFailedBusinessProcessServiceException(
      'Попытка внести некорректные ' +
      'изменения в документ'
    );

  end;

  if VarIsNull(Command.ChangingDocumentInfoEmployeeId) or
     VarIsEmpty(Command.ChangingDocumentInfoEmployeeId)
  then begin

    RaiseFailedBusinessProcessServiceException(
      'Попытка внести изменения ' +
      'в документ от имени ' +
      'неизвестного сотрудника'
    );

  end;

end;

procedure TStandardDocumentStorageService.RaiseExceptionIfGettingDocumentFullInfoCommandIsNotCorrect(
  Command: TGettingDocumentFullInfoCommand);
begin

  if not Assigned(Command) then begin

    RaiseFailedBusinessProcessServiceException(
      'Нераспознанная команда на ' +
      'получение полной информации ' +
      'о документе. Ошибка программиста'
    );

  end;

  if VarIsNull(Command.DocumentId) then begin

    RaiseFailedBusinessProcessServiceException(
      'Попытка получить информацию о ' +
      'неизвестном документе'
    );

  end;
  if VarIsNull(Command.RequestingEmployeeId) or
     VarIsEmpty(Command.RequestingEmployeeId)
  then begin

    RaiseFailedBusinessProcessServiceException(
      'Попытка получить информацию о ' +
      'документе для неизвестного сотрудника'
    );

  end;
  
end;

procedure TStandardDocumentStorageService.RaiseExceptionIfRemoveDocumentsInfoCommandIsNotCorrect(
  Command: TRemoveDocumentsInfoCommand);
begin

  if not Assigned(Command) then begin

    RaiseFailedBusinessProcessServiceException(
      'Нераспознанная команда на ' +
      'удаление документов. Ошибка ' +
      'программиста'
    );

  end;

  if not Assigned(Command.RemovableDocumentIds) or
     Command.RemovableDocumentIds.IsEmpty
  then begin

    RaiseFailedBusinessProcessServiceException(
      'Не были заданы документы,' +
      ' которые требуется удалить'
    );

  end;

  if VarIsNull(Command.RemovingDocumentsInfoEmployeeId) or
     VarIsEmpty(Command.RemovingDocumentsInfoEmployeeId)
  then begin

    RaiseFailedBusinessProcessServiceException(
      'Попытка удалить документы ' +
      'от имени неизвестного сотрудника'
    );

  end;
  
end;

procedure TStandardDocumentStorageService.RemoveDocumentsInfo(
  RemoveDocumentsInfoCommand: TRemoveDocumentsInfoCommand
);
var FreeCommand: IDocumentStorageServiceCommand;
    RemovingEmployeeId: Variant;
    RemovableDocumentIds: TVariantList;
    RemovingEmployee: TEmployee;
    FreeRemovingEmployee: IDomainObject;
begin

  FreeCommand := RemoveDocumentsInfoCommand;

  RaiseExceptionIfRemoveDocumentsInfoCommandIsNotCorrect(
    RemoveDocumentsInfoCommand
  );

  RemovingEmployeeId :=
    RemoveDocumentsInfoCommand.RemovingDocumentsInfoEmployeeId;

  RemovableDocumentIds :=
    RemoveDocumentsInfoCommand.RemovableDocumentIds;
    
  try

    FSession.Start;

    RemovingEmployee := GetEmployee(RemovingEmployeeId);

    FreeRemovingEmployee := RemovingEmployee;

    RemoveDocuments(RemovableDocumentIds, RemovingEmployee);

    FSession.Commit;
    
  except

    on e: Exception do begin

      FSession.Rollback;

      RaiseFailedBusinessProcessServiceException(e.Message);
      
    end;

  end;
  
end;

procedure TStandardDocumentStorageService.RegisterDocumentForEmployeeIfNecessary(
  Document: TDocument);
begin

end;

procedure TStandardDocumentStorageService.RemoveDocuments(
  RemovableDocumentIds: TVariantList;
  RemovingEmployee: TEmployee
);
var
    RemovableDocuments: TDocuments;
    FreeDocuments: IDomainObjectList;
begin

  RemovableDocuments := GetDocuments(RemovableDocumentIds);

  FreeDocuments := RemovableDocuments;

  EnsureEmployeeMayRemoveDocuments(RemovingEmployee, RemovableDocuments);

  FDocumentDirectory.RemoveDocuments(RemovableDocuments);

end;

procedure TStandardDocumentStorageService.EnsureEmployeeMayRemoveDocuments(
  RemovingEmployee: TEmployee;
  RemovableDocuments: TDocuments
);
var
    RemovableDocument: TDocument;
begin

  for RemovableDocument in RemovableDocuments do
    EnsureEmployeeMayRemoveDocument(RemovingEmployee, RemovableDocument);

end;

end.
