unit DBWorkingEmployeeUnit;

interface

uses

  WorkingEmployeeUnit,
  IWorkingEmployeeUnit,
  Classes,
  DB;

type

  TDBWorkingEmployee = class abstract (TWorkingEmployee)

    protected

      procedure SetConnection(Connection: TComponent); virtual; abstract;
      function GetConnection: TComponent; virtual; abstract;

      function LoadWorkingEmployeeDataFromDatabase: TDataSet; virtual; abstract;
      procedure FillWorkingEmployeeFromLoadedDataSet(
        LoadedWorkingEmployeeDataSet: TDataSet
      ); virtual; abstract;

    public

      constructor Create(Connection: TComponent);

      property Connection: TComponent read GetConnection write SetConnection;

      procedure LoadFromDatabase;

  end;

implementation

{ TDBWorkingEmployee }

constructor TDBWorkingEmployee.Create(Connection: TComponent);
begin

  inherited Create;

  SetConnection(Connection);

end;

procedure TDBWorkingEmployee.LoadFromDatabase;
begin

  FillWorkingEmployeeFromLoadedDataSet(LoadWorkingEmployeeDataFromDatabase);
  
end;

end.
