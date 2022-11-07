unit CommonDocumentTestFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Employee, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxCustomData, cxStyles, cxTL, cxMaskEdit,
  cxTLdxBarBuiltInMenu, dxSkinsCore, dxSkinsDefaultPainters, cxInplaceContainer,
  cxDBTL, DB, ZConnection, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  cxTLData, cxCalendar,
  IDocumentUnit,
  Document,
  DateUtils,
  DomainObjectUnit,
  AuxDebugFunctionsUnit,
  StandardDocumentChargeListChangingRule,
  StandardDocumentRegistrationService,
  StandardDocumentSignerListChangingRule,
  DocumentFullNameCompilationService,
  StandardSigningDocumentSendingRule,
  StandardDocumentFullNameCompilationService,
  StandardEmployeeDocumentEditingRule,
  StandardDocumentChargePerformedMarkingRule,
  StandardPerformingDocumentSendingRule,
  StandardEmployeeDocumentSigningPerformingRule,
  StandardEmployeeDocumentSigningRejectingPerformingRule,
  StandardEmployeeIsSameAsOrDeputySpecification,
  StandardEmployeeIsSameAsOrDeputyOfEmployeesSpecification,
  StandardDocumentCorrectlyWrittenForSigningSpecification,
  EmployeeIsSameAsOrDeputySpecification,
  EmployeeDocumentWorkingRules,
  DocumentChargeSheet,
  IDomainObjectUnit,
  IDocumentChargeSheetUnit,
  StandardDocumentChargeSheetChangingRule,
  StandardDocumentChargeSheetPerformingRule,
  EmployeeDocumentChargeSheetWorkingRules,
  DocumentChargeSheetFinder,
  DocumentChargeSheetOverlappingPerformingService,
  StandardDocumentChargeSheetOverlappingPerformingService,
  StandardDocumentChargeSheetOverlappedPerformingRule,
  DocumentChargeSheetControlService,
  StandardDocumentChargeSheetControlService,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  InMemoryDocumentChargeSheetFinder,
  Role,
  IncomingDocument;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    cxDBTreeList1: TcxDBTreeList;
    ZQuery1: TZQuery;
    ZConnection1: TZConnection;
    DataSource1: TDataSource;
    cxDBTreeList1cxDBTreeListColumn1: TcxDBTreeListColumn;
    cxDBTreeList1cxDBTreeListColumn2: TcxDBTreeListColumn;
    cxDBTreeList1cxDBTreeListColumn3: TcxDBTreeListColumn;
    cxDBTreeList1cxDBTreeListColumn4: TcxDBTreeListColumn;
    cxDBTreeList1cxDBTreeListColumn5: TcxDBTreeListColumn;
    ZQuery1id: TIntegerField;
    ZQuery1sender_id: TIntegerField;
    ZQuery1full_name: TStringField;
    ZQuery1speciality: TStringField;
    ZQuery1employee_id: TIntegerField;
    ZQuery1department_short_name: TStringField;
    ZQuery1comment: TStringField;
    ZQuery1charge: TStringField;
    ZQuery1is_document_opened: TBooleanField;
    ZQuery1status: TIntegerField;
    ZQuery1performing_date: TDateTimeField;
    ZQuery1document_id: TIntegerField;
    ZQuery1is_performed: TBooleanField;
    ZQuery1leader_id: TIntegerField;
    ZQuery1is_receiver_foreign: TBooleanField;
    ZQuery1charge_sender: TStringField;
    Button3: TButton;
    cxDBTreeList1cxDBTreeListColumn6: TcxDBTreeListColumn;
    cxDBTreeList1cxDBTreeListColumn7: TcxDBTreeListColumn;
    Button4: TButton;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }

    FDocument: IDocument;

    procedure CreateDocument;

    function GetSigners: TEmployees;
    function GetPerformers: TEmployees;

    procedure RunDocumentChargeSheetTest;
    procedure RunOverlappingChargeSheetPerformingTest;

  private
  
    procedure PrintAllDeputiesFor(Employee: TEmployee);
    
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var Document: TDocument;
    DocInterface: IDocument;
    WorkingRules: TEmployeeDocumentWorkingRules;
    SigningRule: TStandardEmployeeDocumentSigningPerformingRule;
    DocFullNameCompService: TStandardDocumentFullNameCompilationService;
    DocRegService: TStandardDocumentRegistrationService;
    EmployeeSpec: TStandardEmployeeIsSameAsOrDeputyOfEmployeesSpecification;
    SigningRejRule: TStandardEmployeeDocumentSigningRejectingPerformingRule;
    Employee, e, eCopy, mediatedEmp, tmp: TEmployee;
    Author: TEmployee;
    TopLevelEmployee: TEmployee;
    signers, performers: TEmployees;
    Secs: array of Integer;
    I: Integer;
begin

  CreateDocument;
  
end;

procedure TForm1.Button2Click(Sender: TObject);
begin

  RunDocumentChargeSheetTest;
  
end;

procedure TForm1.Button3Click(Sender: TObject);
begin

  ZQuery1.Open;

  DataSource1.DataSet := ZQuery1;
  
end;

procedure TForm1.Button4Click(Sender: TObject);
begin

  RunOverlappingChargeSheetPerformingTest;

end;

procedure TForm1.Button5Click(Sender: TObject);
var csControlService: IDocumentChargeSheetControlService;
    EmployeeSpec: IEmployeeIsSameAsOrDeputySpecification;
    EmployeeOfSpec: IEmployeeIsSameAsOrReplacingForOthersSpecification;
    DocFullnameService: IDocumentFullNameCompilationService;
    DocChargeSheetoverlappingPerformingService:
      IDocumentChargeSheetOverlappingPerformingService;
    //EmployeeRef: IEmployeeReference;
    csWorkingRules: TEmployeeDocumentChargeSheetWorkingRules;
    Finder: IDocumentChargeSheetFinder;
    Performer, IssuingEmployee: TEmployee;
    FreePerformer, FreeIssuingEmployee: IDomainObject;
    HeadChargeSheet, ChildChargeSheet: TDocumentChargeSheet;
    IncomingDocument: TIncomingDocument;
begin
           {
  EmployeeSpec :=
    TStandardEmployeeIsSameOrDeputySpecification.Create;

  EmployeeOfSpec := TStandardEmployeeIsSameAsOrDeputyOfEmployeesSpecification.Create(
    EmployeeSpec
  );

  DocFullnameService :=
    TStandardDocumentFullNameCompilationService.Create;

  csWorkingRules := TEmployeeDocumentChargeSheetWorkingRules.Create;

  csWorkingRules.DocumentChargeSheetChangingRule :=
    TStandardDocumentChargeSheetChangingRule.Create(EmployeeSpec);

  csWorkingRules.DocumentChargeSheetPerformingRule :=
    TStandardDocumentChargeSheetPerformingRule.Create(EmployeeSpec);

  csWorkingRules.DocumentChargeSheetOverlappedPerformingRule :=
    TStandardDocumentChargeSheetOverlappedPerformingRule.Create(
      EmployeeSpec
    );

  Finder := TInMemoryDocumentChargeSheetFinder.Create(csWorkingRules);

  DocChargeSheetoverlappingPerformingService :=
    TStandardDocumentChargeSheetOverlappingPerformingService.Create(
      EmployeeSpec, Finder
    );

  EmployeeRef := TInMemoryEmployeeReference.Create;

  csControlService := TStandardDocumentChargeSheetControlService.Create(
    EmployeeOfSpec,
    DocFullNameService,
    DocChargeSheetoverlappingPerformingService,
    EmployeeRef,
    csWorkingRules
  );

  CreateDocument;

  Performer := TEmployee.Create(12);

  FreePerformer := Performer;
  
  Performer.Surname := 'Ларионов';
  Performer.Name := 'Борис';
  Performer.Patronymic := 'Викторович';
  Performer.DepartmentIdentity := 1;
  Performer.Role := TRoleMemento.GetEmployeeRole;

  IssuingEmployee := TEmployee.Create(14);

  FreeIssuingEmployee := IssuingEmployee;
  
  IssuingEmployee.Surname := 'Некрасов';
  IssuingEmployee.Name := 'Виталий';
  IssuingEmployee.DepartmentIdentity := 1;
  IssuingEmployee.Patronymic := 'Валерьевич';
  IssuingEmployee.Role := TRoleMemento.GetLeaderRole;

  IncomingDocument := TIncomingDocument.Create(9, FDocument.Self as TDocument);

  HeadChargeSheet :=
    csControlService.CreateRequiredHeadChargeSheet(
      IncomingDocument, Performer, Now, IncWeek(Now, 2),
      'Поручаю сделать', IssuingEmployee
    );

  DebugOutput(HeadChargeSheet.IssuingEmployee.FullName);
  DebugOutput(HeadChargeSheet.ChargeText);
  DebugOutput(HeadChargeSheet.TimeFrameStart);
  DebugOutput(HeadChargeSheet.TimeFrameDeadline);
  DebugOutput(HeadChargeSheet.Performer.FullName);
  DebugOutput(HeadChargeSheet.PerformerResponse);
                       
  ChildChargeSheet :=
    csControlService.CreateRequiredChargeSheet(
      IncomingDocument,
      Performer,
      Now, IncDay(Now, 3),
      'Сделать за три дня',
      IssuingEmployee,
      HeadChargeSheet
    );

  DebugOutput(ChildChargeSheet.IssuingEmployee.FullName);
  DebugOutput(ChildChargeSheet.ChargeText);
  DebugOutput(ChildChargeSheet.TimeFrameStart);
  DebugOutput(ChildChargeSheet.TimeFrameDeadline);
  DebugOutput(ChildChargeSheet.Performer.FullName);
  DebugOutput(ChildChargeSheet.PerformerResponse);

  csControlService.EnsureThatEmployeeMayRemoveChargeSheet(
    IssuingEmployee, HeadChargeSheet
  );              }
    
end;

procedure TForm1.CreateDocument;
var Document: TDocument;
    DocInterface: IDocument;
    WorkingRules: TEmployeeDocumentWorkingRules;
    SigningRule: TStandardEmployeeDocumentSigningPerformingRule;
    DocFullNameCompService: TStandardDocumentFullNameCompilationService;
    DocRegService: TStandardDocumentRegistrationService;
    EmployeeSpec: TStandardEmployeeIsSameAsOrDeputyOfEmployeesSpecification;
    SigningRejRule: TStandardEmployeeDocumentSigningRejectingPerformingRule;
    Employee, e, eCopy, mediatedEmp, tmp: TEmployee;
    Author: TEmployee;
    TopLevelEmployee: TEmployee;
    signers, performers: TEmployees;
    Secs: array of Integer;
    I: Integer;
begin
                      {
    DocFullNameCompService :=
      TStandardDocumentFullNameCompilationService.Create;

    EmployeeSpec :=
      TStandardEmployeeIsSameAsOrDeputyOfEmployeesSpecification.Create(
        TStandardEmployeeIsSameOrDeputySpecification.Create
      );

    SigningRule :=
      TStandardEmployeeDocumentSigningPerformingRule.Create(
        EmployeeSpec,
        DocFullNameCompService,
        TStandardDocumentCorrectlyWrittenForSigningSpecification.Create
      );

    WorkingRules := TEmployeeDocumentWorkingRules.Create;

    WorkingRules.SigningPerformingRule := SigningRule;

    WorkingRules.SigningRejectingPerformingRule  :=
      TStandardEmployeeDocumentSigningRejectingPerformingRule.Create(
        EmployeeSpec,
        DocFullNameCompService
      );

    WorkingRules.SigningDocumentSendingRule :=
      TStandardSigningDocumentSendingRule.Create(
        TStandardDocumentCorrectlyWrittenForSigningSpecification.Create,
        EmployeeSpec,
        DocFullNameCompService
      );

    WorkingRules.PerformingDocumentSendingRule :=
      TStandardPerformingDocumentSendingRule.Create(
        EmployeeSpec,
        DocFullNameCompService
      );

    WorkingRules.SignerListChangingRule :=
      TStandardEmployeeDocumentSignerListChangingRule.Create(
        DocFullNameCompService,
        EmployeeSpec
      );

    WorkingRules.ChargePerformedMarkingRule :=
      TStandardEmployeeDocumentChargePerformingRule.Create(
        EmployeeSpec,
        DocFullNameCompService
      );

    WorkingRules.ChargeListChangingRule :=
      TStandardEmployeeDocumentChargeListChangingRule.Create(
        DocFullNameCompService,
        EmployeeSpec
      );

    WorkingRules.EditingRule :=
      TStandardEmployeeDocumentEditingRule.Create(
        EmployeeSpec,
        DocFullNameCompService
      );

    Document := TDocument.Create(1);

    DocInterface := Document;

    Document.WorkingRules := WorkingRules;

    TopLevelEmployee :=  TEmployee.Create(3);

    TopLevelEmployee.Surname := 'Аисов';
    TopLevelEmployee.Name := 'Олег';
    TopLevelEmployee.Patronymic := 'Бариевич';
    TopLevelEmployee.Role := TRoleMemento.GetSubLeaderRole;

    Author := TEmployee.Create(2);

    Author.Surname := 'Иванов';
    Author.Name := 'Петр';
    Author.Patronymic := 'Алексеевич';
    Author.Role := TRoleMemento.GetLeaderRole;
    Author.TopLevelEmployee := TopLevelEmployee;

    Employee := TEmployee.Create(1);
    Employee.Surname := 'Нигматуллин';
    Employee.Name := 'Руслан';
    Employee.Patronymic := 'Радикович';
    Employee.TopLevelEmployee := Author;
    Employee.Role := TRoleMemento.GetLeaderRole;

    Document.Author := Author;

    Document.EditingEmployee := Document.Author;

    Document.Name := 'Служебная записка от 15.01.2019';
    Document.CreationDate := Now;
    Document.Number := '0900/123';
    Document.ResponsibleId := 9;

    signers := GetSigners;
    performers := GetPerformers;

    for e in performers do
      Document.AddNonRequiredCharge(e);

    for e in signers do begin

      Document.AddSigner(e);

      PrintAllDeputiesFor(e);

    end;

    signers[1].AssignAsPermanentDeputy(Employee);

    Document.EditingEmployee := Employee;

    Document.Content := 'Содержание';

    mediatedEmp := TEmployee.Create(22);

    mediatedEmp.Surname := 'Весёлов';
    mediatedEmp.Name := 'Игорь';
    mediatedEmp.Patronymic := 'Витальевич';
    mediatedEmp.Role := TRoleMemento.GetLeaderRole;

    signers[0].AssignAsPermanentDeputy(mediatedEmp);

    tmp := TEmployee.Create(100);

    tmp.Surname := 'Кондратьев';
    tmp.Name := 'Иван';
    tmp.Patronymic := 'Борисович';
    tmp.Role := TRoleMemento.GetLeaderRole;

    Author.AssignAsPermanentDeputy(tmp);

    Document.SignBy(Employee);

    Document.EditingEmployee := tmp;

    Document.SignBy(mediatedEmp);

    FDocument := Document;       }
    
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  cxDBTreeList1.StoreToIniFile(
    'treelist.ini'
  );
  
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

  cxDBTreeList1.RestoreFromIniFile(
    'treelist.ini'
  );

end;

function TForm1.GetPerformers: TEmployees;
var e: TEmployee;
begin

  e := TEmployee.Create(12);

  e.Surname := 'Ларионов';
  e.Name := 'Борис';
  e.Patronymic := 'Викторович';
  e.Role := TRoleMemento.GetEmployeeRole;

  Result := TEmployees.Create;

  Result.AddDomainObject(e);

  e := TEmployee.Create(13);

  e.Surname := 'Логинов';
  e.Name := 'Сергей';
  e.Patronymic := 'Витальевич';
  e.Role := TRoleMemento.GetEmployeeRole;
  Result.AddDomainObject(e);
  
end;

function TForm1.GetSigners: TEmployees;
var e: TEmployee;
begin

  e := TEmployee.Create(14);

  e.Surname := 'Некрасов';
  e.Name := 'Виталий';
  e.Patronymic := 'Валерьевич';
  e.Role := TRoleMemento.GetLeaderRole;

  Result := TEmployees.Create;

  Result.AddDomainObject(e);

  e := TEmployee.Create(15);

  e.Surname := 'Коротков';
  e.Name := 'Дмитрий';
  e.Patronymic := 'Вагинович';
  e.Role := TRoleMemento.GetLeaderRole;

  Result.AddDomainObject(e);
  
end;

procedure TForm1.PrintAllDeputiesFor(Employee: TEmployee);
var t: TEmployeeReplacement;
begin

  for t in Employee.EmployeeReplacements do
    DebugOutput(t.ReplaceableEmployeeId);
    
end;

procedure TForm1.RunDocumentChargeSheetTest;
var ChargeSheet: TDocumentChargeSheet;
    ChargeSheetInterface: IDocumentChargeSheet;
    WorkingRules: TEmployeeDocumentChargeSheetWorkingRules;
    EmployeeSpecification: IEmployeeIsSameAsOrDeputySpecification;
    EditingEmployee: TEmployee;
    IssuingEmployee: TEmployee;
    Performer: TEmployee;
    FreeDomainObject: IDomainObject;
begin

  WorkingRules := TEmployeeDocumentChargeSheetWorkingRules.Create;

  EmployeeSpecification :=
    TStandardEmployeeIsSameOrDeputySpecification.Create;
    
  WorkingRules.DocumentChargeSheetChangingRule :=
    TStandardDocumentChargeSheetChangingRule.Create(
      EmployeeSpecification
    );

  WorkingRules.DocumentChargeSheetPerformingRule :=
    TStandardDocumentChargeSheetPerformingRule.Create(
      EmployeeSpecification
    );

  ChargeSheet := TDocumentChargeSheet.Create(20);
  ChargeSheetInterface := ChargeSheet;

  ChargeSheet.WorkingRules := WorkingRules;

  EditingEmployee := TEmployee.Create(1);

  EditingEmployee.Surname := 'Нигматуллин';
  EditingEmployee.Name := 'Руслан';
  EditingEmployee.Patronymic := 'Радикович';
  EditingEmployee.Role := TRoleMemento.GetEmployeeRole;

  FreeDomainObject := EditingEmployee;

  IssuingEmployee := TEmployee.Create(2);

  IssuingEmployee.Surname := 'Васильев';
  IssuingEmployee.Name := 'Дмитрий';
  IssuingEmployee.Patronymic := 'Александрович';
  IssuingEmployee.Role := TRoleMemento.GetEmployeeRole;

  IssuingEmployee.AssignAsPermanentDeputy(EditingEmployee);
  
  ChargeSheet.IssuingEmployee := IssuingEmployee;
  ChargeSheet.EditingEmployee := EditingEmployee;

  ChargeSheet.ChargeText := 'dsdasdasdas';

  Performer := TEmployee.Create(3);

  Performer.Surname := 'Синькевич';
  Performer.Name := 'Павел';
  Performer.Patronymic := 'Бородаевич';
  Performer.Role := TRoleMemento.GetEmployeeRole;

  ChargeSheet.Performer := Performer;
  ChargeSheet.SetTimeFrameStartAndDeadline(
    Now, IncSecond(Now, 10)
  );

  DebugOutput('Charge is performed: ' + BoolToStr(ChargeSheet.IsPerformed, True));

  Performer.AssignAsPermanentDeputy(EditingEmployee);

  ChargeSheet.SetResponseBy('first response', Performer);

  DebugOutput('Response: ' + ChargeSheet.PerformerResponse);

  ChargeSheet.SetResponseBy('second response', EditingEmployee);

  DebugOutput('Response: ' + ChargeSheet.PerformerResponse);
  
  ChargeSheet.PerformBy(EditingEmployee, 'Performed Charge');
  
  DebugOutput('Charge is performed: ' + BoolToStr(ChargeSheet.IsPerformed, True));
  DebugOutput('Performed Charge''s response: ' + ChargeSheet.PerformerResponse);
  DebugOutput('Charge performing date: ' + DateTimeToStr(ChargeSheet.PerformingDate));
  
  ChargeSheet.SetResponseBy('adasdasds', EditingEmployee);

end;

procedure TForm1.RunOverlappingChargeSheetPerformingTest;
var ChargeSheetFinder: IDocumentChargeSheetFinder;
    OverlappingChargeSheetPerformingService:
      IDocumentChargeSheetOverlappingPerformingService;
    EmployeeSpec: IEmployeeIsSameAsOrDeputySpecification;
var ChargeSheet: IDocumentChargeSheet;
    ChargeSheetImpl: TDocumentChargeSheet;
    Performer: TEmployee;
    WorkingRules: TEmployeeDocumentChargeSheetWorkingRules;

begin
                       {
  EmployeeSpec :=
    TStandardEmployeeIsSameOrDeputySpecification.Create;

  WorkingRules :=
    TEmployeeDocumentChargeSheetWorkingRules.Create(
      TStandardDocumentChargeSheetChangingRule.Create(
        EmployeeSpec
      ),
      TStandardDocumentChargeSheetPerformingRule.Create(
        EmployeeSpec
      ),
      TStandardDocumentChargeSheetOverlappedPerformingRule.Create
    );

  ChargeSheetFinder :=
    TInMemoryDocumentChargeSheetFinder.Create(WorkingRules);
  
  OverlappingChargeSheetPerformingService :=
    TStandardDocumentChargeSheetOverlappingPerformingService.Create(
      EmployeeSpec,
      ChargeSheetFinder
    );

  ChargeSheet := TDocumentChargeSheet.Create(100);

  ChargeSheetImpl := TDocumentChargeSheet(ChargeSheet.Self);

  ChargeSheetImpl.WorkingRules := WorkingRules;
  
  Performer := TEmployee.Create(1);

  Performer.Name := 'Василий';
  Performer.Surname := 'Коротков';
  Performer.Patronymic := 'Борисович';
  Performer.Role := TRoleMemento.GetEmployeeRole;

  ChargeSheetImpl.IssuingEmployee := Performer;
  ChargeSheetImpl.EditingEmployee := ChargeSheetImpl.IssuingEmployee;
  
  ChargeSheetImpl.Performer := Performer;

  ChargeSheetImpl.ChargeText := 'Выполнить все служебки';
  ChargeSheetImpl.SetTimeFrameStartAndDeadline(
    Now, IncDay(Now, 14)
  );

  OverlappingChargeSheetPerformingService.PerformChargeSheetAsOverlapping(
    ChargeSheet, Performer, 'ANSWER', IncYear(Now, 2)
  );

  DebugOutput('ChargeText:' + ChargeSheetImpl.ChargeText);
    DebugOutput('Issuing Employee:' + ChargeSheetImpl.IssuingEmployee.FullName);
    DebugOutput('Performer: ' + ChargeSheetImpl.Performer.FullName);
    DebugOutput('Response: ' + ChargeSheetImpl.PerformerResponse);
    DebugOutput('Performing Date: ' + DateTimeToStr(ChargeSheetImpl.PerformingDate));
    DebugOutput('Actually Performed Employee: ' + ChargeSheetImpl.ActuallyPerformedEmployee.FullName);
    DebugOutput('Is Performed: ' + BoolToStr(ChargeSheetImpl.IsPerformed, True));


  for
    ChargeSheetImpl in
    TInMemoryDocumentChargeSheetFinder(ChargeSheetFinder.Self).ChargeSheets
  do begin

    DebugOutput('ChargeText:' + ChargeSheetImpl.ChargeText);
    DebugOutput('Issuing Employee:' + ChargeSheetImpl.IssuingEmployee.FullName);
    DebugOutput('Performer: ' + ChargeSheetImpl.Performer.FullName);
    DebugOutput('Response: ' + ChargeSheetImpl.PerformerResponse);
    DebugOutput('Performing Date: ' + DateTimeToStr(ChargeSheetImpl.PerformingDate));
    DebugOutput('Actually Performed Employee: ' + ChargeSheetImpl.ActuallyPerformedEmployee.FullName);
    DebugOutput('Is Performed: ' + BoolToStr(ChargeSheetImpl.IsPerformed, True));

  end;      }
  
end;

end.
