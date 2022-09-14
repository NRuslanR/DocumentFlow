unit DocumentStorageServiceTestFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DocumentStorageService, DocumentFullInfoDTO,
  NewDocumentInfoDTO,
  ChangedDocumentInfoDTO,
  ServiceNoteStorageService,
  ISessionUnit,
  PostgresTransactionUnit,
  DocumentRepository,
  ServiceNote,
  RepositoryRegistryUnit,
  IEmployeeRepositoryUnit,
  DepartmentRepositoryUnit,
  DocumentZeosPostgresRepositoryAdapter,
  EmployeeRepositoryUnit,
  DocumentFilesRepositoryUnit,
  DocumentFileServiceClientUnit,
  IDocumentFileServiceClientUnit,
  IFileStorageServiceClientUnit,
  EmployeeDocumentWorkingRules,
  EmployeeDocumentWorkingRuleRegistry,
  StandardEmployeeDocumentWorkingRuleRegistry,
  LocalNetworkFileStorageServiceClientUnit,
  ServiceNoteZeosPostgresRepository,
  DocumentRelationsRepositoryUnit,
  ZConnection,
  StdCtrls,
  StandardEmployeeDocumentViewingRule,
  StandardEmployeeIsSameAsOrDeputySpecification,
  StandardEmployeeIsSameAsOrReplacingSignerForOthersSpecification,
  StandardEmployeeIsSecretaryForAnyOfEmployeesSpecification,
  DocumentFullNameCompilationService,
  StandardDocumentFullNameCompilationService,
  EmployeeLeadershipControlService,
  DALEmployeeLeadershipControlService,
  StandardEmployeeDocumentSigningPerformingRule,
  StandardEmployeeDocumentSigningRejectingPerformingRule,
  StandardPerformingDocumentSendingRule,
  StandardSigningDocumentSendingRule,
  StandardEmployeeDocumentEditingRule,
  StandardDocumentChargePerformedMarkingRule,
  StandardDocumentCorrectlyWrittenForSigningSpecification,
  StandardDocumentSignerListChangingRule,
  StandardDocumentChargeListChangingRule,
  ZeosDocumentInfoReadService,
  StandardDocumentUsageEmployeeAccessRightsService,
  DocumentUsageEmployeeAccessRightsInfoDTO,
  ZeosPostgresTransactionUnit,
  ZeosPostgresDocumentInfoReadService,
  StandardEmployeeIsSameAsOrDeputyOfEmployeesSpecification,
  DocumentFilesZeosPostgresRepositoryAdapter,
  DocumentRelationsZeosPostgresRepositoryAdapter,
  ServiceNoteFilesZeosPostgresRepository,
  ServiceNoteRelationsZeosPostgresRepository,
  DocumentApprovings,
  DocumentApprovingCycleResult;

type

  TDocumentStorageServiceTestForm = class(TForm)
    Button1: TButton;
    ZConnection1: TZConnection;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);

  private

    FDocumentStorageService: IDocumentStorageService;
    FDocumentFileServiceClient: IDocumentFileServiceClient;

    { Private declarations }

    procedure SetUp;
    function CreateEmployeeDocumentWorkingRules: TEmployeeDocumentWorkingRules;
    procedure CreateDocumentStorageService;
    procedure CustomizeRepositoryRegistry;
    procedure CustomizeEmployeeDocumentWorkingRulesRegistry;
    procedure RunGettingDocumentFullInfoTest;
    procedure RunRemovingDocumentsInfoTest;
    procedure RunChangingDocumentInfoTest;
    procedure RunAddingDocumentFullInfoTest;

  public
    { Public declarations }
  end;

var
  DocumentStorageServiceTestForm: TDocumentStorageServiceTestForm;

implementation

uses

  DateUtils,
  VariantListUnit;
  
{$R *.dfm}

procedure TDocumentStorageServiceTestForm.Button1Click(Sender: TObject);
begin

  RunGettingDocumentFullInfoTest;

  TDocuemt
  
end;

procedure TDocumentStorageServiceTestForm.Button2Click(Sender: TObject);
begin

  RunAddingDocumentFullInfoTest;
  
end;

procedure TDocumentStorageServiceTestForm.Button3Click(Sender: TObject);
begin

  RunRemovingDocumentsInfoTest;
  
end;

procedure TDocumentStorageServiceTestForm.Button4Click(Sender: TObject);
begin

  RunChangingDocumentInfoTest;
  
end;

procedure TDocumentStorageServiceTestForm.CreateDocumentStorageService;
begin

  FDocumentStorageService :=
    TServiceNoteStorageService.Create(
      TRepositoryRegistry.Current.GetSessionManager,
      TRepositoryRegistry.Current.GetDocumentRepository(TServiceNote),
      TStandardEmployeeDocumentWorkingRuleRegistry.Current,
      TRepositoryRegistry.Current.GetEmployeeRepository,
      TRepositoryRegistry.Current.GetDepartmentRepository,
      TZeosPostgresDocumentInfoReadService.Create(ZConnection1),
      TRepositoryRegistry.Current.GetDocumentRelationsRepository,
      FDocumentFileServiceClient,
      TStandardDocumentUsageEmployeeAccessRightsService.Create(
        TStandardDocumentFullNameCompilationService.Create
      )
    );
end;

function TDocumentStorageServiceTestForm.CreateEmployeeDocumentWorkingRules: TEmployeeDocumentWorkingRules;
var ReplacingSignerSpec: TStandardEmployeeIsSameAsOrReplacingSignerForOthersSpecification;
    DocumentFullNameService: IDocumentFullNameCompilationService;
    DocumentCorrectWrittenForSigningSpec:
      TStandardDocumentCorrectlyWrittenForSigningSpecification;
    IsSameAsOrDeputySpec: TStandardEmployeeIsSameAsOrDeputyOfEmployeesSpecification;
begin

  Result := TEmployeeDocumentWorkingRules.Create;

  IsSameAsOrDeputySpec :=
    TStandardEmployeeIsSameAsOrDeputyOfEmployeesSpecification.Create(
      TStandardEmployeeIsSameOrDeputySpecification.Create
    );

  ReplacingSignerSpec :=
    TStandardEmployeeIsSameAsOrReplacingSignerForOthersSpecification.Create(
      TStandardEmployeeIsSameOrDeputySpecification.Create
    );

  DocumentFullNameService :=
    TStandardDocumentFullNameCompilationService.Create;

  Result.DocumentViewingRule :=
    TStandardEmployeeDocumentViewingRule.Create(
      TStandardEmployeeIsSecretaryForAnyOfEmployeesSpecification.Create,
      IsSameAsOrDeputySpec,
      DocumentFullNameService,
      TDALEmployeeLeadershipControlService.Create(
        TRepositoryRegistry.Current.GetDepartmentRepository
      )
    );

  DocumentCorrectWrittenForSigningSpec :=
    TStandardDocumentCorrectlyWrittenForSigningSpecification.Create;

  Result.SigningPerformingRule :=
    TStandardEmployeeDocumentSigningPerformingRule.Create(
      ReplacingSignerSpec,
      DocumentFullNameService,
      DocumentCorrectWrittenForSigningSpec
    );

  Result.SigningRejectingPerformingRule :=
    TStandardEmployeeDocumentSigningRejectingPerformingRule.Create(
      ReplacingSignerSpec,
      DocumentFullNameService
    );

  Result.SigningDocumentSendingRule :=
    TStandardSigningDocumentSendingRule.Create(
      DocumentCorrectWrittenForSigningSpec,
      IsSameAsOrDeputySpec,
      DocumentFullNameService
    );

  Result.PerformingDocumentSendingRule :=
    TStandardPerformingDocumentSendingRule.Create(
      ReplacingSignerSpec,
      DocumentFullNameService
    );

  Result.SignerListChangingRule :=
    TStandardEmployeeDocumentSignerListChangingRule.Create(
      DocumentFullNameService,
      ReplacingSignerSpec
    );

  Result.ChargePerformedMarkingRule :=
    TStandardEmployeeDocumentChargePerformingRule.Create(
      IsSameAsOrDeputySpec,
      DocumentFullNameService
    );

  Result.ChargeListChangingRule :=
    TStandardEmployeeDocumentChargeListChangingRule.Create(
      DocumentFullNameService,
      ReplacingSignerSpec
    );

  Result.EditingRule :=
    TStandardEmployeeDocumentEditingRule.Create(
      ReplacingSignerSpec,
      DocumentFullNameService
    );
    
end;

procedure TDocumentStorageServiceTestForm.CustomizeEmployeeDocumentWorkingRulesRegistry;
begin

   TStandardEmployeeDocumentWorkingRuleRegistry.
    Current.
      RegisterEmployeeDocumentWorkingRules(
        TServiceNote,
        CreateEmployeeDocumentWorkingRules
      );
      
end;

procedure TDocumentStorageServiceTestForm.CustomizeRepositoryRegistry;
begin

  TRepositoryRegistry.Current.RegisterSessionManager(
    TZeosPostgresTransaction.Create(ZConnection1)
  );

  TRepositoryRegistry.Current.RegisterEmployeeRepository(
    TCompositeEmployeePostgresRepository.Create(ZConnection1)
  );

  TRepositoryRegistry.Current.RegisterDepartmentRepository(
    TCompositeDepartmentPostgresRepository.Create(ZConnection1)
  );
  
  TRepositoryRegistry.Current.RegisterDocumentFilesRepository(
    TDocumentFilesZeosPostgresRepositoryAdapter.Create(
      TServiceNoteFilesZeosPostgresRepository.Create(ZConnection1)
    )
  );

  TRepositoryRegistry.Current.RegisterDocumentRelationsRepository(
    TDocumentRelationsZeosPostgresRepositoryAdapter.Create(
      TServiceNoteRelationsZeosPostgresRepository.Create(ZConnection1)
    )
  );

  TRepositoryRegistry.Current.RegisterDocumentRepository(
    TServiceNote,
    TDocumentZeosPostgresRepositoryAdapter.Create(
      TServiceNoteZeosPostgresRepository.Create(ZConnection1)
    )
  );

  TRepositoryRegistry.Current.RegisterDepartmentRepository(
    TCompositeDepartmentPostgresRepository.Create(ZConnection1)
  );
  
end;

procedure TDocumentStorageServiceTestForm.FormCreate(Sender: TObject);
begin

  SetUp;

end;

procedure TDocumentStorageServiceTestForm.RunAddingDocumentFullInfoTest;
var AddingCommand: TAddNewDocumentFullInfoCommand;
    NewDocInfo: TNewDocumentInfoDTO;
    Charge: TDocumentChargeInfoDTO;
    Signing: TDocumentSigningInfoDTO;
    Relation: TDocumentRelationInfoDTO;
    FileInfo: TDocumentFileInfoDTO;
begin

  NewDocInfo := TNewDocumentInfoDTO.Create;
  NewDocInfo.DocumentDTO := TDocumentDTO.Create;
  NewDocInfo.DocumentDTO.Number := '1888/1235';
  NewDocInfo.DocumentDTO.Name := 'Тест служебки';
  NewDocInfo.DocumentDTO.Content := 'Содержание тестовой пердебки';
  NewDocInfo.DocumentDTO.CreationDate := Now;
  NewDocInfo.DocumentDTO.Note := 'Ссанные примечания';
  NewDocInfo.DocumentDTO.AuthorDTO := TDocumentAuthorInfoDTO.Create;
  NewDocInfo.DocumentDTO.AuthorDTO.Id := 1355;
  NewDocInfo.DocumentDTO.ResponsibleInfoDTO := TDocumentResponsibleInfoDTO.Create;
  NewDocInfo.DocumentDTO.ResponsibleInfoDTO.Id := 1333;
  NewDocInfo.DocumentDTO.ChargesInfoDTO := TDocumentChargesInfoDTO.Create;

  Charge := TDocumentChargeInfoDTO.Create;

  Charge.ChargeText := 'Советую вам выспаться';
  Charge.PerformerResponse := 'Впишите в коммент что-нить';
  Charge.TimeFrameStartLine := IncWeek(Now, 1);
  Charge.TimeFrameDeadline := IncWeek(Now, 3);
  Charge.PerformerId := 1356;

  NewDocInfo.DocumentDTO.ChargesInfoDTO.Add(Charge);

  Charge := TDocumentChargeInfoDTO.Create;

  Charge.ChargeText := 'Бессрочное пиздобрение';
  Charge.PerformerId := 1372;

  NewDocInfo.DocumentDTO.ChargesInfoDTO.Add(Charge);

  Charge := TDocumentChargeInfoDTO.Create;

  Charge.ChargeText := 'Срочное опоясование';
  Charge.PerformerId := 1335;
  Charge.TimeFrameStartLine := Now;
  Charge.TimeFrameDeadline := IncDay(Now, 5);

  NewDocInfo.DocumentDTO.ChargesInfoDTO.Add(Charge);

  NewDocInfo.DocumentDTO.SigningsInfoDTO := TDocumentSigningsInfoDTO.Create;

  Signing := TDocumentSigningInfoDTO.Create;
  Signing.SignerInfoDTO := TDocumentSignerInfoDTO.Create;
  Signing.SignerInfoDTO.Id := 126;

  NewDocInfo.DocumentDTO.SigningsInfoDTO.Add(Signing);

  NewDocInfo.DocumentRelationsInfoDTO := TDocumentRelationsInfoDTO.Create;

  Relation := TDocumentRelationInfoDTO.Create;
  Relation.RelatedDocumentId := 227663;
  Relation.RelatedDocumentKindId := 3;

  NewDocInfo.DocumentRelationsInfoDTO.Add(Relation);

  Relation := TDocumentRelationInfoDTO.Create;
  Relation.RelatedDocumentId := 227673;
  Relation.RelatedDocumentKindId := 2;

  NewDocInfo.DocumentRelationsInfoDTO.Add(Relation);

  Relation := TDocumentRelationInfoDTO.Create;
  Relation.RelatedDocumentId := 227674;
  Relation.RelatedDocumentKindId := 3;

  NewDocInfo.DocumentRelationsInfoDTO.Add(Relation);

  Relation := TDocumentRelationInfoDTO.Create;
  Relation.RelatedDocumentId := 227683;
  Relation.RelatedDocumentKindId := 2;

  NewDocInfo.DocumentRelationsInfoDTO.Add(Relation);

  NewDocInfo.DocumentFilesInfoDTO := TDocumentFilesInfoDTO.Create;

  FileInfo := TDocumentFileInfoDTO.Create;

  FileInfo.FileName :=
  'Руководство пользователя ИС ОМО.pdf';

  FileInfo.FilePath :=
    'C:\Documents and Settings\59968\Мои документы\Руководство пользователя ИС ОМО.pdf';

  NewDocInfo.DocumentFilesInfoDTO.Add(FileInfo);

  FileInfo := TDocumentFileInfoDTO.Create;

  FileInfo.FileName :=
  'gost_34_602_89.pdf';

  FileInfo.FilePath :=
    'C:\Documents and Settings\59968\Рабочий стол\gost_34_602_89.pdf';

  NewDocInfo.DocumentFilesInfoDTO.Add(FileInfo);

  FileInfo := TDocumentFileInfoDTO.Create;

  FileInfo.FileName :=
    'JureczkoMadeyski10f.pdf';

  FileInfo.FilePath :=
    'C:\Documents and Settings\59968\Рабочий стол\JureczkoMadeyski10f.pdf';

  NewDocInfo.DocumentFilesInfoDTO.Add(FileInfo);

  AddingCommand :=

  TAddNewDocumentFullInfoCommand.Create(
    1355,
    NewDocInfo
  );

  FDocumentStorageService.AddNewDocumentFullInfo(AddingCommand);
  
end;

procedure TDocumentStorageServiceTestForm.RunChangingDocumentInfoTest;
var ChangingCommand: TChangeDocumentInfoCommand;
    ChangeDocInfo: TChangedDocumentInfoDTO;
    ChargeChangesInfo: TDocumentChargesChangesInfoDTO;
    ChargeInfo: TDocumentChargeInfoDTO;
    SigningInfo: TDocumentSigningInfoDTO;
    Relation: TDocumentRelationInfoDTO;
    FileInfo: TDocumentFileInfoDTO;
begin

  ChangeDocInfo := TChangedDocumentInfoDTO.Create;

  ChangeDocInfo.ChangedDocumentDTO := TChangedDocumentDTO.Create;
  ChangeDocInfo.ChangedDocumentDTO.Id := 227696;
  ChangeDocInfo.ChangedDocumentDTO.Number := '2000/1000';
  ChangeDocInfo.ChangedDocumentDTO.Name := 'Измененное название';
  ChangeDocInfo.ChangedDocumentDTO.Content := 'Измененное содержание';
  ChangeDocInfo.ChangedDocumentDTO.CreationDate := IncYear(Now,2);
  ChangeDocInfo.ChangedDocumentDTO.Note := 'пкупкупкупкупкупкуп';
  ChangeDocInfo.ChangedDocumentDTO.ResponsibleInfoDTO := TDocumentResponsibleInfoDTO.Create;
  ChangeDocInfo.ChangedDocumentDTO.ResponsibleInfoDTO.Id := 1333; 

  ChargeChangesInfo := TDocumentChargesChangesInfoDTO.Create;

  ChangeDocInfo.ChangedDocumentDTO.ChargesChangesInfoDTO :=
    ChargeChangesInfo;

  ChargeChangesInfo.AddedDocumentChargesInfoDTO :=
    TDocumentChargesInfoDTO.Create;

  ChargeChangesInfo.ChangedDocumentChargesInfoDTO :=
    TDocumentChargesInfoDTO.Create;

  ChargeChangesInfo.RemovableDocumentChargesInfoDTO :=
    TDocumentChargesInfoDTO.Create;
    
  ChargeInfo := TDocumentChargeInfoDTO.Create;
  
  ChargeInfo.ChargeText := 'Поручение Изменено ваыаы';
  ChargeInfo.TimeFrameStartLine := IncYear(Now, 6);
  ChargeInfo.TimeFrameDeadline := IncYear(Now, 20);
  ChargeInfo.PerformerResponse := 'Я ответил на исполнение';
  ChargeInfo.PerformerId := 1359;
  ChargeInfo.ActuallyPerformedEmployeeId := 12;
  ChargeInfo.PerformingDate := Now;

  //ChargeChangesInfo.AddedDocumentChargesInfoDTO.Add(ChargeInfo);
  ChargeChangesInfo.ChangedDocumentChargesInfoDTO.Add(ChargeInfo);

  ChargeInfo := TDocumentChargeInfoDTO.Create;

  ChargeInfo.PerformerId := 1335;
  ChargeInfo.TimeFrameStartLine := IncMonth(Now, 1);
  ChargeInfo.TimeFrameDeadline := IncMonth(Now, 3);
  ChargeInfo.ChargeText := 'Андрей поручение опять срочное';

  ChargeChangesInfo.ChangedDocumentChargesInfoDTO.Add(ChargeInfo);

  ChargeInfo := TDocumentChargeInfoDTO.Create;

  ChargeInfo.PerformerId := 1356;
  ChargeInfo.Id := Null;
  ChargeInfo.PerformerResponse := 'Комментарий Ирины';
  ChargeInfo.TimeFrameStartLine := Null;
  ChargeInfo.TimeFrameDeadline := Null;
  ChargeInfo.PerformingDate := Null;
  ChargeInfo.ActuallyPerformedEmployeeId := Null;

  ChargeChangesInfo.ChangedDocumentChargesInfoDTO.Add(ChargeInfo);

  ChangeDocInfo.ChangedDocumentRelationsInfoDTO :=
    TDocumentRelationsInfoDTO.Create;

  Relation := TDocumentRelationInfoDTO.Create;
  Relation.TargetDocumentId := 227696;
  Relation.RelatedDocumentId := 227663;
  Relation.RelatedDocumentKindId := 3;

  ChangeDocInfo.ChangedDocumentRelationsInfoDTO.Add(Relation);

  Relation := TDocumentRelationInfoDTO.Create;
  Relation.TargetDocumentId := 227696;
  Relation.RelatedDocumentId := 227695;
  Relation.RelatedDocumentKindId := 2;

  ChangeDocInfo.ChangedDocumentRelationsInfoDTO.Add(Relation);
      {
  Relation := TDocumentRelationInfoDTO.Create;
  Relation.TargetDocumentId := 227696;
  Relation.RelatedDocumentId := 227673;
  Relation.RelatedDocumentKindId := 2;

  ChangeDocInfo.ChangedDocumentRelationsInfoDTO.Add(Relation); }

  Relation := TDocumentRelationInfoDTO.Create;
  Relation.TargetDocumentId := 227696;
  Relation.RelatedDocumentId := 227674;
  Relation.RelatedDocumentKindId := 3;

  ChangeDocInfo.ChangedDocumentRelationsInfoDTO.Add(Relation);
                                      {
  Relation := TDocumentRelationInfoDTO.Create;
  Relation.TargetDocumentId := 227696;
  Relation.RelatedDocumentId := 227683;
  Relation.RelatedDocumentKindId := 2;

  ChangeDocInfo.ChangedDocumentRelationsInfoDTO.Add(Relation);  }
    
  ChangeDocInfo.ChangedDocumentFilesInfoDTO := TDocumentFilesInfoDTO.Create;

  FileInfo := TDocumentFileInfoDTO.Create;

  FileInfo.Id := 535;
  FileInfo.DocumentId := 227696;
  
  FileInfo.FileName :=
  'Руководство пользователя ИС ОМО.pdf';

  FileInfo.FilePath :=
    'C:\Documents and Settings\59968\Мои документы\Руководство пользователя ИС ОМО.pdf';

  ChangeDocInfo.ChangedDocumentFilesInfoDTO.Add(FileInfo);

  FileInfo := TDocumentFileInfoDTO.Create;

  FileInfo.Id := 536;
  FileInfo.DocumentId := 227696;
  FileInfo.FileName :=
  'gost_34_602_89.pdf';

  FileInfo.FilePath :=
    'C:\Documents and Settings\59968\Рабочий стол\gost_34_602_89.pdf';

  ChangeDocInfo.ChangedDocumentFilesInfoDTO.Add(FileInfo);

  FileInfo := TDocumentFileInfoDTO.Create;

  { Added, Id is not specified }
  //FileInfo.Id := 537;
  FileInfo.DocumentId := 227696;
  FileInfo.FileName :=
    'Эрих-Фромм.-Бегство-от-свободы.pdf';

  FileInfo.FilePath :=
    'C:\Documents and Settings\59968\Рабочий стол\Эрих-Фромм.-Бегство-от-свободы.pdf';

  ChangeDocInfo.ChangedDocumentFilesInfoDTO.Add(FileInfo);

  ChangingCommand :=
    TChangeDocumentInfoCommand.Create(
      1355,
      ChangeDocInfo
    );

  ChangeDocInfo.ChangedDocumentDTO.SigningsInfoDTO :=
    TDocumentSigningsInfoDTO.Create;

  SigningInfo := TDocumentSigningInfoDTO.Create;

  SigningInfo.SignerInfoDTO := TDocumentSignerInfoDTO.Create;
  SigningInfo.SignerInfoDTO.Id := 126;
  SigningInfo.SignerInfoDTO.Name := 'Zaharov';

  ChangeDocInfo.ChangedDocumentDTO.SigningsInfoDTO.Add(SigningInfo);

  FDocumentStorageService.ChangeDocumentInfo(ChangingCommand);

end;

procedure TDocumentStorageServiceTestForm.RunGettingDocumentFullInfoTest;
var
    GettingCommand: TGettingDocumentFullInfoCommand;
    GettingCommandResult: IGettingDocumentFullInfoCommandResult;
    DocFullInfoDTO: TDocumentFullInfoDTO;
    DocUsageAccessRightsInfoDTO: TDocumentUsageEmployeeAccessRightsInfoDTO;
begin

  GettingCommand :=
    TGettingDocumentFullInfoCommand.Create(
      227696, 1355
    );

  GettingCommandResult :=
    FDocumentStorageService.GetDocumentFullInfo(GettingCommand);

  DocFullInfoDTO := GettingCommandResult.DocumentFullInfoDTO;
  DocUsageAccessRightsInfoDTO := GettingCommandResult.DocumentUsageEmployeeAccessRightsInfoDTO;

end;

procedure TDocumentStorageServiceTestForm.RunRemovingDocumentsInfoTest;
var RemovingCommand: TRemoveDocumentsInfoCommand;
    RemoveableDocIds: TVariantList;
begin

  RemoveableDocIds := TVariantList.Create;

  RemoveableDocIds.Add(227696);
  
  RemovingCommand :=
    TRemoveDocumentsInfoCommand.Create(
      1355,
      RemoveableDocIds
    );

  FDocumentStorageService.RemoveDocumentsInfo(RemovingCommand);

end;

procedure TDocumentStorageServiceTestForm.SetUp;
begin

  CustomizeRepositoryRegistry;
  CustomizeEmployeeDocumentWorkingRulesRegistry;
  
  FDocumentFileServiceClient :=
    TDocumentFileServiceClient.Create(
      TLocalNetworkFileStorageServiceClient.Create(
        '\\srv-doc\Doc_Oborot\umz_doc',
        'user_umz_doc',
        'L0r4vtyN'
      ),
      TRepositoryRegistry.Current.GetDocumentFilesRepository
    );

  CreateDocumentStorageService;
  
end;

end.
