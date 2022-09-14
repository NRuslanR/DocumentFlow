unit RefactorRepositoriesTestForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ZConnection, DocumentZeosPostgresRepository,
  IncomingDocumentZeosPostgresRepository, RoleUnit,
  ServiceNoteZeosPostgresRepository, IncomingServiceNoteZeosPostgresRepository,
  Employee, DepartmentUnit, IDocumentUnit, IDomainObjectBaseUnit, Document,
  DocumentSignings, DocumentCharges, IncomingDocument,
  DocumentChargeSheetZeosPostgresRepository, DocumentChargeSheet,
  ServiceNoteChargeSheetPostgresRepository,
  EmployeePostgresRepository,
  EmployeeReferenceService,
  StandardEmployeeReferenceService,
  BasedOnRepositoryEmployeeFinder,
  BasedOnRepositoryDepartmentFinder,
  DepartmentRepositoryUnit;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ZConnection1: TZConnection;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }

    FEmployeeRepository: TEmployeePostgresRepository;
    FDocumentRepository: TDocumentZeosPostgresRepository;
    FIncomingDocumentRepository: TIncomingDocumentZeosPostgresRepository;
    FChargeSheetRepository: TDocumentChargeSheetZeosPostgresRepository;
    FEmployeeReferenceService: IEmployeeReferenceService;
    
    procedure SetUp;

    function GetAddedOriginalDocument: TDocument;
    
    procedure OutputDocument(Document: TDocument);
    procedure OutputIncomingDocument(IncomingDocument: TIncomingDocument);

    procedure RunDocumentRepositoryTest;
    procedure RunIncomingDocumentRepositoryTest;
    procedure RunDocumentChargeSheetRepositoryTest;

  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses

  DateUtils,
  AuxDebugFunctionsUnit,
  RepositoryRegistryUnit,
  EmployeeRepositoryUnit;
  
{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin

  RunDocumentRepositoryTest;

end;

procedure TForm2.Button2Click(Sender: TObject);
begin

  RunIncomingDocumentRepositoryTest;
  
end;

procedure TForm2.Button3Click(Sender: TObject);
begin

  RunDocumentChargeSheetRepositoryTest;
  
end;

procedure TForm2.Button4Click(Sender: TObject);
var Employees:  TEmployees;
    Employee: TEmployee;
    Replacement: TEmployeeReplacement;
begin

  Employees :=
    FEmployeeRepository.FindAllTopLevelEmployeesForEmployee(1355);

  for Employee in Employees do begin

    DebugOutput(Employee.FullName);

    for Replacement in Employee.EmployeeReplacements do begin

      DebugOutput(Replacement.IsPermanent);
      DebugOutput(Replacement.IsPeriodExpired);
      DebugOutput(Replacement.IsPeriodExpiring);

    end;
    
  end;

  Employees.Free;

end;

procedure TForm2.Button5Click(Sender: TObject);
var first, second: TEmployee;
begin

  first := FEmployeeRepository.FindEmployeeById(126);
  second := FEmployeeRepository.FindEmployeeById(126);

  DebugOutput(
    FEmployeeReferenceService.IsEmployeeWorkspaceIncludesOtherEmployee(
      first, second
    )
  );

  second := FEmployeeRepository.FindEmployeeById(1373);

  DebugOutput(
    FEmployeeReferenceService.IsEmployeeWorkspaceIncludesOtherEmployee(
      first, second
    )
  );

  second := FEmployeeRepository.FindEmployeeById(1332);

  DebugOutput(
    FEmployeeReferenceService.IsEmployeeWorkspaceIncludesOtherEmployee(
      first, second
    )
  );

  DebugOutput(
    FEmployeeReferenceService.IsEmployeeWorkspaceIncludesOtherEmployee(
      second, first
    )
  );

  second := FEmployeeRepository.FindEmployeeById(1356);

  DebugOutput(
    FEmployeeReferenceService.IsEmployeeWorkspaceIncludesOtherEmployee(
      second, first
    )
  );

  first := second;

  second := FEmployeeRepository.FindEmployeeById(1332);

  DebugOutput(
    FEmployeeReferenceService.IsEmployeeWorkspaceIncludesOtherEmployee(
      first, second
    )
  );

  DebugOutput(
    FEmployeeReferenceService.IsEmployeeWorkspaceIncludesOtherEmployee(
      second, first
    )
  );

  second := FEmployeeRepository.FindEmployeeById(1373);

  DebugOutput(
    FEmployeeReferenceService.IsEmployeeWorkspaceIncludesOtherEmployee(
      first, second
    )
  );
  
end;

procedure TForm2.FormCreate(Sender: TObject);
begin

  SetUp;
  
end;

function TForm2.GetAddedOriginalDocument: TDocument;
var Document, CloneeDocument: TDocument;
    Documents: TDocuments;
    Author: TEmployee;
    FreeAuthor: IDomainObjectBase;
    Signer1, Signer2: TEmployee;
    Performer1, Performer2, Performer3: TEmployee;
begin

  Document := TDocument.Create;
  
  Document.InvariantsComplianceRequested := False;

  Document.Name := 'Разработка ЭДО';
  Document.CreationDate := Now;
  Document.Content := 'Разработка ЭДО';
  Document.Note := 'Примечания отсутствуют';
  Document.ResponsibleId := 16017;
  Document.Number := '0876/1225';

  Author := TEmployee.Create(1355);
  Author.Name := 'Руслан';
  Author.Surname := 'Нигматуллин';
  Author.Patronymic := 'Радикович';
  Author.Role := TRoleMemento.GetEmployeeRole;
  
  FreeAuthor := Author;

  Document.Author := Author;

  Signer1 := TEmployee.Create(1333);
  Signer1.Name := 'Олег';
  Signer1.Surname := 'Аисов';
  Signer1.Patronymic := 'Бариевич';
  Signer1.Role := TRoleMemento.GetLeaderRole;

  Signer2 := TEmployee.Create(1332);
  Signer2.Name := 'Денис';
  Signer2.Surname := 'Захаров';
  Signer2.Patronymic := 'Валерьевич';
  Signer2.Role := TRoleMemento.GetSubLeaderRole;
  
  Document.AddSigner(Signer1);
  Document.AddSigner(Signer2);

  Performer1 := TEmployee.Create(1358);
  Performer1.Name := 'Пётр';
  Performer1.Surname := 'Васильев';
  Performer1.Patronymic := 'Генадьевич';
  Performer1.Role := TRoleMemento.GetEmployeeRole;

  Document.AddNonRequiredCharge(Performer1, 'Ознакомьтесь с документом');

  Performer2 := TEmployee.Create(1356);
  Performer2.Name := 'Ирина';
  Performer2.Surname := 'Шувалова';
  Performer2.Patronymic := 'Андреевна';
  Performer2.Role := TRoleMemento.GetEmployeeRole;

  Document.AddRequiredCharge(
    Performer2,
    Now,
    IncDay(Now, 12),
    'Проверить невыполненные документы'
  );

  FDocumentRepository.AddDocument(Document);

  Result := Document;
  
end;

procedure TForm2.OutputDocument(Document: TDocument);
var Signing: TDocumentSigning;
    Charge: TDocumentCharge;
begin

  DebugOutput('Id:' + VarToStr(Document.Identity));
  DebugOutput('Name:' + Document.Name);
  DebugOutput('Content:' + Document.Content);
  DebugOutput('CreationDate:' + VarToStr(Document.CreationDate));
  DebugOutput('Number:' + Document.Number);
  DebugOutput('ResponsibleId:' + VarToStr(Document.ResponsibleId));

  if Assigned(Document.Author) then
    DebugOutput('Author:' + Document.Author.FullName);

  DebugOutput('--------------Charges--------------------');

  for Charge in Document.Charges do begin

    DebugOutput('Id:' + VarToStr(Charge.Identity));
    DebugOutput('DocumentId:' + VarToStr(Charge.DocumentId));
    DebugOutput('ChargeText:' + Charge.ChargeText);

    if Assigned(Charge.Performer) then
      DebugOutput('Performer:' + Charge.Performer.FullName);

    DebugOutput('TimeFrameStart:' + VarToStr(Charge.TimeFrameStart));
    DebugOutput('TimeFrameDeadline:' + VarToStr(Charge.TimeFrameDeadline));
    DebugOutput('Response:' + Charge.Response);
    DebugOutput('PerformingDate:' + VarToStr(Charge.PerformingDate));

    if Charge.ActuallyPerformedEmployee <> nil then
      DebugOutput('ActuallyPerformed:' +
        Charge.ActuallyPerformedEmployee.FullName);
    

  end;

  DebugOutput('--------------Signings--------------------');

  for Signing in Document.Signings do begin

    DebugOutput('Id:' + VarToStr(Signing.Identity));
    DebugOutput('DocumentId:' + VarToStr(Signing.DocumentId));

    if Assigned(Signing.Signer) then
      DebugOutput('Signer:' + Signing.Signer.FullName);
      
    DebugOutput('SigningDate:' + VarToStr(Signing.SigningDate));

    if Signing.ActuallySignedEmployee <> nil then
      DebugOutput('ActuallySigned:' +
        Signing.ActuallySignedEmployee.FullName
      );

  end;

end;

procedure TForm2.OutputIncomingDocument(IncomingDocument: TIncomingDocument);
begin

  DebugOutput('IncId:' + VarToStr(IncomingDocument.Identity));
  DebugOutput('IncNumber:' + IncomingDocument.IncomingNumber);
  DebugOutput('ReceiptDate:' + VarToStr(IncomingDocument.ReceiptDate));
  
  OutputDocument(IncomingDocument.OriginalDocument);

end;

procedure TForm2.RunDocumentChargeSheetRepositoryTest;
var cs1, cs2, cs3: TDocumentChargeSheet;
    css: TDocumentChargeSheets;
    IssuingEmployee, Performer: TEmployee;
    css1: TDocumentChargeSheets;
begin

  cs1 := TDocumentChargeSheet.Create;

  IssuingEmployee := TEmployee.Create(1332);
  IssuingEmployee.Role := TRoleMemento.GetEmployeeRole;

  Performer := TEmployee.Create(1355);
  Performer.Role := TRoleMemento.GetEmployeeRole;

  cs1.InvariantsComplianceRequested := False;
  cs1.IssuingEmployee := IssuingEmployee;
  cs1.Performer := Performer;
  cs1.SetTimeFrameStartAndDeadline(Now, IncMonth(Now, 3));
  cs1.ChargeText := 'Поручение текст';
  cs1.PerformerResponse := 'Ответ исполнителя';
  cs1.DocumentId := 2283;
  
  css := TDocumentChargeSheets.Create;

  css.AddDocumentChargeSheet(cs1);

  cs1 := TDocumentChargeSheet.Create;

  cs1.InvariantsComplianceRequested := False;
  
  IssuingEmployee := TEmployee.Create(1332);
  IssuingEmployee.Role := TRoleMemento.GetEmployeeRole;

  Performer := TEmployee.Create(1356);
  Performer.Role := TRoleMemento.GetEmployeeRole;

  cs1.InvariantsComplianceRequested := False;
  cs1.IssuingEmployee := IssuingEmployee;
  cs1.Performer := Performer;
  cs1.SetTimeFrameStartAndDeadline(Now, IncMonth(Now, 3));
  cs1.ChargeText := 'Поручение Ирине';
  cs1.DocumentId := 2284;
  cs1.PerformerResponse := 'Ответ ирины';

  css.AddDocumentChargeSheet(cs1);

  DebugOutput(css.Count);

  FChargeSheetRepository.AddDocumentChargeSheets(css);

  cs2 := TDocumentChargeSheet.Create;
  
  cs2.InvariantsComplianceRequested := False;

  Performer := TEmployee.Create(1358);
  Performer.Role := TRoleMemento.GetEmployeeRole;

  cs2.InvariantsComplianceRequested := False;
  cs2.IssuingEmployee := css[0].Performer;
  cs2.Performer := Performer;
  cs2.SetTimeFrameStartAndDeadline(Now, IncDay(Now, 5));
  cs2.ChargeText := 'Поручение Петру Генадьевичу';
  cs2.PerformerResponse := 'Ответ Петра Генадьевича';
  cs2.TopLevelChargeSheetId := css[0].Identity;
  cs2.DocumentId := css[0].DocumentId;

  FChargeSheetRepository.AddDocumentChargeSheet(cs2);

  cs3 := TDocumentChargeSheet.Create;
  
  cs3.InvariantsComplianceRequested := False;

  Performer := TEmployee.Create(1359);
  Performer.Role := TRoleMemento.GetEmployeeRole;

  cs3.InvariantsComplianceRequested := False;
  cs3.IssuingEmployee := cs2.Performer;
  cs3.Performer := Performer;
  cs3.SetTimeFrameStartAndDeadline(Now, IncDay(Now, 13));
  cs3.ChargeText := 'Поручение Ермакову';
  cs3.PerformerResponse := 'Ответ Ермакова';
  cs3.TopLevelChargeSheetId := cs2.Identity;
  cs3.DocumentId := cs2.DocumentId;

  FChargeSheetRepository.AddDocumentChargeSheet(cs3);

  css1 :=
    FChargeSheetRepository.FindAllSubordinateChargeSheetsForGivenChargeSheet(
      css[0].Identity
    );

  Assert(Assigned(css1), 'Charge Sheets must be assigned');

  css1.InsertDocumentChargeSheet(0, css[0]);

  FChargeSheetRepository.RemoveDocumentChargeSheets(css1);
  
end;

procedure TForm2.RunDocumentRepositoryTest;
var Document, CloneeDocument: TDocument;
    Documents: TDocuments;
    FreeDocument: IDocument;
    Author: TEmployee;
    FreeAuthor: IDomainObjectBase;
    Signer1, Signer2: TEmployee;
    Performer1, Performer2, Performer3: TEmployee;
begin

  Document := TDocument.Create;

  FreeDocument := Document;
  
  Document.InvariantsComplianceRequested := False;

  Document.Name := 'Разработка ЭДО';
  Document.CreationDate := Now;
  Document.Content := 'Разработка ЭДО';
  Document.Note := 'Примечания отсутствуют';
  Document.ResponsibleId := 16017;
  Document.Number := '0876/1225';

  Author := TEmployee.Create(1355);
  Author.Name := 'Руслан';
  Author.Surname := 'Нигматуллин';
  Author.Patronymic := 'Радикович';
  Author.Role := TRoleMemento.GetEmployeeRole;
  
  FreeAuthor := Author;

  Document.Author := Author;

  Signer1 := TEmployee.Create(1333);
  Signer1.Name := 'Олег';
  Signer1.Surname := 'Аисов';
  Signer1.Patronymic := 'Бариевич';
  Signer1.Role := TRoleMemento.GetLeaderRole;

  Signer2 := TEmployee.Create(1332);
  Signer2.Name := 'Денис';
  Signer2.Surname := 'Захаров';
  Signer2.Patronymic := 'Валерьевич';
  Signer2.Role := TRoleMemento.GetSubLeaderRole;
  
  Document.AddSigner(Signer1);
  Document.AddSigner(Signer2);

  Performer1 := TEmployee.Create(1358);
  Performer1.Name := 'Пётр';
  Performer1.Surname := 'Васильев';
  Performer1.Patronymic := 'Генадьевич';
  Performer1.Role := TRoleMemento.GetEmployeeRole;

  Document.AddNonRequiredCharge(Performer1, 'Ознакомьтесь с документом');

  Performer2 := TEmployee.Create(1356);
  Performer2.Name := 'Ирина';
  Performer2.Surname := 'Шувалова';
  Performer2.Patronymic := 'Андреевна';
  Performer2.Role := TRoleMemento.GetEmployeeRole;

  Document.AddRequiredCharge(
    Performer2,
    Now,
    IncDay(Now, 12),
    'Проверить невыполненные документы'
  );

  FDocumentRepository.AddDocument(Document);

  if FDocumentRepository.HasError then
    raise Exception.Create(FDocumentRepository.LastError.ErrorMessage);

  OutputDocument(Document);
  
  Document.Content := 'Я пошёл, все перда !';
  Document.ResponsibleId := 135;

  Performer3 := TEmployee.Create(1359);
  Performer3.Name := 'Николай';
  Performer3.Surname := 'Ермаков';
  Performer3.Patronymic := 'Васильевич';
  Performer3.Role := TRoleMemento.GetEmployeeRole;
  
  Document.AddRequiredCharge(
    Performer3,
    Now,
    IncMonth(Now, 2),
    'В течение двух месяцев сделать'
  );

  Document.ToSigningBy(Document.Author);

  Document.SignBy(Signer1);
  Document.SignBy(Signer2);
  
  Documents := TDocuments.Create;

  CloneeDocument := Document.Clone as TDocument;
  
  Documents.AddDocument(CloneeDocument);
  Documents.AddDocument(Document);
  Documents.AddDocument(Document.Clone as TDocument);

  Documents[0].InvariantsComplianceRequested := False;
  Documents[1].InvariantsComplianceRequested := False;
  Documents[2].InvariantsComplianceRequested := False;

  Documents[0].Name := 'ЭДО 1';
  Documents[1].Name := 'ЭДО 2';
  Documents[2].Name := 'ЭДО 3';

  FDocumentRepository.UpdateDocument(Document);

  if FDocumentRepository.HasError then
    raise Exception.Create(FDocumentRepository.LastError.ErrorMessage);

  Document := FDocumentRepository.FindDocumentById(Document.Identity);

  OutputDocument(Document);

  FDocumentRepository.RemoveDocument(Document);

  Document := FDocumentRepository.FindDocumentById(Document.Identity);

  Assert(not Assigned(Document), 'Document must be not assigned at this moment');

  FDocumentRepository.AddDocuments(Documents);

  for Document in Documents do begin

    OutputDocument(Document);

  end;

  Documents[0].EditingEmployee := Author;
  Documents[1].EditingEmployee := Author;
  Documents[2].EditingEmployee := Author;

  Documents[0].Name := 'Слежубная записка 1';
  Documents[1].Name := 'Служебная записка 2';
  Documents[2].Name := 'Служебная записка 3';

  FDocumentRepository.UpdateDocuments(Documents);

  FDocumentRepository.RemoveDocuments(Documents);
  
end;

procedure TForm2.RunIncomingDocumentRepositoryTest;
var IncomingDocument: TIncomingDocument;
    OriginalDocument: TDocument;
    IncDocs: TIncomingDocuments;
begin

  OriginalDocument := GetAddedOriginalDocument;

  DebugOutput(OriginalDocument.Charges.Count);
  
  IncomingDocument :=
    TIncomingDocument.Create(
      OriginalDocument.Charges[0].Identity,
      OriginalDocument
    );

  OutputIncomingDocument(IncomingDocument);

  IncomingDocument.InvariantsComplianceRequested := False;
  IncomingDocument.IncomingNumber := 'incoming122';
  IncomingDocument.ReceiptDate := IncWeek(Now, 2);

  FIncomingDocumentRepository.AddIncomingDocument(IncomingDocument);

  IncomingDocument := FIncomingDocumentRepository.FindIncomingDocumentById(
                        IncomingDocument.Identity
                      );

  OutputIncomingDocument(IncomingDocument);
   {
  IncomingDocument := FIncomingDocumentRepository.FindIncomingDocumentById(
                        IncomingDocument.Identity
                      );

  Assert(not Assigned(IncomingDocument), 'Must be not assigned');
    }
  IncDocs := TIncomingDocuments.Create;

  IncDocs.AddDocument(
    TIncomingDocument.Create(
      OriginalDocument.Charges[0].Identity,
      OriginalDocument
    )
  );

  IncDocs.AddDocument(
    TIncomingDocument.Create(
      OriginalDocument.Charges[1].Identity,
      OriginalDocument
    )
  );

  IncDocs[0].InvariantsComplianceRequested := False;
  IncDocs[0].IncomingNumber := 'NewIncoming1';
  IncDocs[0].ReceiptDate := Now;

  IncDocs[1].InvariantsComplianceRequested := False;
  IncDocs[1].IncomingNumber := 'NewIncoming1123';
  IncDocs[1].ReceiptDate := IncDay(Now, 5);

  FIncomingDocumentRepository.AddIncomingDocuments(IncDocs);

  IncDocs[0].IncomingNumber := 'UpdatedIncoming1';
  IncDocs[0].ReceiptDate := Now;

  IncDocs[1].InvariantsComplianceRequested := False;
  IncDocs[1].IncomingNumber := 'UpdatedIncoming';
  IncDocs[1].ReceiptDate := IncYear(Now, 5);

  FIncomingDocumentRepository.UpdateIncomingDocuments(IncDocs);

  //FIncomingDocumentRepository.RemoveIncomingDocuments(IncDocs);

end;

procedure TForm2.SetUp;
begin

  TRepositoryRegistry.Current.RegisterEmployeeRepository(
    TCompositeEmployeePostgresRepository.Create(ZConnection1)
  );

  FChargeSheetRepository :=
    TServiceNoteChargeSheetPostgresRepository.Create(ZConnection1);
    
  FDocumentRepository := TServiceNoteZeosPostgresRepository.Create(ZConnection1);

  FIncomingDocumentRepository :=
    TIncomingServiceNoteZeosPostgresRepository.Create(
      FDocumentRepository as TServiceNoteZeosPostgresRepository
    );

  FEmployeeRepository :=
    TEmployeePostgresRepository.Create(ZConnection1);

  FEmployeeReferenceService :=
    TStandardEmployeeReferenceService.Create(
      TBasedOnRepositoryEmployeeFinder.Create(
        TCompositeEmployeePostgresRepository.Create(ZConnection1)
      ),
      TBasedOnRepositoryDepartmentFinder.Create(
        TCompositeDepartmentPostgresRepository.Create(ZConnection1)
      )
    );
    
end;

end.
