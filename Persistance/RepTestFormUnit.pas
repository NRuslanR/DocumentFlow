unit RepTestFormUnit;

interface

{$MESSAGE WARN '"Внимание ! Редактирование объекта TPerformableDocument.Performings позволительно только для репозиториев. Клиентский код не должен делать этого ни в коем случае !!!"'}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  StdCtrls,
  ZConnection,
  DocumentChargeSheet;

type                               
  TForm7 = class(TForm)
    Button1: TButton;
    ZConnection1: TZConnection;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private
    { Private declarations }
    Variable: Integer;

    procedure RunDocumentChargeSheetRepository;
    function GenerateDocumentChargeSheets: TDocumentChargeSheets;
    
  public
    { Public declarations }

    function DeprecatedMethod: Integer; deprecated;
    constructor Create(AOwner: TComponent); override;
  end ;

var
  Form7: TForm7;

implementation

uses

  Role,
  IRoleRepositoryUnit,
  {EmployeeUnit,}
  RepositoryRegistryUnit,
  RoleRepositoryUnit,
  RolePostgresRepositoryUnit,
  Department,
  IDepartmentRepositoryUnit,
  EmployeeRepositoryUnit,
  IEmployeeRepositoryUnit,
  DepartmentRepositoryUnit,
  DocumentFileUnit,
  OutcommingServiceNoteUnit,
  IDocumentChargeSheetUnit,
  IOutcommingServiceNoteRepositoryUnit,
  OutcommingServiceNoteRepositoryUnit,
  IncommingServiceNoteRepositoryUnit,
  IncommingServiceNoteUnit,
  IIncommingServiceNoteRepositoryUnit,
  AuxDebugFunctionsUnit,
  IDocumentFilesRepositoryUnit,
  DocumentFilesRepositoryUnit,
  DocumentRelationsUnit,
  IDocumentRelationsRepositoryUnit,
  DocumentRelationsRepositoryUnit,
  Employee,
  DateUtils,
  DocumentChargeSheetPostgresRepository,
  ServiceNoteChargeSheetPostgresRepository,
  StrUtils,
  EmployeeReplacementPostgresRepository;

{$R *.dfm}

procedure TForm7.Button1Click(Sender: TObject);
var Role: TRole;
    RoleList: TRoleList;
    RoleRepository: IRoleRepository;
    Employee: TEmployee;
begin

   DeprecatedMethod;

   RoleRepository := TRepositoryRegistry.Current.GetRoleRepository;

   Role := RoleRepository.FindRoleById(2);

   OutputDebugString(PChar(Format('[Name:%s, Desc%s]', [Role.Name, ROle.Description])));

   Role := RoleRepository.FindRoleByName('SubLeader');

   OutputDebugString(PChar(Format('[Name:%s, Desc%s]', [Role.Name, ROle.Description])));

   RoleList := RoleRepository.LoadAllRoles;

   for Role in RoleList do
    OutputDebugString(PChar(Format('[Name:%s, Desc%s]', [Role.Name, ROle.Description])));

   Employee := TEmployee.Create(8);
   
   Role := RoleRepository.FindRoleForEmployee(Employee);

   OutputDebugString(PChar(Format('[Name:%s, Desc%s]', [Role.Name, ROle.Description])));

     
end;

procedure TForm7.Button2Click(Sender: TObject);
var Department: TDepartment;
    Departments: TDepartments;
    DepartmentCount: Integer;
    DepartmentRepository: IDepartmentRepository;

procedure OutputDepartment(Department: TDepartment);
begin;

  OutputDebugString(PChar(
    Format(
      '[Code: %s, ShortName: %s, FullName: %s]',
      [Department.Code, Department.ShortName, Department.FullName]
  )));
  
end;

begin

  DepartmentRepository := TRepositoryRegistry.Current.GetDepartmentRepository;

  Department := DepartmentRepository.FindDepartmentById(15);

  OutputDepartment(Department);

  Departments := DepartmentRepository.LoadAllDepartments;

  DepartmentCount := 0;
  
  for Department in Departments do begin

    Inc(DepartmentCount);
    OutputDepartment(Department);

  end;

  OutputDebugString(PChar(Format('Department Count: %d', [DepartmentCount])));

  Department := TDepartment.Create;

  Department.Code := '0123';
  Department.ShortName := 'TDN';
  Department.FullName := 'Test Department Name';
    
  DepartmentRepository.AddDepartment(Department);

  Department := DepartmentRepository.FindDepartmentById(Department.Identity);

  Assert(Assigned(Department), 'Department was not added in Repository!');
  
  OutputDepartment(Department);

  Department.ShortName := 'Changed TDN';
  Department.FullName := 'Domain-Driven Design';

  DepartmentRepository.UpdateDepartment(Department);

  Department := DepartmentRepository.FindDepartmentById(Department.Identity);

  OutputDepartment(Department);

  DepartmentRepository.RemoveDepartment(Department);

  Assert(
    DepartmentRepository.FindDepartmentById(Department.Identity) = nil,
    'Department is exists !'
  );

end;

procedure TForm7.Button3Click(Sender: TObject);
const

  SEARCH_EMPLOYEE_ID = 1356;

var Employee: TEmployee;
    Employees: TEmployees;
    EmployeeRepository: IEmployeeRepository;
    EmployeeCount: Integer;
    Deputy: TEmployee;
procedure OutputEmployee(Employee: TEmployee);
var TopEmp: TEmployee;
begin

  OutputDebugString(
    PChar(
      Format(
        '[Id: %s, Surname: %s, Speciality: %s, RoleId: %d, ' +
        'RoleName: %s, Email:%s, IsForeign: %s]',
        [VarToStr(Employee.Identity), Employee.Surname, Employee.Speciality,
        Integer(Employee.Role.Identity), Employee.Role.Name,
        Employee.Email, BoolToStr(Employee.IsForeign, True)]
      )
    )
  );

  if not Assigned(Employee.TopLevelEmployee) then
    Exit;

  TopEmp := Employee.TopLevelEmployee;
  
  DebugOutput(
    Format(
    '[TopLevelEmpId:%s, TopLevelEmpFullName: %s,' +
      'ToplevelEmpRoleId: %s, TopLevelEmpRoleName: %s,' +
      'ToplevelEmpEmail: %s, TopLevelEmpSpeciality: %s]',
      [
        TopEmp.Identity,
        TopEmp.FullName,
        TopEmp.Role.Identity,
        TopEmp.Role.Name,
        TopEmp.Email,
        TopEmp.Speciality
      ]
    )
  );

  
end;

begin

  EmployeeRepository := TRepositoryRegistry.Current.GetEmployeeRepository;

  Employee := EmployeeRepository.FindEmployeeById(1355);

  OutputEmployee(Employee);

  Employees := EmployeeRepository.LoadAllEmployees;

  EmployeeCount := 0;

  DebugOutput(
    'Total loaded employee count: ' +
    IntToStr(Employees.Count)
  );
  
  for Employee in Employees do begin

    Inc(EmployeeCount);
    OutputEmployee(Employee);

  end;

  OutputDebugString(PChar(Format('Emploee Count: %d', [EmployeeCount])));
         {
  Employees := EmployeeRepository.FindLeadersForEmployee(8);

  if Assigned(Employees) then begin

    for Employee in Employees do
      OutputEmployee(Employee);

  end;
              }
  Employee := TEmployee.Create;

  Employee.Name := 'Руслан';
  Employee.Surname := 'Нигматуллин';
  Employee.Patronymic := 'Отчество';
  Employee.Speciality := 'Программист';
  Employee.PersonnelNumber := '59968';
  Employee.TelephoneNumber := '22-17';
  Employee.DepartmentIdentity := '10';
  Employee.TopLevelEmployee := TEmployee.Create(29);
  Employee.TopLevelEmployee.Name := 'Борис';
  Employee.TopLevelEmployee.Patronymic := 'Яковлевич';
  Employee.TopLevelEmployee.Surname := 'Топорков';
  Employee.TopLevelEmployee.Role := TRoleMemento.GetLeaderRole;
  Employee.Role := TRoleMemento.GetEmployeeRole;

  Deputy := TEmployee.Create(38);

  Deputy.Name := 'Валерий';
  Deputy.Surname := 'Буздалов';
  Deputy.Patronymic := 'Сергеевич';
  Deputy.Role := TRoleMemento.GetEmployeeRole;

  Employee.AssignAsPermanentDeputy(Deputy);

  Deputy := TEmployee.Create(40);

  Deputy.Name := 'Александр';
  Deputy.Surname := 'Земсков';
  Deputy.Patronymic := 'Валерьевич';
  Deputy.Role := TRoleMemento.GetSecretaryRole;

  Employee.AssignAsTemporaryDeputyOrChangeReplacementPeriodFor(
    Deputy, Now, IncDay(Now, 6)
  );

  EmployeeRepository.AddEmployee(Employee);

  Employee := EmployeeRepository.FindEmployeeById(Employee.Identity);

  Assert(Assigned(Employee), 'Employee is not exists');

  Employee.PersonnelNumber := '59999';
  Employee.TelephoneNumber := '33-33';

  EmployeeRepository.UpdateEmployee(Employee);

  Employee := EmployeeRepository.FindEmployeeById(Employee.Identity);

  Assert(Assigned(Employee), 'Employee is not exists');

  EmployeeRepository.RemoveEmployee(Employee);

  Employee := EmployeeRepository.FindEmployeeById(Employee.Identity);

  Assert(not Assigned(Employee), 'Employee was not removed');

end;

procedure TForm7.Button4Click(Sender: TObject);
var It, OutcommingServiceNote: TOutcommingServiceNote;

    OutcommingServiceNotes: TOutcommingServiceNotes;
    Repository: IOutcommingServiceNoteRepository;
    Employee: TEmployee;
    Result: TOutcommingServiceNotePerformingResult;
    EditingEmployee: TEmployee;
begin

  Repository := TRepositoryRegistry.Current.GetOutcommingServiceNoteRepository;

  OutcommingServiceNote := TOutcommingServiceNote.Create;

  EditingEmployee := TEmployee.Create(8);

  OutcommingServiceNote.Author := EditingEmployee;

  DebugOutput(OutcommingServiceNote.CurrentWorkCycleStageName);

  OutcommingServiceNote.EditingEmployee := EditingEmployee;

  OutcommingServiceNote.Number := 'testNumber';
  OutcommingServiceNote.Name := 'testName';
  OutcommingServiceNote.CreationDate := Now;
  OutcommingServiceNote.Note := 'testNote';
  OutcommingServiceNote.Content := 'testContent';

  Employee := TEmployee.Create(9);

  Result := TOutcommingServiceNotePerformingResult.Create;

  Result.PerformingDate := Now;
  Result.Comment := 'testComment';

  OutcommingServiceNote.Performings.AddPerforming(
    Employee, '', Result
  );

  Employee := TEmployee.Create(10);

  Result := TOutcommingServiceNotePerformingResult.Create;

  Result.PerformingDate := Now;
  Result.Comment := 'Comment2';


  OutcommingServiceNote.Performings.AddPerforming(
    Employee, '', Result
  );

  Employee := TEmployee.Create(11);

  OutcommingServiceNote.Signer := Employee;

  OutcommingServiceNote.ResponsibleIdentity := 1000;

  Repository.AddOutcommingServiceNote(OutcommingServiceNote);

  OutcommingServiceNote := Repository.FindOutcommingServiceNoteById(OutcommingServiceNote.Identity);

  Assert(Assigned(OutcommingServiceNote), 'Service Note is not exists');

  OutcommingServiceNotes := Repository.LoadAllOutcommingServiceNotes;

  for It in OutcommingServiceNotes do ;

  OutcommingServiceNote.Number := 'Changed number';
  OutcommingServiceNote.Content := 'Changed content';
  OutcommingServiceNote.Note := 'zxcxzfd';

  Repository.UpdateOutcommingServiceNote(OutcommingServiceNote);

  Repository.RemoveOutcommingServiceNote(OutcommingServiceNote);

  OutcommingServiceNote := Repository.FindOutcommingServiceNoteById(
                            OutcommingServiceNote.Identity
                            );

  Assert(not Assigned(OutcommingServiceNote), 'Service Note is exists !');
  
end;

procedure TForm7.Button5Click(Sender: TObject);
var Incomming: TIncommingServiceNote;
    OutcommingServiceNote: TOutcommingServiceNote;
    Incommings, Incommings1: TIncommingServiceNotes;
    Employee: TEmployee;
    Result: TOutcommingServiceNotePerformingResult;
    Repository: IIncommingServiceNoteRepository;
    OutRepository: IOutcommingServiceNoteRepository;
    topLevel: Variant;
begin

  Repository := TRepositoryRegistry.Current.GetIncommingServiceNoteRepository;

  Incommings := Repository.FindIncommingServiceNotesCreatedOnBaseOf(14);

  for Incomming in Incommings do
    DebugOutput(Incomming.TopLevelIncommingServiceNoteId);
    

{  OutRepository := TRepositoryRegistry.Current.GetOutcommingServiceNoteRepository;

  OutcommingServiceNote := TOutcommingServiceNote.Create;

  OutcommingServiceNote.Number := 'testNumber';
  OutcommingServiceNote.Name := 'testName';
  OutcommingServiceNote.CreationDate := Now;
  OutcommingServiceNote.Note := 'testNote';
  OutcommingServiceNote.Content := 'testContent';

  Employee := TEmployee.Create(9);

  Result := TOutcommingServiceNotePerformingResult.Create;

  Result.PerformingDate := Now;
  Result.Comment := 'testComment';

  OutcommingServiceNote.Performings.AddPerforming(
    Employee, '', Result
  );

  Employee := TEmployee.Create(10);

  Result := TOutcommingServiceNotePerformingResult.Create;

  Result.PerformingDate := Now;
  Result.Comment := 'Comment2';

  OutcommingServiceNote.Performings.AddPerforming(
    Employee, '', Result
  );

  Employee := TEmployee.Create(11);

  OutcommingServiceNote.Signer := Employee;

  OutcommingServiceNote.ResponsibleIdentity := 1000;

  OutRepository.AddOutcommingServiceNote(OutcommingServiceNote);

  Incomming := TIncommingServiceNote.Create;

  Incomming := TIncommingServiceNote.Create;

  Incomming.OutcommingServiceNoteId := OutcommingServiceNote.Identity;
  Incomming.Number := 'IncommingNumber1';
  Incomming.CreationDate := Now;

  Incomming.AddPerformer(TEmployee.Create(9));

  Repository.AddIncommingServiceNote(Incomming);

  Incomming := TIncommingServiceNote.Create;
  
  Incomming.OutcommingServiceNoteId := OutcommingServiceNote.Identity;
  Incomming.Number := 'IncommingNumber2';
  Incomming.CreationDate := Now;

  Incomming.AddPerformer(TEmployee.Create(10));
  
  Repository.AddIncommingServiceNote(Incomming);

  toplevel := Incomming.Identity;
  
  Incommings := Repository.LoadAllIncommingServiceNotes;

  for Incomming in Incommings do begin

    OutputDebugString(PChar(Incomming.Number));
    
  end;

  Incomming := TIncommingServiceNote.Create;

  Incomming.OutcommingServiceNoteId := OutcommingServiceNote.Identity;
  Incomming.TopLevelIncommingServiceNoteId := topLevel;
  Incomming.Number := 'SubordinateInputNumber';
  Incomming.CreationDate := Now;

  Incomming.AddPerformer(TEmployee.Create(12));
  
  Repository.AddIncommingServiceNote(Incomming);

  Incomming := Repository.FindIncommingServiceNoteById(Incomming.Identity);

  Incomming.Number := 'ExecuteNumber';
  Incomming.PerformBy(Incomming.Performings[0].Performer, 'Subordinate Comment');

  Repository.UpdateIncommingServiceNote(Incomming);

  Repository.RemoveIncommingServiceNote(Incomming);

  Incomming := Repository.FindIncommingServiceNoteById(Incomming.Identity);

  Assert(not Assigned(Incomming), 'Incomming is exists');

  OutcommingServiceNote := TOutcommingServiceNote.Create;

  OutcommingServiceNote.Number := 'Number1233456';
  OutcommingServiceNote.Name := 'NAME_DOCUEMTN';
  OutcommingServiceNote.CreationDate := Now;
  OutcommingServiceNote.Note := 'dawdawd';
  OutcommingServiceNote.Content := 'vxcvxcvxcvxcvxcvcxvxcvxcvx';

  Employee := TEmployee.Create(13);

  Result := TOutcommingServiceNotePerformingResult.Create;

  Result.PerformingDate := Now;

  OutcommingServiceNote.Performings.AddPerforming(
    Employee, '', Result
  );

  Employee := TEmployee.Create(16);

  Result := TOutcommingServiceNotePerformingResult.Create;

  Result.PerformingDate := Now;

  OutcommingServiceNote.Performings.AddPerforming(
    Employee, '', Result
  );

  Employee := TEmployee.Create(17);

  Result := TOutcommingServiceNotePerformingResult.Create;

  Result.PerformingDate := Now;

  OutcommingServiceNote.Performings.AddPerforming(
    Employee, '', Result
  );

  Employee := TEmployee.Create(18);

  OutcommingServiceNote.Signer := Employee;

  OutcommingServiceNote.ResponsibleIdentity := 1000;

  OutRepository.AddOutcommingServiceNote(OutcommingServiceNote);

  Incommings := TIncommingServiceNotes.Create;

  Incomming := TIncommingServiceNote.Create;
  Incomming.Number := 'TopLevelInc1';
  Incomming.CreationDate := Now;
  Incomming.OutcommingServiceNoteId := OutcommingServiceNote.Identity;
  Incomming.Performings.AddPerforming(
    TEmployee.Create(13)
  );

  Incommings.Add(Incomming);

  Incomming := TIncommingServiceNote.Create;

  Incomming.Number :=' TopLevelInc2';
  Incomming.CreationDate := Now;
  Incomming.OutcommingServiceNoteId := OutcommingServiceNote.Identity;
  Incomming.Performings.AddPerforming(
    TEmployee.Create(16)
  );

  Incommings.Add(Incomming);

  Incomming := TIncommingServiceNote.Create;

  Incomming.Number :=' TopLevelInc3';
  Incomming.CreationDate := Now;
  Incomming.OutcommingServiceNoteId := OutcommingServiceNote.Identity;
  Incomming.Performings.AddPerforming(
    TEmployee.Create(17)
  );

  Incommings.Add(Incomming);

  Repository.AddHeadIncommingServiceNotes(Incommings);

  for Incomming in Incommings do begin

    DebugOutput(Incomming.Identity);
    
  end;

  Incommings1 := TIncommingServiceNotes.Create;

  Incomming := TIncommingServiceNote.Create;
  Incomming.TopLevelIncommingServiceNoteId := Incommings[0].Identity;
  Incomming.Number := 'SubordianteTopLevelInc1';
  Incomming.CreationDate := Now;
  Incomming.OutcommingServiceNoteId := OutcommingServiceNote.Identity;
  Incomming.Performings.AddPerforming(
    TEmployee.Create(20)
  );

  Incommings1.Add(Incomming);

  Incomming := TIncommingServiceNote.Create;

  Incomming.TopLevelIncommingServiceNoteId := Incommings[1].Identity;
  Incomming.Number :='SubordianteTopLevelInc2';
  Incomming.CreationDate := Now;
  Incomming.OutcommingServiceNoteId := OutcommingServiceNote.Identity;
  Incomming.Performings.AddPerforming(
    TEmployee.Create(21)
  );

  Incommings1.Add(Incomming);

  Incomming := TIncommingServiceNote.Create;

  Incomming.TopLevelIncommingServiceNoteId := Incommings[2].Identity;
  Incomming.Number :='SubordianteTopLevelInc3';
  Incomming.CreationDate := Now;
  Incomming.OutcommingServiceNoteId := OutcommingServiceNote.Identity;
  Incomming.Performings.AddPerforming(
    TEmployee.Create(22)
  );

  Incommings1.Add(Incomming);

  Repository.AddSubordinateIncommingServiceNotes(Incommings1);

  for Incomming in Incommings1 do begin

    DebugOutput(Incomming.Identity);
    
  end;     }

end;

procedure TForm7.Button6Click(Sender: TObject);
var DocumentFile: TDocumentFile;
    Repository: IDocumentFilesRepository;
    DocumentFiles: TDocumentFiles;
begin

  Repository := TRepositoryRegistry.Current.GetDocumentFilesRepository;

  Repository.DocumentType := TIncommingServiceNote;
  
  DocumentFile := TDocumentFile.Create;

  DocumentFile.DocumentId := 223990;
  DocumentFile.FileName := 'Файл документа';
  DocumentFile.FilePath := Application.ExeName;

  Repository.AddDocumentFile(DocumentFile);

  DocumentFile := TDocumentFile.Create;

  DocumentFile.DocumentId := 223990;
  DocumentFile.FileName := 'File1';
  DocumentFile.FilePath := 'Application';

  DocumentFiles := TDocumentFiles.Create;

  DocumentFiles.AddDomainObject(DocumentFile);

  DocumentFiles.AddDomainObject(
    TDocumentFile.Create(Unassigned, 223990, 'File2', 'Path2')
  );
  DocumentFiles.AddDomainObject(TDocumentFile.Create(Unassigned, 223990, 'File3', 'Path3'));

  Repository.AddDocumentFiles(DocumentFiles);

  DocumentFiles := Repository.FindFilesForDocument(223990);

  for DocumentFile in DocumentFiles do
    DebugOutput(Format('[%s,%s,"%s","%s"]',
    [VarToStr(DocumentFile.Identity), VarToStr(DocumentFile.DocumentId),
     DocumentFile.FileName, DocumentFile.FilePath]));
    
  DocumentFile := DocumentFiles[0];

  DocumentFile.FileName := 'NEW_FILE_NAME';
  DocumentFile.FilePath := 'NEW_FILE_PATH';

  Repository.UpdateDocumentFile(DocumentFile);

  Repository.RemoveDocumentFile(DocumentFile);

  Repository.RemoveAllFilesForDocument(223990);

end;

procedure TForm7.Button7Click(Sender: TObject);
var DocumentRelations: TDocumentRelations;
    Repository: IDocumentRelationsRepository;
begin

  Repository := TRepositoryRegistry.Current.GetDocumentRelationsRepository;

  Repository.DocumentType := TIncommingServiceNote;

  DocumentRelations := TDocumentRelations.Create(227150);
  
end;

procedure TForm7.Button8Click(Sender: TObject);
var Repository: TEmployeeReplacementPostgresRepository;
    Replacements: TEmployeeReplacements;
    Replacement: TEmployeeReplacement;

  procedure PrintEmployeeReplacement(EReplacements: TEmployeeReplacements);
  var EReplacement: TEmployeeReplacement;
  begin

    for EReplacement in EReplacements do begin

      DebugOutput('ReplaceableEmployee:' + VarToStr(EReplacement.ReplaceableEmployeeId));
      DebugOutput('DeputyId:' + VarToStr(EReplacement.DeputyId));

      if EReplacement.IsPermanent then
        DebugOutput('Is Permanent: True')

      else begin

        DebugOutput('Is Permanent: False');
        DebugOutput('PeriodStart:' + VarToStr(EReplacement.PeriodStart));
        DebugOutput('PeriodEnd:' + VarToStr(EReplacement.PeriodEnd));

      end;
      
    end;
      
  end;

begin

  Repository := TEmployeeReplacementPostgresRepository.Create(ZConnection1);

  Replacements := Repository.FindEmployeeReplacements(6);

  Assert(not Assigned(Replacements), 'Replacements must not be assigned');

  Replacements := TEmployeeReplacements.Create;

  Replacement :=
    TEmployeeReplacement.CreateAsPermanent(
      1333, 1355
    );

  Replacements.AddDomainObject(Replacement);

  Replacement :=
    TEmployeeReplacement.Create(
      1336, 1356, Now, IncMonth(Now)
    );

  Replacements.AddDomainObject(Replacement);

  Replacement :=
    TEmployeeReplacement.CreateAsPermanent(
      1359, 1357
    );

  Replacements.AddDomainObject(Replacement);

  Replacement :=
    TEmployeeReplacement.Create(
      1333, 1356, Now, IncDay(Now, 12)
    );

  Replacements.AddDomainObject(Replacement);

  Replacement :=
    TEmployeeReplacement.Create(
      1333, 1359, Now, IncDay(Now, 4)
    );

  Replacements.AddDomainObject(Replacement);

  Repository.AddEmployeeReplacements(Replacements);

  Replacements := Repository.FindEmployeeReplacements(1333);

  Assert(Assigned(Replacements), 'Replacements must be assigned');
  Assert(Replacements.Count = 3, 'Replacements not equal to 3');

  PrintEmployeeReplacement(Replacements);
  
  Repository.RemoveAllEmployeeReplacements(1333);

  Replacements := Repository.FindEmployeeReplacements(1333);

  Assert(not Assigned(Replacements), 'Replacements must not be assigned');
  
end;

procedure TForm7.Button9Click(Sender: TObject);
begin

  RunDocumentChargeSheetRepository;

end;

constructor TForm7.Create(AOwner: TComponent);
begin

  inherited;

  TRepositoryRegistry.Current.RegisterEmployeeRepository(
    TCompositeEmployeePostgresRepository.Create(ZConnection1)
  );

  TRepositoryRegistry.Current.RegisterDepartmentRepository(
    TCompositeDepartmentPostgresRepository.Create(ZConnection1)
  );

  TRepositoryRegistry.Current.RegisterRoleRepository(
    TCompositeRolePostgresRepository.Create(ZConnection1)
  );

  TRepositoryRegistry.Current.RegisterOutcommingServiceNoteRepository(
    TCompositeOutcommingServiceNotePostgresRepository.Create(
      ZConnection1
    )
  );

  TRepositoryRegistry.Current.RegisterIncommingServiceNoteRepository(
    TCompositeIncommingServiceNoteRepository.Create(ZConnection1)
  );

  TRepositoryRegistry.Current.RegisterDocumentFilesRepository(
    TCompositeDocumentFilesPostgresRepository.Create(ZConnection1)
  );

  TRepositoryRegistry.Current.RegisterDocumentRelationsRepository(
    TCompositeDocumentRelationsPostgresRepository.Create(ZConnection1)
  );
  
end;

function TForm7.DeprecatedMethod: Integer;
begin

  Result := 0;
  
end;

function TForm7.GenerateDocumentChargeSheets: TDocumentChargeSheets;
var cs: TDocumentChargeSheet;
    emp1, emp2: TEmployee;
begin

  Result := TDocumentChargeSheets.Create;

  emp1 := TEmployee.Create(1355);
  emp2 := TEmployee.Create(1356);

  cs := TDocumentChargeSheet.Create;

  cs.InvariantsComplianceRequested := False;

  cs.ChargeText := 'Поручение 1';
  cs.Performer := emp2;
  cs.IssuingEmployee := emp1;
  cs.SetTimeFrameStartAndDeadline(Now, IncMonth(Now, 2));
  cs.DocumentId := 2023;

  Result.AddDocumentChargeSheet(cs);

  cs := TDocumentChargeSheet.Create;

  cs.InvariantsComplianceRequested := False;

  emp2 := TEmployee.Create(1379);

  cs.ChargeText := 'Поручение 2';
  cs.Performer := emp2;
  cs.IssuingEmployee := emp1;
  cs.SetTimeFrameStartAndDeadline(Now, IncDay(Now, 3));
  cs.DocumentId := 2024;

  Result.AddDocumentChargeSheet(cs);

  cs := TDocumentChargeSheet.Create;

  cs.InvariantsComplianceRequested := False;

  emp2 := TEmployee.Create(1378);

  cs.ChargeText := 'Поручение 3';
  cs.Performer := emp2;
  cs.IssuingEmployee := emp1;
  cs.SetTimeFrameStartAndDeadline(Now, IncDay(Now, 11));
  cs.DocumentId := 2023;
  cs.TopLevelChargeSheetId := 2023;
  
  Result.AddDocumentChargeSheet(cs);

  cs := TDocumentChargeSheet.Create;

  cs.InvariantsComplianceRequested := False;
  
  emp2 := TEmployee.Create(1360);

  cs.ChargeText := 'Поручение 4';
  cs.Performer := emp2;
  cs.IssuingEmployee := emp1;
  cs.SetTimeFrameStartAndDeadline(Now, IncDay(Now, 23));
  cs.DocumentId := 2024;
  cs.TopLevelChargeSheetId := 2024;
  Result.AddDocumentChargeSheet(cs);
  
end;

procedure TForm7.RunDocumentChargeSheetRepository;
var Repository: TServiceNoteChargeSheetPostgresRepository;
    DocumentChargeSheet: TDocumentChargeSheet;
    var IssuingEmployee, Performer, ActualPerformer: TEmployee;
        ChargeSheets: TDocumentChargeSheets;
    cs: TDocumentChargeSheet;
  procedure OutputDocumentChargeSheet(ChargeSheet: TDocumentChargeSheet);
  begin

    Application.MessageBox(
      PChar(Format(
        '[Id: %s, Charge: %s, TimeFrameStart: %s, TimeFrameEnd: %s,' +
        'IssuingEmployee: %s, Performer: %s, ActualPerformer: %s,' +
        'DocumentId: %s, TopLevelChargeSheetId: %s, IsPerformed: %s,' +
        'PerformerResponse: %s]',
        [
          VarToStr(ChargeSheet.Identity),
          ChargeSheet.ChargeText,
          VarToStr(ChargeSheet.TimeFrameStart),
          VarToStr(ChargeSheet.TimeFrameDeadline),
          ChargeSheet.IssuingEmployee.FullName,
          ChargeSheet.Performer.FullName,{
          IfThen(
            Assigned(ChargeSheet.ActuallyPerformedEmployee),
            ChargeSheet.ActuallyPerformedEmployee.FullName
          ),      } 'none',
          VarToStr(ChargeSheet.DocumentId),
          VarToStr(ChargeSheet.TopLevelChargeSheetId),
          BoolToStr(ChargeSheet.IsPerformed, True),
          ChargeSheet.PerformerResponse
        ]
      )),
      'Title',
      MB_OK
    );

    if Assigned(ChargeSheet.ActuallyPerformedEmployee) then
      Application.MessageBox(
        PChar(
          Format('[ActualPerformedEmployee: %s]',
            [ChargeSheet.ActuallyPerformedEmployee.FullName]
          )
        ),
        'Title',
        MB_OK
      );
    
    
  end;
  
begin

  Repository := TServiceNoteChargeSheetPostgresRepository.Create(ZConnection1);

  try

    ChargeSheets :=
      Repository.FindAllSubordinateChargeSheetsForGivenChargeSheet(
        824
      );


    for cs in ChargeSheets do
      OutputDocumentChargeSheet(cs);
      

    DocumentChargeSheet := Repository.FindDocumentChargeSheetById(1886);

    Assert(Assigned(DocumentChargeSheet), 'DocumentChargeSheet must be assigned');

    OutputDocumentChargeSheet(DocumentChargeSheet);

    DocumentChargeSheet := TDocumentChargeSheet.Create;

    DocumentChargeSheet.InvariantsComplianceRequested := False;

    IssuingEmployee := TEmployee.Create(1333);

    IssuingEmployee.Name := 'Олег';
    IssuingEmployee.Surname := 'Аисов';
    IssuingEmployee.Patronymic := 'Бариевич';
    IssuingEmployee.Role := TRoleMemento.GetEmployeeRole;

    Performer := TEmployee.Create(1355);

    Performer.Name := 'Руслан';
    Performer.Surname := 'Нигматуллин';
    Performer.Patronymic := 'Радикович';
    Performer.Role := TRoleMemento.GetEmployeeRole;
    
    DocumentChargeSheet.IssuingEmployee := IssuingEmployee;
    DocumentChargeSheet.Performer := Performer;
    DocumentChargeSheet.ChargeText := 'Выполнить поручение';
    DocumentChargeSheet.SetTimeFrameStartAndDeadline(
      Now, IncDay(Now, 19)
    );

    OutputDocumentChargeSheet(DocumentChargeSheet);
    
    Repository.AddDocumentChargeSheet(DocumentChargeSheet);

    ActualPerformer := TEmployee.Create(1356);

    ActualPerformer.Name := 'Сергей';
    ActualPerformer.Surname := 'Вадимов';
    ActualPerformer.Patronymic := 'Вадимович';
    ActualPerformer.Role := TRoleMemento.GetSecretaryRole;
    
    DocumentChargeSheet.PerformBy(
      ActualPerformer, 'Поручение исполнено !'
    );

    Repository.UpdateDocumentChargeSheet(DocumentChargeSheet);

    DocumentChargeSheet := Repository.FindDocumentChargeSheetById(
                              DocumentChargeSheet.Identity
                            );

    OutputDocumentChargeSheet(DocumentChargeSheet);

    Repository.RemoveDocumentChargeSheet(DocumentChargeSheet);

    DocumentChargeSheet := Repository.FindDocumentChargeSheetById(
                                    DocumentChargeSheet.Identity
                            );

    Assert(
      not Assigned(DocumentChargeSheet),
      'Charge Sheet must not be assigned'
    );

    ChargeSheets := GenerateDocumentChargeSheets;

    Repository.AddDocumentChargeSheets(ChargeSheets);

    if Repository.HasError then
      raise Exception.Create(Repository.LastError.ErrorMessage);

    for cs in ChargeSheets do
      OutputDocumentChargeSheet(cs);

    cs := ChargeSheets[0];

    cs.PerformBy(
      cs.Performer, 'Поручение 1 выполнено'
    );

    cs := ChargeSheets[1];

    cs.PerformBy(
      cs.Performer, 'Поручение 2 выполнено'
    );

    cs := ChargeSheets[2];

    cs.PerformBy(
      cs.Performer, 'Поручение 3 уже выполнено !'
    );

    cs := ChargeSheets[3];

    cs.PerformBy(
      cs.Performer, 'Поручение 4 также выполнено !'
    );

    Repository.UpdateDocumentChargeSheets(ChargeSheets);   

  finally

    FreeAndNil(Repository);

  end;
  
end;

end.
