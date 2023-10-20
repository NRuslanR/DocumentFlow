unit StandardDocumentChargeSheetControlAppService;

interface

uses

  DocumentChargeSheetControlService,
  DocumentChargeSheetControlAppService,
  DocumentChargeSheet,
  DocumentDirectory,
  IEmployeeRepositoryUnit,
  DocumentPerformingService,
  IDocumentChargeSheetUnit,
  DocumentChargeSheetDirectory,
  DocumentChargeSheetsChangesInfoDTO,
  DocumentChargeSheetInfoDTODomainMapperRegistry,
  DocumentChargeSheetsInfoDTO,
  DomainException,
  MessagingServiceUnit,
  Document,
  Employee,
  IDocumentUnit,
  IDomainObjectUnit,
  IDomainObjectListUnit,
  DocumentChargeSheetNotifyingMessageBuilder,
  Session,
  DocumentChargeSheetCasesNotifier,
  DocumentChargeSheetAccessRights,
  DocumentChargeSheetInfoDTODomainMapper,
  ApplicationService,
  BusinessProcessService,
  DocumentChargeSheetPerformingResult,
  VariantListUnit,
  ArrayTypes,
  SysUtils,
  Classes;

type

  TDocumentChargeSheetsChanges = class

    private

      FreeSavingChangesEmployee: IDomainObject;
      FreeNewDocumentChargeSheets: IDomainObjectList;
      FreeChangedDocumentChargeSheets: IDomainObjectList;
      FreeRemovedDocumentChargeSheets: IDomainObjectList;

    private

      SavingChangesEmployee: TEmployee;
      NewDocumentChargeSheets: TDocumentChargeSheets;
      ChangedDocumentChargeSheets: TDocumentChargeSheets;
      RemovedDocumentChargeSheets: TDocumentChargeSheets;

      destructor Destroy; override;
      
      constructor Create; overload;
      constructor Create(
        SavingChangesEmployee: TEmployee;
        NewDocumentChargeSheets: TDocumentChargeSheets;
        ChangedDocumentChargeSheets: TDocumentChargeSheets;
        RemovedDocumentChargeSheets: TDocumentChargeSheets
      ); overload;

  end;

  TStandardDocumentChargeSheetControlAppService =
    class (
      TBusinessProcessService,
      IDocumentChargeSheetControlAppService
    )

      protected

        FDocumentDirectory: IDocumentDirectory;
        FEmployeeRepository: IEmployeeRepository;
        FDocumentChargeSheetControlService: IDocumentChargeSheetControlService;
        FDocumentChargeSheetCasesNotifier: IDocumentChargeSheetCasesNotifier;

        FDocumentChargeSheetInfoDTODomainMapperRegistry:
          IDocumentChargeSheetInfoDTODomainMapperRegistry;

      protected

        function GetDocumentOrRaise(
          const DocumentId: Variant;
          const ErrorMessage: String = ''
        ): IDocument;

        function GetEmployeeOrRaise(
          const EmployeeId: Variant;
          const ErrorMessage: String = ''
        ): TEmployee;

        function GetEmployeesOrRaise(
          const EmployeeIds: array of Variant;
          const ErrorMessage: String = ''
        ): TEmployees;

        procedure GetOrRaise(
          const IdNames: array of String;
          const Ids: array of Variant;
          var Objs: Variant
        );

        procedure GetDocumentChargeSheetOrRaise(
          const DocumentChargeSheetId: Variant;
          const EmployeeId: Variant;
          var ChargeSheet: IDocumentChargeSheet;
          var AccessRights: TDocumentChargeSheetAccessRights;
          const ErrorMessage: String = ''
        ); overload;

        procedure GetDocumentChargeSheetOrRaise(
          const DocumentChargeSheetId: Variant;
          const EmployeeId: Variant;
          var ChargeSheet: IDocumentChargeSheet;
          var AccessRights: TDocumentChargeSheetAccessRights;
          var Employee: TEmployee;
          const ErrorMessage: String = ''
        ); overload;

        procedure GetDocumentChargeSheetOrRaise(
          const DocumentChargeSheetId: Variant;
          const EmployeeId: Variant;
          var ChargeSheet: IDocumentChargeSheet;
          var Employee: TEmployee;
          const ErrorMessage: String = ''
        ); overload;

        procedure GetDocumentChargeSheetOrRaise(
          const DocumentChargeSheetId: Variant;
          Employee: TEmployee;
          var ChargeSheet: IDocumentChargeSheet;
          var AccessRights: TDocumentChargeSheetAccessRights;
          const ErrorMessage: String = ''
        ); overload;

        function GetDocumentChargeSheetInfoDTOMapper(
          ChargeSheetType: TDocumentChargeSheetClass
        ): IDocumentChargeSheetInfoDTODomainMapper;

      protected

        procedure SendNotificationsAboutDocumentChargeSheetsChanges(
          DocumentChargeSheetsChanges: TDocumentChargeSheetsChanges;
          OriginalDocumentChargeSheetsChangesInfoDTO: TDocumentChargeSheetsChangesInfoDTO
        );

        procedure OnDocumentChargeSheetNotificationSentEventHandler(
          Sender: TObject;
          DocumentChargeSheetNotificationCase: TDocumentChargeSheetsNotificationCase
        );

        procedure OnDocumentChargeSheetNotificationSendingFailedEventHandler(
          Sender: TObject;
          const Error: Exception;
          DocumentChargeSheetNotificationCase: TDocumentChargeSheetsNotificationCase
        );

      protected

        procedure RaiseExceptionIfSavingDocumentChargeSheetChangesCommandIsNotCorrect(
          Command: TSavingDocumentChargeSheetChangesCommand
        );
        
      protected

        function CreateNewDocumentChargeSheetsFrom(
          AddedDocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO;
          const DocumentId: Variant;
          AddingEmployee: TEmployee
        ): TDocumentChargeSheets;

        function CreateChangedDocumentChargeSheetsFrom(
          ChangedDocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO;
          ChangingEmployee: TEmployee
        ): TDOcumentChargeSheets;

        function CreateRemovedDocumentChargeSheetsFrom(
          RemovedDocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO;
          RemovingEmployee: TEmployee
        ): TDocumentChargeSheets;

      private

        function DoCreateHeadChargeSheet(
          const DocumentId: Variant;
          const PerformerId: Variant;
          const IssuerId: Variant
        ): TDocumentChargeSheetInfoDTO; overload;

        function DoCreateSubordinateChargeSheet(
          const DocumentId: Variant;
          const PerformerId: Variant;
          const IssuerId: Variant;
          const TopLevelChargeSheetId: Variant
        ): TDocumentChargeSheetInfoDTO; overload;

        function DoCreateHeadChargeSheet(
          const ChargeKindId: Variant;
          const DocumentId: Variant;
          const PerformerId: Variant;
          const IssuerId: Variant
        ): TDocumentChargeSheetInfoDTO; overload;

        function DoCreateSubordinateChargeSheet(
          const ChargeKindId: Variant;
          const DocumentId: Variant;
          const PerformerId: Variant;
          const IssuerId: Variant;
          const TopLevelChargeSheetId: Variant
        ): TDocumentChargeSheetInfoDTO; overload;

      private

        procedure SaveDocumentChargeSheetPerformingResult(
          PerformingResult: TDocumentChargeSheetPerformingResult;
          Employee: TEmployee
        );

        function DoSaveDocumentChargeSheetsChanges(
          const SavingChangesEmployeeId: Variant;
          const DocumentId: Variant;
          ChargeSheetsChangesInfoDTO: TDocumentChargeSheetsChangesInfoDTO
        ): TDocumentChargeSheetsChanges;

      public

        constructor Create(
          Session: ISession;
          DocumentDirectory: IDocumentDirectory;
          EmployeeRepository: IEmployeeRepository;
          DocumentChargeSheetControlService: IDocumentChargeSheetControlService;
          DocumentChargeSheetCasesNotifier: IDocumentChargeSheetCasesNotifier;
          DocumentChargeSheetInfoDTODomainMapperRegistry:
            IDocumentChargeSheetInfoDTODomainMapperRegistry
        );

        function GetChargeSheet(
          const ChargeSheetId: Variant;
          const EmployeeId: Variant
        ): TDocumentChargeSheetInfoDTO;

        function CreateHeadChargeSheet(
          const DocumentId: Variant;
          const PerformerId: Variant;
          const IssuerId: Variant
        ): TDocumentChargeSheetInfoDTO; overload;

        function CreateSubordinateChargeSheet(
          const DocumentId: Variant;
          const PerformerId: Variant;
          const IssuerId: Variant;
          const TopLevelChargeSheetId: Variant
        ): TDocumentChargeSheetInfoDTO; overload;

        function CreateHeadChargeSheet(
          const ChargeKindId: Variant;
          const DocumentId: Variant;
          const PerformerId: Variant;
          const IssuerId: Variant
        ): TDocumentChargeSheetInfoDTO; overload;

        function CreateSubordinateChargeSheet(
          const ChargeKindId: Variant;
          const DocumentId: Variant;
          const PerformerId: Variant;
          const IssuerId: Variant;
          const TopLevelChargeSheetId: Variant
        ): TDocumentChargeSheetInfoDTO; overload;

        procedure PerformChargeSheet(
          const EmployeeId: Variant;
          const ChargeSheetId: Variant
        );

        procedure PerformChargeSheets(
          const EmployeeId: Variant;
          const ChargeSheetIds: TVariantList
        );

        procedure SaveDocumentChargeSheetsChanges(
          Command: TSavingDocumentChargeSheetChangesCommand
        );

    end;

implementation

uses

  Variants,
  VariantFunctions,
  DocumentRuleRegistry,
  IDomainObjectBaseListUnit,
  IDomainObjectBaseUnit,
  AuxDebugFunctionsUnit,
  AuxiliaryFunctionsForExceptionHandlingUnit;

{ TStandardDocumentChargeSheetControlAppService }

constructor TStandardDocumentChargeSheetControlAppService.Create(
  Session: ISession;
  DocumentDirectory: IDocumentDirectory;
  EmployeeRepository: IEmployeeRepository;
  DocumentChargeSheetControlService: IDocumentChargeSheetControlService;
  DocumentChargeSheetCasesNotifier: IDocumentChargeSheetCasesNotifier;
  DocumentChargeSheetInfoDTODomainMapperRegistry:
    IDocumentChargeSheetInfoDTODomainMapperRegistry
);
begin

  inherited Create(Session);

  FDocumentDirectory := DocumentDirectory;
  FEmployeeRepository := EmployeeRepository;
  FDocumentChargeSheetControlService := DocumentChargeSheetControlService;
  FDocumentChargeSheetCasesNotifier := DocumentChargeSheetCasesNotifier;

  FDocumentChargeSheetInfoDTODomainMapperRegistry :=
    DocumentChargeSheetInfoDTODomainMapperRegistry;

end;

function TStandardDocumentChargeSheetControlAppService.CreateSubordinateChargeSheet(
  const DocumentId, PerformerId, IssuerId, TopLevelChargeSheetId: Variant
): TDocumentChargeSheetInfoDTO;
begin

  FSession.Start;

  try

    Result :=
      DoCreateSubordinateChargeSheet(
        DocumentId, PerformerId, IssuerId, TopLevelChargeSheetId
      );

    FSession.Commit;

  except

    On E: Exception do begin

      if E is TDomainException then
        RaiseFailedBusinessProcessServiceException(E.Message);

      Raise;

    end;

  end;

end;

function TStandardDocumentChargeSheetControlAppService.CreateSubordinateChargeSheet(
  const ChargeKindId, DocumentId, PerformerId, IssuerId,
  TopLevelChargeSheetId: Variant): TDocumentChargeSheetInfoDTO;
begin

  FSession.Start;

  try

    Result :=
      DoCreateSubordinateChargeSheet(
        ChargeKindId, DocumentId, PerformerId, IssuerId, TopLevelChargeSheetId
      );
    
    FSession.Commit;

  except

    On E: Exception do begin

      if E is TDomainException then
        RaiseFailedBusinessProcessServiceException(E.Message);

      Raise;

    end;

  end;

end;

function TStandardDocumentChargeSheetControlAppService.DoCreateHeadChargeSheet(
  const
    ChargeKindId,
    DocumentId,
    PerformerId,
    IssuerId: Variant
): TDocumentChargeSheetInfoDTO;
var
    Objects: Variant;

    Document: IDocument;

    Performer, Issuer: TEmployee;
    FreePerformer, FreeIssuer: IDomainObjectBase;

    ChargeSheet: IDocumentChargeSheet;
    ChargeSheetObj: TDocumentChargeSheet;

    AccessRights: TDocumentChargeSheetAccessRights;
    FreeAccessRights: IDomainObjectBase;
    
    ChargeSheetInfoDTOMapper: IDocumentChargeSheetInfoDTODomainMapper;
begin

  ChargeSheetObj := TDocumentChargeSheet(ChargeSheet.Self);
  
  GetOrRaise(
    ['Document', 'Performer', 'Issuer'],
    [DocumentId, PerformerId, IssuerId],
    Objects
  );

  Document := IDocument(VariantToPointer(Objects[0]));

  Performer := TEmployee(VariantToObject(Objects[1]));
  FreePerformer := Performer;

  Issuer := TEmployee(VariantToObject(Objects[2]));
  FreeIssuer := Issuer;
  
  FDocumentChargeSheetControlService.CreateHeadChargeSheet(
    ChargeKindId, Document, Performer, Issuer, ChargeSheet, AccessRights
  );

  FreeAccessRights := AccessRights;

  ChargeSheetInfoDTOMapper :=
    GetDocumentChargeSheetInfoDTOMapper(ChargeSheetObj.ClassType);

  Result :=
    ChargeSheetInfoDTOMapper
      .MapDocumentChargeSheetInfoDTOFrom(ChargeSheetObj, AccessRights);

end;

function TStandardDocumentChargeSheetControlAppService.DoCreateHeadChargeSheet(
  const
    DocumentId,
    PerformerId,
    IssuerId: Variant
  ): TDocumentChargeSheetInfoDTO;
var
    Objects: Variant;

    Document: IDocument;

    Performer, Issuer: TEmployee;
    FreePerformer, FreeIssuer: IDomainObjectBase;

    ChargeSheet: IDocumentChargeSheet;
    ChargeSheetObj: TDocumentChargeSheet;

    AccessRights: TDocumentChargeSheetAccessRights;
    FreeAccessRights: IDomainObjectBase;

    ChargeSheetInfoDTOMapper: IDocumentChargeSheetInfoDTODomainMapper;
begin

  ChargeSheetObj := TDocumentChargeSheet(ChargeSheet.Self);
  
  GetOrRaise(
    ['Document', 'Performer', 'Issuer'],
    [DocumentId, PerformerId, IssuerId],
    Objects
  );

  Document := IDocument(VariantToPointer(Objects[0]));

  Performer := TEmployee(VariantToObject(Objects[1]));
  FreePerformer := Performer;

  Issuer := TEmployee(VariantToObject(Objects[2]));
  FreeIssuer := Issuer;

  FDocumentChargeSheetControlService.CreateHeadChargeSheet(
    Document, Performer, Issuer, ChargeSheet, AccessRights
  );

  FreeAccessRights := AccessRights;

  ChargeSheetInfoDTOMapper :=
    GetDocumentChargeSheetInfoDTOMapper(ChargeSheetObj.ClassType);

  Result :=
    ChargeSheetInfoDTOMapper
      .MapDocumentChargeSheetInfoDTOFrom(ChargeSheetObj, AccessRights);

end;

function TStandardDocumentChargeSheetControlAppService.
  DoCreateSubordinateChargeSheet(
    const ChargeKindId, DocumentId,
    PerformerId, IssuerId,
    TopLevelChargeSheetId: Variant
  ): TDocumentChargeSheetInfoDTO;
var
    Objects: Variant;

    Document: IDocument;

    Performer, Issuer: TEmployee;
    FreePerformer, FreeIssuer: IDomainObjectBase;

    TopLevelChargeSheet: IDocumentChargeSheet;

    TopLevelChargeSheetAccessRights: TDocumentChargeSheetAccessRights;
    FreeTopLevelChargeSheetAccessRights: IDomainObjectBase;
    
    ChargeSheet: IDocumentChargeSheet;
    ChargeSheetObj: TDocumentChargeSheet;
    
    AccessRights: TDocumentChargeSheetAccessRights;
    FreeAccessRights: IDomainObjectBase;

    ChargeSheetInfoDTOMapper: IDocumentChargeSheetInfoDTODomainMapper;
begin

  ChargeSheetObj := TDocumentChargeSheet(ChargeSheet.Self);

  GetOrRaise(
    ['Document', 'Performer', 'Issuer'],
    [DocumentId, PerformerId, IssuerId],
    Objects
  );

  Document := IDocument(VariantToPointer(Objects[0]));

  Performer := TEmployee(VariantToObject(Objects[1]));
  FreePerformer := Performer;

  Issuer := TEmployee(VariantToObject(Objects[2]));
  FreeIssuer := Issuer;

  GetDocumentChargeSheetOrRaise(
    TopLevelChargeSheetId, Issuer,
    TopLevelChargeSheet, TopLevelChargeSheetAccessRights,
    Format(
      '¬ышесто€щее поручение дл€ сотрудника "%s" не найдено',
      [
        Issuer.FullName
      ]
    )
  );

  FreeTopLevelChargeSheetAccessRights := TopLevelChargeSheetAccessRights;
  
  FDocumentChargeSheetControlService.CreateSubordinateChargeSheet(
    ChargeKindId, Document, Performer,
    Issuer, TopLevelChargeSheet, ChargeSheet, AccessRights
  );

  FreeAccessRights := AccessRights;

  ChargeSheetInfoDTOMapper :=
    GetDocumentChargeSheetInfoDTOMapper(ChargeSheetObj.ClassType);

  Result :=
    ChargeSheetInfoDTOMapper
      .MapDocumentChargeSheetInfoDTOFrom(ChargeSheetObj, AccessRights);

end;

function TStandardDocumentChargeSheetControlAppService.DoCreateSubordinateChargeSheet(
  const
    DocumentId,
    PerformerId,
    IssuerId,
    TopLevelChargeSheetId: Variant
  ): TDocumentChargeSheetInfoDTO;
var
    Objects: Variant;

    Document: IDocument;

    Performer, Issuer: TEmployee;
    FreePerformer, FreeIssuer: IDomainObjectBase;

    TopLevelChargeSheet: IDocumentChargeSheet;

    TopLevelChargeSheetAccessRights: TDocumentChargeSheetAccessRights;
    FreeTopLevelChargeSheetAccessRights: IDomainObjectBase;

    ChargeSheet: IDocumentChargeSheet;
    ChargeSheetObj: TDocumentChargeSheet;

    AccessRights: TDocumentChargeSheetAccessRights;
    FreeAccessRights: IDomainObjectBase;

    ChargeSheetInfoDTOMapper: IDocumentChargeSheetInfoDTODomainMapper;
begin

  ChargeSheetObj := TDocumentChargeSheet(ChargeSheet.Self);
  
  GetOrRaise(
    ['Document', 'Performer', 'Issuer'],
    [DocumentId, PerformerId, IssuerId],
    Objects
  );

  Document := IDocument(VariantToPointer(Objects[0]));

  Performer := TEmployee(VariantToObject(Objects[1]));
  FreePerformer := Performer;

  Issuer := TEmployee(VariantToObject(Objects[2]));
  FreeIssuer := Issuer;

  GetDocumentChargeSheetOrRaise(
    TopLevelChargeSheetId, Issuer,
    TopLevelChargeSheet, TopLevelChargeSheetAccessRights
  );

  FreeTopLevelChargeSheetAccessRights := TopLevelChargeSheetAccessRights;
  
  FDocumentChargeSheetControlService.CreateSubordinateChargeSheet(
    Document, Performer, Issuer, TopLevelChargeSheet, ChargeSheet, AccessRights
  );

  FreeAccessRights := AccessRights;

  ChargeSheetInfoDTOMapper :=
    GetDocumentChargeSheetInfoDTOMapper(ChargeSheetObj.ClassType);

  Result :=
    ChargeSheetInfoDTOMapper
      .MapDocumentChargeSheetInfoDTOFrom(ChargeSheetObj, AccessRights);

end;

function TStandardDocumentChargeSheetControlAppService.GetChargeSheet(
  const
    ChargeSheetId,
    EmployeeId: Variant
  ): TDocumentChargeSheetInfoDTO;
var
    ChargeSheet: IDocumentChargeSheet;

    AccessRights: TDocumentChargeSheetAccessRights;
    FreeAccessRights: IDomainObjectBase;
    
    ChargeSheetInfoDTOMapper: TDocumentChargeSheetInfoDTODomainMapper;
begin

  GetDocumentChargeSheetOrRaise(
    ChargeSheetId, EmployeeId, ChargeSheet, AccessRights
  );

  FreeAccessRights := AccessRights;

  Result :=
    ChargeSheetInfoDTOMapper
      .MapDocumentChargeSheetInfoDTOFrom(
        TDocumentChargeSheet(ChargeSheet.Self),
        AccessRights
      );

end;

procedure TStandardDocumentChargeSheetControlAppService
  .GetDocumentChargeSheetOrRaise(
    const DocumentChargeSheetId: Variant;
    const EmployeeId: Variant;
    var ChargeSheet: IDocumentChargeSheet;
    var AccessRights: TDocumentChargeSheetAccessRights;
    const ErrorMessage: String
  );
var
    Employee: TEmployee;
    FreeEmployee: IDomainObjectBase;
begin

  GetDocumentChargeSheetOrRaise(
    DocumentChargeSheetId,
    EmployeeId,
    ChargeSheet,
    AccessRights,
    Employee
  );

  FreeEmployee := Employee;

end;

procedure TStandardDocumentChargeSheetControlAppService
  .GetDocumentChargeSheetOrRaise(
    const DocumentChargeSheetId: Variant;
    const EmployeeId: Variant;
    var ChargeSheet: IDocumentChargeSheet;
    var Employee: TEmployee;
    const ErrorMessage: String
  );
begin

  Employee := GetEmployeeOrRaise(EmployeeId, '«апрашивающий сотрудник не найден');

  try                                   

    ChargeSheet :=
      FDocumentChargeSheetControlService.GetChargeSheet(
        Employee, DocumentChargeSheetId
      );

    if not Assigned(ChargeSheet) then
      Raise TDocumentChargeSheetControlAppServiceException.Create(ErrorMessage);
      
  except

    FreeAndNil(Employee);

    Raise;

  end;

end;

procedure TStandardDocumentChargeSheetControlAppService
  .GetDocumentChargeSheetOrRaise(
    const DocumentChargeSheetId: Variant;
    const EmployeeId: Variant;
    var ChargeSheet: IDocumentChargeSheet;
    var AccessRights: TDocumentChargeSheetAccessRights;
    var Employee: TEmployee;
    const ErrorMessage: String
  );
begin


  Employee :=
    GetEmployeeOrRaise(
      EmployeeId,
      'ƒл€ выборки поручени€ не найден запрашивающий сотрудник'
    );

  try

    GetDocumentChargeSheetOrRaise(
      DocumentChargeSheetId, Employee, ChargeSheet, AccessRights
    );

  except

    FreeAndNil(Employee);

    Raise;

  end;

end;

procedure TStandardDocumentChargeSheetControlAppService.
  GetDocumentChargeSheetOrRaise(
    const DocumentChargeSheetId: Variant;
    Employee: TEmployee;
    var ChargeSheet: IDocumentChargeSheet;
    var AccessRights: TDocumentChargeSheetAccessRights;
    const ErrorMessage: String
  );
begin

  FDocumentChargeSheetControlService.GetChargeSheet(
    Employee, DocumentChargeSheetId, ChargeSheet, AccessRights
  );

  if not Assigned(ChargeSheet) then
    Raise TDocumentChargeSheetControlAppServiceException(ErrorMessage);

end;

function TStandardDocumentChargeSheetControlAppService.GetDocumentChargeSheetInfoDTOMapper(
  ChargeSheetType: TDocumentChargeSheetClass
): IDocumentChargeSheetInfoDTODomainMapper;
begin

  Result :=
    FDocumentChargeSheetInfoDTODomainMapperRegistry
      .GetDocumentChargeSheetInfoDTODomainMapper(
        ChargeSheetType
      );

  if not Assigned(Result) then begin
  
    Raise TDocumentChargeSheetControlAppServiceException.Create(
      'ƒл€ типа поручени€ не найден соответствующий преобразователь'
    );

  end;

end;

function TStandardDocumentChargeSheetControlAppService.
  GetDocumentOrRaise(
    const DocumentId: Variant;
    const ErrorMessage: String
  ): IDocument;
begin

  Result := FDocumentDirectory.FindDocumentById(DocumentId);

  if not Assigned(Result) then
    Raise TDocumentChargeSheetControlAppServiceException.Create(ErrorMessage);

end;

function TStandardDocumentChargeSheetControlAppService.
  GetEmployeeOrRaise(
    const EmployeeId: Variant;
    const ErrorMessage: String
  ): TEmployee;
begin

  Result := FEmployeeRepository.FindEmployeeById(EmployeeId);

  if not Assigned(Result) then
    Raise TDocumentChargeSheetControlAppServiceException.Create(ErrorMessage);
  
end;

function TStandardDocumentChargeSheetControlAppService
  .GetEmployeesOrRaise(
    const EmployeeIds: array of Variant;
    const ErrorMessage: String
  ): TEmployees;
var
    EmployeeIdList: TVariantList;
begin
                                                                  
  EmployeeIdList := TVariantList.CreateFrom(EmployeeIds);

  try

    Result := FEmployeeRepository.FindEmployeesByIdentities(EmployeeIdList);

    if not Assigned(Result) or (EmployeeIdList.Count <> Result.Count) then
      Raise TDocumentChargeSheetControlAppServiceException.Create(ErrorMessage);

  finally

    FreeAndNil(EmployeeIdList);

  end;

end;

procedure TStandardDocumentChargeSheetControlAppService.GetOrRaise(
  const IdNames: array of String;
  const Ids: array of Variant;
  var Objs: Variant
);
var
    I, J: Integer;
    Employees: TEmployees;
    FreeEmployees: IDomainObjectBaseList;
begin

  Objs := VarArrayCreate([Low(IdNames), High(IdNames) + 1], varArray);

  J := Low(IdNames);

  for I := Low(IdNames) to High(IdNames) do begin

    if IdNames[I] = 'Document' then begin

      Objs[J] :=
        InterfaceToVariant(
          GetDocumentOrRaise(
            Ids[I],
            'ѕри выполнении действий с поручени€ми не найден документ'
          )
        );

    end

    else if IdNames[I] = 'Issuer' then begin

      Objs[J] :=
        ObjectToVariant(
          GetEmployeeOrRaise(
            Ids[I],
            'ѕри выполнении действий с поручени€ми не найден автор поручени€'
          )
        );

    end

    else if IdNames[I] = 'Performer' then begin

      Objs[J] :=
        ObjectToVariant(
          GetEmployeeOrRaise(
            Ids[I],
            'ѕри выполнении действий с поручени€ми не найден исполнитель'
          )
        );

    end

    else if IdNames[I] = 'IssuerPerformer' then begin

      Employees :=
          GetEmployeesOrRaise(
            [Ids[I], Ids[I + 1]],
            'ѕри выполнении действий с поручени€ми ' +
            'не найдены автор поручени€ и исполнитель'
          );

      FreeEmployees := Employees;

      Objs[J] := ObjectToVariant(TEmployee(Employees.FindEmployeeByIdentity(Ids[I]).Clone));
      Objs[J + 1] := ObjectToVariant(TEmployee(Employees.FindEmployeeByIdentity(Ids[I + 1]).Clone));
      
    end;

    Inc(J);

  end;

end;

procedure TStandardDocumentChargeSheetControlAppService.
  OnDocumentChargeSheetNotificationSendingFailedEventHandler(
    Sender: TObject;
    const Error: Exception;
    DocumentChargeSheetNotificationCase: TDocumentChargeSheetsNotificationCase
);
begin

  RaiseSuccessedBusinessProcessServiceException(Error.Message);
  
end;

procedure TStandardDocumentChargeSheetControlAppService.OnDocumentChargeSheetNotificationSentEventHandler(
  Sender: TObject;
  DocumentChargeSheetNotificationCase: TDocumentChargeSheetsNotificationCase
);
begin

end;

procedure TStandardDocumentChargeSheetControlAppService
  .PerformChargeSheet(
    const EmployeeId, ChargeSheetId: Variant
  );
var
    ChargeSheet: IDocumentChargeSheet;

    Employee: TEmployee;
    FreeEmployee: IDomainObjectBase;

    PerformingResult: TDocumentChargeSheetPerformingResult;
    FreePerformingResult: IDomainObjectBase;
begin

  GetDocumentChargeSheetOrRaise(
    ChargeSheetId, EmployeeId,
    ChargeSheet, Employee
  );

  FreeEmployee := Employee;

  PerformingResult :=
    FDocumentChargeSheetControlService.PerformChargeSheet(
      Employee, ChargeSheet
    );

  FreePerformingResult := PerformingResult;

  SaveDocumentChargeSheetPerformingResult(PerformingResult, Employee);

end;

procedure TStandardDocumentChargeSheetControlAppService.PerformChargeSheets(
  const EmployeeId: Variant;
  const ChargeSheetIds: TVariantList
);
var
    Employee: TEmployee;
    FreeEmployee: IDomainObjectBase;

    ChargeSheets: TDocumentChargeSheets;
    FreeChargeSheets: IDomainObjectBaseList;

    PerformingResult: TDocumentChargeSheetPerformingResult;
    FreePerformingResult: IDomainObjectBase;
begin

  if ChargeSheetIds.IsEmpty then begin

    Raise TDocumentChargeSheetControlAppServiceException.Create(
      'Ќе переданы поручени€ дл€ выполнени€'
    );

  end;

  Employee :=
    GetEmployeeOrRaise(
      EmployeeId,
      'Ќе найден запрашивающий сотрудник во врем€ выполнени€ поручений'
    );

  FreeEmployee := Employee;

  ChargeSheets :=
    FDocumentChargeSheetControlService
      .GetChargeSheets(Employee, ChargeSheetIds);

  FreeChargeSheets := ChargeSheets;

  if not Assigned(ChargeSheets) then begin

    Raise TDocumentChargeSheetControlAppServiceException.Create(
      'ѕоручени€ не найдены дл€ выполнени€'
    );
    
  end;

  PerformingResult :=
    FDocumentChargeSheetControlService.PerformChargeSheets(
      Employee, ChargeSheets
    );

  FreePerformingResult := PerformingResult;

  SaveDocumentChargeSheetPerformingResult(PerformingResult, Employee);

end;

procedure TStandardDocumentChargeSheetControlAppService
  .SaveDocumentChargeSheetPerformingResult(
    PerformingResult: TDocumentChargeSheetPerformingResult;
    Employee: TEmployee
  );
begin

  FSession.Start;

  try

    with PerformingResult do begin

      FDocumentChargeSheetControlService.SaveChargeSheets(
        Employee,
        TDocumentChargeSheets(PerformedChargeSheets.Self)
      );

      if Assigned(PerformedDocument) then
      begin

        FDocumentDirectory.ModifyDocument(TDocument(PerformedDocument.Self));

      end;

      FSession.Commit;

    end;

  except

    on E: Exception do begin

      FSession.Rollback;

      if E is TDomainException then
        RaiseFailedBusinessProcessServiceException(E.Message);

      Raise;

    end;

  end;

end;

procedure TStandardDocumentChargeSheetControlAppService.
  RaiseExceptionIfSavingDocumentChargeSheetChangesCommandIsNotCorrect(
    Command: TSavingDocumentChargeSheetChangesCommand
  );
begin

  if not Assigned(Command) then begin

    RaiseFailedBusinessProcessServiceException(
      'Ќе распознана комманда ' +
      'на изменение информации о ' +
      'поручени€х на документ'
    );

  end;

  if VarIsNull(Command.SavingChangesEmployeeId) then begin

    RaiseFailedBusinessProcessServiceException(
      'ѕопытка изменени€ информации ' +
      'о поручени€х на документ от ' +
      'имени неизвестного сотрудника'
    );

  end;

  if not Assigned(Command.DocumentChargeSheetsChangesInfoDTO) and
     not Assigned(Command.DocumentChargeSheetsChangesInfoDTO.AddedDocumentChargeSheetsInfoDTO) and
     not Assigned(Command.DocumentChargeSheetsChangesInfoDTO.ChangedDocumentChargeSheetsInfoDTO) and
     not Assigned(Command.DocumentChargeSheetsChangesInfoDTO.RemovedDocumentChargeSheetsInfoDTO)
  then begin

    RaiseFailedBusinessProcessServiceException(
      '»зменений в поручени€х ' +
      'на документ обнаружено не было'
    );

  end;

end;

procedure TStandardDocumentChargeSheetControlAppService.
  SaveDocumentChargeSheetsChanges(
    Command: TSavingDocumentChargeSheetChangesCommand
  );
var
    FreeCommand: IDocumentChargeSheetControlAppServiceCommand;
    DocumentChargeSheetsChanges: TDocumentChargeSheetsChanges;
begin

  FreeCommand := Command;

  DocumentChargeSheetsChanges := nil;
  
  RaiseExceptionIfSavingDocumentChargeSheetChangesCommandIsNotCorrect(
    Command
  );

  try

    try

      FSession.Start;

      DocumentChargeSheetsChanges :=
        DoSaveDocumentChargeSheetsChanges(
          Command.SavingChangesEmployeeId,
          Command.DocumentId,
          Command.DocumentChargeSheetsChangesInfoDTO
        );

      FSession.Commit;
      
    except

      on e: Exception do begin

        FSession.Rollback;

        if e is TDomainException then
          RaiseFailedBusinessProcessServiceException(e.Message);

        raise;

      end;

    end;

    try

      SendNotificationsAboutDocumentChargeSheetsChanges(
        DocumentChargeSheetsChanges,
        Command.DocumentChargeSheetsChangesInfoDTO
      );

    except

      on e: Exception do begin
                 
        RaiseSuccessedBusinessProcessServiceException(e.Message);
        
      end;

    end;

  finally

    FreeAndNil(DocumentChargeSheetsChanges);
    
  end;

end;

function TStandardDocumentChargeSheetControlAppService
  .DoSaveDocumentChargeSheetsChanges(
    const SavingChangesEmployeeId: Variant;
    const DocumentId: Variant;
    ChargeSheetsChangesInfoDTO: TDocumentChargeSheetsChangesInfoDTO
  ): TDocumentChargeSheetsChanges;
var
    SavingChangesEmployee: TEmployee;
    NewDocumentChargeSheets: TDocumentChargeSheets;
    ChangedDocumentChargeSheets: TDocumentChargeSheets;
    DocumentChargeSheetsForSaving: TDocumentChargeSheets;
    RemovedDocumentChargeSheets: TDocumentChargeSheets;

    FreeSavingChangesEmployee: IDomainObject;
    FreeNewDocumentChargeSheets: IDomainObjectList;
    FreeChangedDocumentChargeSheets: IDomainObjectList;
    FreeDocumentChargeSheetsForSaving: IDomainObjectList;
    FreeRemovedDocumentChargeSheets: IDomainObjectList;
begin

  SavingChangesEmployee :=
    GetEmployeeOrRaise(
      SavingChangesEmployeeId,
      'Ќе найден запрашивающий сотрудник во врем€ ' +
      'сохранени€ изменений по поручени€м'
    );

  FreeSavingChangesEmployee := SavingChangesEmployee;

  NewDocumentChargeSheets :=
    CreateNewDocumentChargeSheetsFrom(
      ChargeSheetsChangesInfoDTO.AddedDocumentChargeSheetsInfoDTO,
      DocumentId,
      SavingChangesEmployee
    );

  FreeNewDocumentChargeSheets := NewDocumentChargeSheets;

  ChangedDocumentChargeSheets :=
    CreateChangedDocumentChargeSheetsFrom(
      ChargeSheetsChangesInfoDTO.ChangedDocumentChargeSheetsInfoDTO,
      SavingChangesEmployee
    );

  FreeChangedDocumentChargeSheets := ChangedDocumentChargeSheets;
  
  RemovedDocumentChargeSheets :=
    CreateRemovedDocumentChargeSheetsFrom(
      ChargeSheetsChangesInfoDTO.RemovedDocumentChargeSheetsInfoDTO,
      SavingChangesEmployee
    );

  FreeRemovedDocumentChargeSheets := RemovedDocumentChargeSheets;

  DocumentChargeSheetsForSaving := TDocumentChargeSheets.Create;

  FreeDocumentChargeSheetsForSaving := DocumentChargeSheetsForSaving;

  if
    Assigned(NewDocumentChargeSheets) or
    Assigned(ChangedDocumentChargeSheets)
  then begin

    if Assigned(NewDocumentChargeSheets) then
      DocumentChargeSheetsForSaving.AddDocumentChargeSheets(NewDocumentChargeSheets);

    if Assigned(ChangedDocumentChargeSheets) then
      DocumentChargeSheetsForSaving.AddDocumentChargeSheets(ChangedDocumentChargeSheets);

    FDocumentChargeSheetControlService.SaveChargeSheets(
      SavingChangesEmployee, DocumentChargeSheetsForSaving
    );

  end;
  
  if Assigned(RemovedDocumentChargeSheets) then begin

    FDocumentChargeSheetControlService.RemoveChargeSheets(
      SavingChangesEmployee, RemovedDocumentChargeSheets
    );

  end;

  Result :=
    TDocumentChargeSheetsChanges.Create(
      SavingChangesEmployee,
      NewDocumentChargeSheets,
      ChangedDocumentChargeSheets,
      RemovedDocumentChargeSheets
    );

end;

procedure TStandardDocumentChargeSheetControlAppService.
  SendNotificationsAboutDocumentChargeSheetsChanges(
    DocumentChargeSheetsChanges: TDocumentChargeSheetsChanges;
    OriginalDocumentChargeSheetsChangesInfoDTO: TDocumentChargeSheetsChangesInfoDTO
  );
var
    OriginalChangedDocumentChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO;
begin

  if Assigned(DocumentChargeSheetsChanges.NewDocumentChargeSheets)
  then begin
  
    FDocumentChargeSheetCasesNotifier.
      SendNotificationAboutDocumentChargeSheetsAsync(
        DocumentChargeSheetsChanges.NewDocumentChargeSheets,
        DocumentChargeSheetsChanges.SavingChangesEmployee,
        NewDocumentChargeSheetsCreatedCase,
        OnDocumentChargeSheetNotificationSentEventHandler,
        OnDocumentChargeSheetNotificationSendingFailedEventHandler
      );

  end;

  if Assigned(DocumentChargeSheetsChanges.ChangedDocumentChargeSheets)
  then begin

    for
        OriginalChangedDocumentChargeSheetInfoDTO in
        OriginalDocumentChargeSheetsChangesInfoDTO.
          ChangedDocumentChargeSheetsInfoDTO
    do begin

      if OriginalChangedDocumentChargeSheetInfoDTO.IsChargeTextChanged
      then Continue;

      DocumentChargeSheetsChanges.
        ChangedDocumentChargeSheets.
          DeleteDomainObjectByIdentity(
            OriginalChangedDocumentChargeSheetInfoDTO.Id
          );

    end;


    FDocumentChargeSheetCasesNotifier.
      SendNotificationAboutDocumentChargeSheetsAsync(
        DocumentChargeSheetsChanges.ChangedDocumentChargeSheets,
        DocumentChargeSheetsChanges.SavingChangesEmployee,
        DocumentChargeSheetsChangedCase,
        OnDocumentChargeSheetNotificationSentEventHandler,
        OnDocumentChargeSheetNotificationSendingFailedEventHandler
      );

  end;

  if Assigned(DocumentChargeSheetsChanges.RemovedDocumentChargeSheets)
  then begin

    FDocumentChargeSheetCasesNotifier.
      SendNotificationAboutDocumentChargeSheetsAsync(
        DocumentChargeSheetsChanges.RemovedDocumentChargeSheets,
        DocumentChargeSheetsChanges.SavingChangesEmployee,
        DocumentChargeSheetsRemovedCase,
        OnDocumentChargeSheetNotificationSentEventHandler,
        OnDocumentChargeSheetNotificationSendingFailedEventHandler
      );
      
  end;
  
end;

function TStandardDocumentChargeSheetControlAppService.
  CreateNewDocumentChargeSheetsFrom(
    AddedDocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO;
    const DocumentId: Variant;
    AddingEmployee: TEmployee
  ): TDocumentChargeSheets;
var
    Document: IDocument;
    
    DocumentChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO;

    Performer: TEmployee;
    FreePerformer: IDomainObjectBase;

    NewDocumentChargeSheet: IDocumentChargeSheet;
    NewDocumentChargeSheetObj: TDocumentChargeSheet;
    
    ChargeSheetAccessRights: TDocumentChargeSheetAccessRights;
    FreeAccessRights: IDomainObjectBase;

    TopLevelChargeSheet: IDocumentChargeSheet;

    NewDocumentChargeSheets: TDocumentChargeSheets;

    ChargeSheetInfoDTOMapper: IDocumentChargeSheetInfoDTODomainMapper;
begin

  if AddedDocumentChargeSheetsInfoDTO.Count = 0 then begin

    Result := nil;
    Exit;

  end;

  Document :=
    GetDocumentOrRaise(
      DocumentId,
      'Ќе найден документ дл€ добавлени€ новых поручений'
    );

  NewDocumentChargeSheets := TDocumentChargeSheets.Create;

  try

    for DocumentChargeSheetInfoDTO in AddedDocumentChargeSheetsInfoDTO do
    begin

      with DocumentChargeSheetInfoDTO do begin

        Performer :=
          GetEmployeeOrRaise(
            PerformerInfoDTO.Id,
            'Ќе найден сотрудник во врем€ создани€ новых поручений'
          );

        FreePerformer := Performer;

        if VarIsNull(TopLevelChargeSheetId) then begin

          FDocumentChargeSheetControlService.CreateHeadChargeSheet(
            KindId, Document, Performer, AddingEmployee, 
            NewDocumentChargeSheet, ChargeSheetAccessRights
          );

        end

        else begin

          TopLevelChargeSheet :=
            FDocumentChargeSheetControlService.GetChargeSheet(
              AddingEmployee, TopLevelChargeSheetId
            );

          FDocumentChargeSheetControlService.CreateSubordinateChargeSheet(
            KindId, Document, Performer, AddingEmployee, TopLevelChargeSheet,
            NewDocumentChargeSheet, ChargeSheetAccessRights
          );

        end;

        FreeAccessRights := ChargeSheetAccessRights;

      end;

      NewDocumentChargeSheetObj := TDocumentChargeSheet(NewDocumentChargeSheet.Self);

      ChargeSheetInfoDTOMapper :=
        FDocumentChargeSheetInfoDTODomainMapperRegistry
          .GetDocumentChargeSheetInfoDTODomainMapper(
            NewDocumentChargeSheetObj.ClassType
          );

      ChargeSheetInfoDTOMapper.ChangeDocumentChargeSheetFromDTO(
        NewDocumentChargeSheetObj, DocumentChargeSheetInfoDTO, AddingEmployee
      );

      NewDocumentChargeSheets.AddDocumentChargeSheet(NewDocumentChargeSheetObj);

    end;

    Result := NewDocumentChargeSheets;

  except

    FreeAndNil(NewDocumentChargeSheets);

    Raise;

  end;

end;

function TStandardDocumentChargeSheetControlAppService.
  CreateChangedDocumentChargeSheetsFrom(
    ChangedDocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO;
    ChangingEmployee: TEmployee
  ): TDocumentChargeSheets;
var
    DocumentChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO;

    ChangedDocumentChargeSheet: IDocumentChargeSheet;
    ChangedDocumentChargeSheetObj: TDocumentChargeSheet;

    ChangedDocumentChargeSheets: TDocumentChargeSheets;

    ChargeSheetInfoDTOMapper: IDocumentChargeSheetInfoDTODomainMapper;
begin

  if ChangedDocumentChargeSheetsInfoDTO.Count = 0 then begin

    Result := nil;
    Exit;

  end;

  ChangedDocumentChargeSheets := TDocumentChargeSheets.Create;

  try

    for DocumentChargeSheetInfoDTO in ChangedDocumentChargeSheetsInfoDTO do
    begin

      with DocumentChargeSheetInfoDTO do begin

        ChangedDocumentChargeSheet :=
          FDocumentChargeSheetControlService.GetChargeSheet(
            ChangingEmployee, Id
          );

        ChangedDocumentChargeSheetObj := TDocumentChargeSheet(ChangedDocumentChargeSheet.Self);

        ChargeSheetInfoDTOMapper :=
          FDocumentChargeSheetInfoDTODomainMapperRegistry
            .GetDocumentChargeSheetInfoDTODomainMapper(
              ChangedDocumentChargeSheetObj.ClassType
            );

        ChargeSheetInfoDTOMapper
          .ChangeDocumentChargeSheetFromDTO(
            ChangedDocumentChargeSheetObj,
            DocumentChargeSheetInfoDTO,
            ChangingEmployee
          );

      end;

      ChangedDocumentChargeSheets.AddDocumentChargeSheet(
        ChangedDocumentChargeSheet
      );

    end;

    Result := ChangedDocumentChargeSheets;

  except

    FreeAndNil(ChangedDocumentChargeSheets);

    Raise;

  end;

end;

function TStandardDocumentChargeSheetControlAppService.CreateHeadChargeSheet(
  const ChargeKindId, DocumentId, PerformerId, IssuerId: Variant
): TDocumentChargeSheetInfoDTO;
begin

  FSession.Start;

  try

    Result :=
      DoCreateHeadChargeSheet(ChargeKindId, DocumentId, PerformerId, IssuerId);
    
    FSession.Commit;

  except

    On E: Exception do begin

      if E is TDomainException then
        RaiseFailedBusinessProcessServiceException(E.Message);

      Raise;

    end;

  end;
  
end;

function TStandardDocumentChargeSheetControlAppService.CreateHeadChargeSheet(
  const DocumentId, PerformerId, IssuerId: Variant
): TDocumentChargeSheetInfoDTO;
begin

  FSession.Start;

  try

    Result := DoCreateHeadChargeSheet(DocumentId, PerformerId, IssuerId);
    
    FSession.Commit;

  except

    On E: Exception do begin

      if E is TDomainException then
        RaiseFailedBusinessProcessServiceException(E.Message);

      Raise;

    end;

  end;

end;

function TStandardDocumentChargeSheetControlAppService.
  CreateRemovedDocumentChargeSheetsFrom(
    RemovedDocumentChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO;
    RemovingEmployee: TEmployee
  ): TDocumentChargeSheets;
var
    DocumentChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO;

    RemovedDocumentChargeSheet: IDocumentChargeSheet;
    FreeRemovedDocumentChargeSheet: IDomainObjectBase;
    
    RemovedDocumentChargeSheets: TDocumentChargeSheets;
begin

  if RemovedDocumentChargeSheetsInfoDTO.Count = 0 then begin

    Result := nil;
    Exit;

  end;

  RemovedDocumentChargeSheets := TDocumentChargeSheets.Create;

  try

    for DocumentChargeSheetInfoDTO in RemovedDocumentChargeSheetsInfoDTO do
    begin

      with DocumentChargeSheetInfoDTO do begin

        RemovedDocumentChargeSheet :=
          FDocumentChargeSheetControlService.GetChargeSheet(
            RemovingEmployee, Id
          );

        RemovedDocumentChargeSheets.AddDocumentChargeSheet(
          RemovedDocumentChargeSheet
        );

      end;

    end;

    Result := RemovedDocumentChargeSheets;

  except

    FreeAndNil(RemovedDocumentChargeSheets);

    Raise;

  end;

end;

{ TDocumentChargeSheetsChanges }

constructor TDocumentChargeSheetsChanges.Create;
begin

  inherited;
  
end;

constructor TDocumentChargeSheetsChanges.Create(
  SavingChangesEmployee: TEmployee;
  NewDocumentChargeSheets,
  ChangedDocumentChargeSheets,
  RemovedDocumentChargeSheets: TDocumentChargeSheets
);
begin

  inherited Create;

  Self.SavingChangesEmployee := SavingChangesEmployee;
  Self.NewDocumentChargeSheets := NewDocumentChargeSheets;
  Self.ChangedDocumentChargeSheets := ChangedDocumentChargeSheets;
  Self.RemovedDocumentChargeSheets := RemovedDocumentChargeSheets;

  Self.FreeSavingChangesEmployee := SavingChangesEmployee;
  Self.FreeNewDocumentChargeSheets := NewDocumentChargeSheets;
  Self.FreeChangedDocumentChargeSheets := ChangedDocumentChargeSheets;
  Self.FreeRemovedDocumentChargeSheets := RemovedDocumentChargeSheets;

end;

destructor TDocumentChargeSheetsChanges.Destroy;
begin

  inherited;

end;

end.
