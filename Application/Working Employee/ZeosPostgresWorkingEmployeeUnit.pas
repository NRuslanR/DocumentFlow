{
  refactor:
    преобразовать в прикладную службу
    аутентификации }
unit ZeosPostgresWorkingEmployeeUnit;

interface

uses

  DBWorkingEmployeeUnit,
  Classes,
  SysUtils,
  DB,
  ZConnection;

type

  TZeosPostgresWorkingEmployee = class (TDBWorkingEmployee)

    private

      FConnection: TZConnection;

    protected

      procedure SetConnection(Connection: TComponent); override;
      function GetConnection: TComponent; override;

      function LoadWorkingEmployeeDataFromDatabase: TDataSet; override;
      procedure FillWorkingEmployeeFromLoadedDataSet(
        LoadedWorkingEmployeeDataSet: TDataSet
      ); override;

  end;

implementation

uses

  ZDataset,
  AuxZeosFunctions, ZAbstractRODataset, WorkingEmployeeUnit;
  
{ TZeosPostgresWorkingEmployee }

function TZeosPostgresWorkingEmployee.LoadWorkingEmployeeDataFromDatabase: TDataSet;
begin

  Result :=
    CreateAndExecuteQuery(
      FConnection,
      'SELECT ' +
      'id as id,' +
      'name, surname, patronymic,' +
      'personnel_number, leader_id, ' +
      'spr_person_id ' +
      'FROM doc.employees ' +
      'WHERE login=:plogin AND not was_dismissed and not is_foreign',
      ['plogin'],
      [FConnection.User]
    );

end;

procedure TZeosPostgresWorkingEmployee.FillWorkingEmployeeFromLoadedDataSet(
  LoadedWorkingEmployeeDataSet: TDataSet
);
var IdField: TField;
begin

  try

    IdField := LoadedWorkingEmployeeDataSet.FieldByName('id');

    if (LoadedWorkingEmployeeDataSet.RecordCount = 0) or
       (IdField.IsNull)
    then
      raise Exception.Create(
              'Отсутствуют сведения о сотруднике с таким логином ' +
              'или права на использование системы. Обратитесь к ' +
              'администратору.'
            );

    FId :=  LoadedWorkingEmployeeDataSet.FieldByName('id').AsInteger;
    FName := LoadedWorkingEmployeeDataSet.FieldByName('name').AsString;
    FSurname := LoadedWorkingEmployeeDataSet.FieldByName('surname').AsString;
    FPatronymic := LoadedWorkingEmployeeDataSet.FieldByName('patronymic').AsString;
    FPersonnelNumber := LoadedWorkingEmployeeDataSet.FieldByName('personnel_number').AsString;
    FLeaderId := LoadedWorkingEmployeeDataSet.FieldByName('leader_id').AsVariant;
    FGlobalUserId := LoadedWorkingEmployeeDataSet.FieldByName('spr_person_id').AsVariant

  finally

    LoadedWorkingEmployeeDataSet.Free;
    
  end;

end;

function TZeosPostgresWorkingEmployee.GetConnection: TComponent;
begin

  Result := FConnection;

end;

procedure TZeosPostgresWorkingEmployee.SetConnection(Connection: TComponent);
begin

  FConnection := Connection as TZConnection;

end;

end.
