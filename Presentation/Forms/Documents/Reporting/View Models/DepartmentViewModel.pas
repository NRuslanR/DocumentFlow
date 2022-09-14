unit DepartmentViewModel;

interface

uses

  SysUtils,
  Classes;
  
type

  TDepartmentViewModel = class

    private

      FId: Variant;
      FShortName: String;

    public

      constructor Create; overload;
      constructor Create(
        const Id: Variant;
        const ShortName: String
      ); overload;

    published

      property Id: Variant read FId write FId;
      property ShortName: String read FShortName write FShortName;

  end;

  TDepartmentsViewModel = class;
  
  TDepartmentsViewModelEnumerator = class

    private

      FCurrentIndex: Integer;
      FDepartmentsViewModel: TDepartmentsViewModel;

      function GetCurrentDepartmentViewModel: TDepartmentViewModel;
      
    public

      constructor Create(DepartmentsViewModel: TDepartmentsViewModel);

      function MoveNext: Boolean;
      
      property Current: TDepartmentViewModel
      read GetCurrentDepartmentViewModel;
      
  end;
  
  TDepartmentsViewModel = class

    private

      FDepartments: TList;

      function GetDepartmentViewModel(Index: Integer): TDepartmentViewModel;
      procedure SetDepartmentViewModel(
        Index: Integer;
        DepartmentViewModel: TDepartmentViewModel
      );
      function GetCount: Integer;
      
    public

      constructor Create;
      
      destructor Destroy; override;
      
      function Add(DepartmentViewModel: TDepartmentViewModel): Integer;
      procedure Remove(const Index: Integer);

      function GetEnumerator: TDepartmentsViewModelEnumerator;
      
      property Items[Index: Integer]: TDepartmentViewModel
      read GetDepartmentViewModel write SetDepartmentViewModel; default;

      property Count: Integer read GetCount;
      
  end;

implementation

uses

  AuxCollectionFunctionsUnit;
  
{ TDepartmentViewModel }

constructor TDepartmentViewModel.Create;
begin

  inherited Create;

end;

constructor TDepartmentViewModel.Create(
  const Id: Variant;
  const ShortName: String
);
begin

  inherited Create;

  FId := Id;
  FShortName := ShortName;
  
end;

{ TDepartmentsViewModel }

function TDepartmentsViewModel.Add(
  DepartmentViewModel: TDepartmentViewModel): Integer;
begin

  Result := FDepartments.Add(DepartmentViewModel);

end;

constructor TDepartmentsViewModel.Create;
begin

  inherited;

  FDepartments := TList.Create;
  
end;

destructor TDepartmentsViewModel.Destroy;
begin

  FreeListWithItems(FDepartments);
  inherited;

end;

function TDepartmentsViewModel.GetCount: Integer;
begin

  Result := FDepartments.Count;
  
end;

function TDepartmentsViewModel.GetDepartmentViewModel(
  Index: Integer): TDepartmentViewModel;
begin

  Result := TDepartmentViewModel(FDepartments[Index]);
   
end;

function TDepartmentsViewModel.GetEnumerator: TDepartmentsViewModelEnumerator;
begin

  Result := TDepartmentsViewModelEnumerator.Create(Self);
  
end;

procedure TDepartmentsViewModel.Remove(const Index: Integer);
var DepartmentViewModel: TDepartmentViewModel;
begin

  DepartmentViewModel := Self[Index];

  FDepartments.Delete(Index);

  DepartmentViewModel.Free;
  
end;

procedure TDepartmentsViewModel.SetDepartmentViewModel(Index: Integer;
  DepartmentViewModel: TDepartmentViewModel);
begin

  FDepartments[Index] := DepartmentViewModel;
  
end;

{ TDepartmentsViewModelEnumerator }

constructor TDepartmentsViewModelEnumerator.Create(
  DepartmentsViewModel: TDepartmentsViewModel);
begin

  inherited Create;

  FDepartmentsViewModel := DepartmentsViewModel;
  FCurrentIndex := -1;
  
end;

function TDepartmentsViewModelEnumerator.GetCurrentDepartmentViewModel: TDepartmentViewModel;
begin

  Result := FDepartmentsViewModel[FCurrentIndex];
  
end;

function TDepartmentsViewModelEnumerator.MoveNext: Boolean;
begin

  Result := FCurrentIndex < FDepartmentsViewModel.Count - 1;

  if Result then
    Inc(FCurrentIndex);

end;

end.
