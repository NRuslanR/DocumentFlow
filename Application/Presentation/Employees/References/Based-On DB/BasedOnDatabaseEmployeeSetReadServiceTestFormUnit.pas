unit BasedOnDatabaseEmployeeSetReadServiceTestFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  EmployeeSetReadService,
  BasedOnDatabaseEmployeeSetReadService,
  ZQueryExecutor,
  EmployeeSetHolder,
  EmployeeDbSchema,
  DepartmentDbSchema, ZConnection;

type
  TBasedOnDatabaseEmployeeSetReadServiceTestForm = class(TForm)
    Button1: TButton;
    ZConnection1: TZConnection;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

    FEmployeeSetReadService: IEmployeeSetReadService;

    procedure CreateEmployeeSetReadService;
    procedure RunEmployeeSetReadServiceTest;
    
  public
    { Public declarations }
  end;

var
  BasedOnDatabaseEmployeeSetReadServiceTestForm: TBasedOnDatabaseEmployeeSetReadServiceTestForm;

implementation

uses

  AuxDebugFunctionsUnit;

{$R *.dfm}

procedure TBasedOnDatabaseEmployeeSetReadServiceTestForm.Button1Click(
  Sender: TObject);
begin

  RunEmployeeSetReadServiceTest;
  
end;

procedure TBasedOnDatabaseEmployeeSetReadServiceTestForm.CreateEmployeeSetReadService;
var EmployeeDbSchema: TEmployeeDbSchema;
    DepartmentDbSchema: TDepartmentDbSchema;
begin

  EmployeeDbSchema := TEmployeeDbSchema.Create;

  EmployeeDbSchema.TableName := 'doc.employees';
  EmployeeDbSchema.IdColumnName := 'outside_id';
  EmployeeDbSchema.PersonnelNumberColumnName := 'personnel_number';
  EmployeeDbSchema.NameColumnName := 'name';
  EmployeeDbSchema.SurnameColumnName := 'surname';
  EmployeeDbSchema.PatronymicColumnName := 'patronymic';
  EmployeeDbSchema.SpecialityColumnName := 'speciality';
  EmployeeDbSchema.DepartmentIdColumnName := 'department_id';
  EmployeeDbSchema.HeadDepartmentIdColumnName := 'head_department_id';
  EmployeeDbSchema.TelephoneNumberColumnName := 'telephone_number';
  EmployeeDbSchema.IsForeignColumnName := 'is_foreign';

  DepartmentDbSchema := TDepartmentDbSchema.Create;

  DepartmentDbSchema.TableName := 'doc.departments';
  DepartmentDbSchema.IdColumnName := 'outside_id';
  DepartmentDbSchema.CodeColumnName := 'code';
  DepartmentDbSchema.ShortNameColumnName := 'short_name';
  DepartmentDbSchema.FullNameColumnName := 'full_name';
  
  FEmployeeSetReadService :=
    TBasedOnDatabaseEmployeeSetReadService.Create(
      EmployeeDbSchema,
      DepartmentDbSchema,
      TZQueryExecutor.Create(ZConnection1)
    );

end;

procedure TBasedOnDatabaseEmployeeSetReadServiceTestForm.FormCreate(
  Sender: TObject);
begin

  CreateEmployeeSetReadService;
  
end;

procedure TBasedOnDatabaseEmployeeSetReadServiceTestForm.RunEmployeeSetReadServiceTest;
var EmployeeSetHolder: TEmployeeSetHolder;
begin

  EmployeeSetHolder :=
    FEmployeeSetReadService.GetEmployeeSetFromOtherEmployeeDepartment(
      1355
    );

  DebugOutput(EmployeeSetHolder.RecordCount);

end;

end.
